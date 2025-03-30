import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/sale_report_cubit/sale_report_cubit.dart';
import 'package:shan_shan/core/component/internet_check.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:sunmi_printer_plus/column_maker.dart';
import 'package:sunmi_printer_plus/enums.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';
import 'package:sunmi_printer_plus/sunmi_style.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  /// must binding ur printer at first init in app
  Future<bool?> _bindingPrinter() async {
    final bool? result = await SunmiPrinter.bindingPrinter();
    return result;
  }

  bool printBinded = false;
  int paperSize = 0;
  String serialNumber = "";
  String printerVersion = "";
  bool alreadyPrint = false;

  @override
  void initState() {
    super.initState();

    context.read<SaleReportCubit>().getDailyReport();

    ///initialize sunmi printer
    _bindingPrinter().then((bool? isBind) async {
      SunmiPrinter.paperSize().then((int size) {
        setState(() {
          paperSize = size;
        });
      });

      SunmiPrinter.printerVersion().then((String version) {
        setState(() {
          printerVersion = version;
        });
      });

      SunmiPrinter.serialNumber().then((String serial) {
        setState(() {
          serialNumber = serial;
        });
      });

      setState(() {
        printBinded = isBind!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("အရောင်းအစီရင်ခံစာ"),
          leadingWidth: 100,
          centerTitle: true,
          leading: appBarLeading(
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        floatingActionButton: _floatingActionButton(),
        body: InternetCheckWidget(
          child: _mainForm(context),
          onRefresh: () {},
        ),
      ),
    );
  }

  ///floating action button to printout reports
  BlocBuilder<SaleReportCubit, SaleReportState> _floatingActionButton() {
    return BlocBuilder<SaleReportCubit, SaleReportState>(
      builder: (context, state) {
        return FloatingActionButton.extended(
          backgroundColor: ColorConstants.primaryColor,
          onPressed: () {
            if (state is SaleReportDaily) {
              print("todal : ${state.saleReport.daily_date}");
              _printReceipt(
                cashAmount: state.saleReport.total_paid_cash ?? 0,
                KpayAmount: state.saleReport.total_paid_online ?? 0,
                totalAmount: state.saleReport.total_Grands ?? 0,
                taxAmount: 500,
                discountAmount: 0,
                report: "${state.saleReport.daily_date}",
              );
            } else if (state is SaleReportWeekly) {
              print("start of week : ${state.saleReport.start_of_week}");
              print("end of week : ${state.saleReport.end_of_week}");
              _printReceipt(
                cashAmount: state.saleReport.total_paid_cash ?? 0,
                KpayAmount: state.saleReport.total_paid_online ?? 0,
                totalAmount: state.saleReport.total_Grands ?? 0,
                taxAmount: 500,
                discountAmount: 0,
                report:
                    "${state.saleReport.start_of_week} to ${state.saleReport.end_of_week}",
              );
            } else if (state is SaleReportMonthly) {
              print("current month : ${state.currentMonthSale.current_month}");
              print("last month : ${state.lastMonthSale.past_month}");
              _printMontylyReport(
                lastMonthDate: state.lastMonthSale.past_month ?? "",
                currentMonthDate: state.currentMonthSale.current_month ?? "",
                lastMonthcashAmount: state.lastMonthSale.total_paid_cash ?? 0,
                lastMonthKpayAmount: state.lastMonthSale.total_paid_online ?? 0,
                lastMonthtotalAmount: state.lastMonthSale.total_Grands ?? 0,
                currentMonthcashAmount:
                    state.currentMonthSale.total_paid_cash ?? 0,
                currentMonthKpayAmount:
                    state.currentMonthSale.total_paid_online ?? 0,
                currentMonthtotalAmount:
                    state.currentMonthSale.total_Grands ?? 0,
              );
            }
          },
          label: Text("အရောင်းအစီရင်ခံစာပရင့်ထုတ်ရန်"),
          icon: Icon(CupertinoIcons.printer),
        );
      },
    );
  }

  ///main form of the page
  Column _mainForm(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(horizontal: SizeConst.kHorizontalPadding),
          child: TabBar(
            onTap: (value) {
              print("current value : ${value}");
              if (value == 0) {
                context.read<SaleReportCubit>().getDailyReport();
              } else if (value == 1) {
                context.read<SaleReportCubit>().getWeeklyReport();
              } else if (value == 2) {
                context.read<SaleReportCubit>().getMonthlyReport();
              }
            },
            tabs: [
              Tab(text: 'ဒီနေ့'),
              Tab(text: 'အပတ်စဉ်'),
              Tab(text: 'လစဉ်'),
            ],
          ),
        ),
        SizedBox(height: 20),
        Expanded(
          child: TabBarView(
            children: [
              BlocBuilder<SaleReportCubit, SaleReportState>(
                builder: (context, state) {
                  if (state is SaleReportDaily) {
                    return _reportWidget(
                      name: "To Day",
                      KpayAmount: state.saleReport.total_paid_online ?? 0,
                      cashAmount: state.saleReport.total_paid_cash ?? 0,
                      total: state.saleReport.total_sales ?? 0,
                    );
                  } else if (state is SaleReportLoading) {
                    return loadingWidget();
                  } else {
                    return _reportWidget(
                      name: "To Day",
                      KpayAmount: 0,
                      cashAmount: 0,
                      total: 0,
                    );
                  }
                },
              ),
              BlocBuilder<SaleReportCubit, SaleReportState>(
                builder: (context, state) {
                  if (state is SaleReportWeekly) {
                    return _reportWidget(
                      name: "Monthly",
                      KpayAmount: state.saleReport.total_paid_online ?? 0,
                      cashAmount: state.saleReport.total_paid_cash ?? 0,
                      total: state.saleReport.total_sales ?? 0,
                    );
                  } else if (state is SaleReportLoading) {
                    return loadingWidget();
                  } else {
                    return _reportWidget(
                      name: "This Week",
                      KpayAmount: 0,
                      cashAmount: 0,
                      total: 0,
                    );
                  }
                },
              ),
              BlocBuilder<SaleReportCubit, SaleReportState>(
                builder: (context, state) {
                  if (state is SaleReportMonthly) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 20, bottom: 20),
                          child: Text(
                            "ယခင်လ",
                            style: TextStyle(
                              fontSize: 20 - 2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        _reportWidget(
                          name: "Monthly",
                          KpayAmount:
                              state.lastMonthSale.total_paid_online ?? 0,
                          cashAmount: state.lastMonthSale.total_paid_cash ?? 0,
                          total: state.lastMonthSale.total_sales ?? 0,
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20, bottom: 20),
                          child: Text(
                            "လက်ရှိလ",
                            style: TextStyle(
                              fontSize: 20 - 2,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        _reportWidget(
                          name: "Monthly",
                          KpayAmount:
                              state.currentMonthSale.total_paid_online ?? 0,
                          cashAmount:
                              state.currentMonthSale.total_paid_cash ?? 0,
                          total: state.currentMonthSale.total_sales ?? 0,
                        )
                      ],
                    );
                  } else if (state is SaleReportLoading) {
                    return loadingWidget();
                  } else {
                    return Center(
                      child: Text(
                        "No Monthly Report",
                        style: TextStyle(
                          fontSize: 24- 5,
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  ///sale report widget
  Widget _reportWidget({
    required int cashAmount,
    required int KpayAmount,
    required int total,
    required name,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: SizeConst.kHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _reportCardWidget(
                  amount: "${cashAmount}",
                  title: "စုစုပေါင်းငွေ",
                  icon: Icon(
                    CupertinoIcons.money_dollar,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _reportCardWidget(
                  amount: "${KpayAmount}",
                  title: "စုစုပေါင်း Kpay",
                  icon: Icon(
                    CupertinoIcons.creditcard,
                    size: 30,
                  ),
                ),
              ),
              SizedBox(width: 15),
              Expanded(
                child: _reportCardWidget(
                  amount: "${total}",
                  title: "စုစုပေါင်းရောင်းအား",
                  isTotalSales: true,
                  icon: Icon(
                    CupertinoIcons.chart_pie,
                    size: 30,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 35),
        ],
      ),
    );
  }

  ///report cart widget to show the detail of the report with title
  Container _reportCardWidget({
    required String title,
    required String amount,
    required Widget icon,
    bool isTotalSales = false,
  }) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: SizeConst.kBorderRadius,
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: Colors.grey.shade100,
                child: icon,
              ),
              SizedBox(width: 20),
              Text(
                "${title}",
                style: TextStyle(
                  fontSize: 16 + 3,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
          SizedBox(height: 15),
          Text(
            isTotalSales
                ? "${amount}"
                : "${formatNumber(num.parse(amount))} MMK",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  ///print out
  Future<bool> _printReceipt({
    required int cashAmount,
    required int KpayAmount,
    required int totalAmount,
    required int taxAmount,
    required int discountAmount,
    required String report,
  }) async {
    try {
      await SunmiPrinter.initPrinter();

      await SunmiPrinter.startTransactionPrint(true);

      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

      await SunmiPrinter.printText(
        'ရှန်းရှန်း',
        style: SunmiStyle(
          align: SunmiPrintAlign.CENTER,
        ),
      );

      await SunmiPrinter.printText("");
      await SunmiPrinter.printText(
        'North Dagon, Yangon',
        style: SunmiStyle(
          align: SunmiPrintAlign.CENTER,
        ),
      );

      await SunmiPrinter.printText("");

      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: 'Report',
          width: 17,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: ':',
          width: 2,
          align: SunmiPrintAlign.CENTER,
        ),
        ColumnMaker(
          text: '${report}',
          width: 25,
          align: SunmiPrintAlign.LEFT,
        ),
      ]);

      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printText(
        "----------------------------------------------",
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
        ),
      );

      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: 'Cash Amount',
          width: 20,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: '${formatNumber(cashAmount)} MMK',
          width: 26,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);

      await SunmiPrinter.printRow(
        cols: [
          ColumnMaker(
            text: 'Kpay Amount',
            width: 20,
            align: SunmiPrintAlign.LEFT,
          ),
          ColumnMaker(
            text: '${formatNumber(KpayAmount)} MMK',
            width: 26,
            align: SunmiPrintAlign.RIGHT,
          ),
        ],
      );

      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: 'Total Amount',
          width: 20,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: '${formatNumber(totalAmount)} MMK',
          width: 26,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);

      await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printText(
        "----------------------------------------------",
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
        ),
      );

      await SunmiPrinter.printText("");
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

      await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

      await SunmiPrinter.cut();
      await SunmiPrinter.exitTransactionPrint(true);

      return true;
    } catch (e) {
      return false;
    }
  }

  ///priint montyly report
  Future<bool> _printMontylyReport({
    required int lastMonthcashAmount,
    required int lastMonthKpayAmount,
    required int lastMonthtotalAmount,
    required int currentMonthcashAmount,
    required int currentMonthKpayAmount,
    required int currentMonthtotalAmount,
    required String lastMonthDate,
    required String currentMonthDate,
  }) async {
    try {
      await SunmiPrinter.initPrinter();

      await SunmiPrinter.startTransactionPrint(true);

      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

      await SunmiPrinter.printText(
        'ရှန်းရှန်း',
        style: SunmiStyle(
          align: SunmiPrintAlign.CENTER,
        ),
      );

      await SunmiPrinter.printText("");
      await SunmiPrinter.printText(
        'North Dagon, Yangon',
        style: SunmiStyle(
          align: SunmiPrintAlign.CENTER,
        ),
      );

      await SunmiPrinter.printText(
          "Current Month Report : ${currentMonthDate}");

      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printText(
        "----------------------------------------------",
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
        ),
      );

      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: 'Cash Amount',
          width: 20,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: '${formatNumber(currentMonthcashAmount)} MMK',
          width: 26,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);

      await SunmiPrinter.printRow(
        cols: [
          ColumnMaker(
            text: 'Kpay Amount',
            width: 20,
            align: SunmiPrintAlign.LEFT,
          ),
          ColumnMaker(
            text: '${formatNumber(currentMonthKpayAmount)} MMK',
            width: 26,
            align: SunmiPrintAlign.RIGHT,
          ),
        ],
      );

      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: 'Total Amount',
          width: 20,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: '${formatNumber(currentMonthtotalAmount)} MMK',
          width: 26,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);

      //await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printText(
        "----------------------------------------------",
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
        ),
      );

      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: 'Last Month Report',
          width: 17,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: ':',
          width: 2,
          align: SunmiPrintAlign.CENTER,
        ),
        ColumnMaker(
          text: '${lastMonthDate}',
          width: 25,
          align: SunmiPrintAlign.LEFT,
        ),
      ]);

      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printText(
        "----------------------------------------------",
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
        ),
      );

      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: 'Cash Amount',
          width: 20,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: '${formatNumber(lastMonthcashAmount)} MMK',
          width: 26,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);

      await SunmiPrinter.printRow(
        cols: [
          ColumnMaker(
            text: 'Kpay Amount',
            width: 20,
            align: SunmiPrintAlign.LEFT,
          ),
          ColumnMaker(
            text: '${formatNumber(lastMonthKpayAmount)} MMK',
            width: 26,
            align: SunmiPrintAlign.RIGHT,
          ),
        ],
      );

      await SunmiPrinter.printRow(cols: [
        ColumnMaker(
          text: 'Total Amount',
          width: 20,
          align: SunmiPrintAlign.LEFT,
        ),
        ColumnMaker(
          text: '${formatNumber(lastMonthtotalAmount)} MMK',
          width: 26,
          align: SunmiPrintAlign.RIGHT,
        ),
      ]);

      await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);
      await SunmiPrinter.printText(
        "----------------------------------------------",
        style: SunmiStyle(
          fontSize: SunmiFontSize.MD,
        ),
      );

      await SunmiPrinter.printText("");
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

      await SunmiPrinter.lineWrap(1);
      await SunmiPrinter.setAlignment(SunmiPrintAlign.CENTER);

      await SunmiPrinter.cut();
      await SunmiPrinter.exitTransactionPrint(true);

      return true;
    } catch (e) {
      return false;
    }
  }
}
