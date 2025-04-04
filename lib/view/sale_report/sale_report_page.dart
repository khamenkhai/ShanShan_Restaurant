import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/controller/sale_report_cubit/sale_report_cubit.dart';
import 'package:shan_shan/core/component/internet_check.dart';
import 'package:shan_shan/core/const/const_export.dart';
import 'package:shan_shan/core/utils/sunmi_printer_util.dart' as spu;
import 'package:shan_shan/core/utils/utils.dart';
import 'package:shan_shan/view/sale_report/widgets/sale_report_skeleton.dart';
import 'package:shan_shan/view/widgets/common_widget.dart';
import 'package:sunmi_printer_plus/sunmi_printer_plus.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  @override
  void initState() {
    super.initState();
    _initializePrinter();
    context.read<SaleReportCubit>().getDailyReport();
  }

  Future<void> _initializePrinter() async {
    await SunmiPrinter.bindingPrinter();
    await SunmiPrinter.paperSize();
    await SunmiPrinter.printerVersion();
    await SunmiPrinter.serialNumber();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _buildAppBar(),
        floatingActionButton: _buildPrintButton(),
        body: InternetCheckWidget(
          child: _buildReportContent(),
          onRefresh: () => context.read<SaleReportCubit>().getDailyReport(),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text("အရောင်းအစီရင်ခံစာ"),
      leadingWidth: 100,
      centerTitle: true,
      leading: appBarLeading(
        onTap: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildPrintButton() {
    return BlocBuilder<SaleReportCubit, SaleReportState>(
      builder: (context, state) {
        return FloatingActionButton.extended(
          backgroundColor: ColorConstants.primaryColor,
          onPressed: () => _handlePrintAction(state),
          label: const Text("အရောင်းအစီရင်ခံစာပရင့်ထုတ်ရန်"),
          icon: const Icon(CupertinoIcons.printer),
        );
      },
    );
  }

  void _handlePrintAction(SaleReportState state) {
    if (state is SaleReportDaily) {
      _printDailyReport(state);
    } else if (state is SaleReportWeekly) {
      _printWeeklyReport(state);
    } else if (state is SaleReportMonthly) {
      _printMonthlyReport(state);
    }
  }

  Widget _buildReportContent() {
    return Column(
      children: [
        const SizedBox(height: 10),
        _buildReportTabs(),
        const SizedBox(height: 20),
        Expanded(child: _buildReportViews()),
      ],
    );
  }

  Widget _buildReportTabs() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConst.kHorizontalPadding),
      child: TabBar(
        dividerColor: Colors.transparent,
        onTap: (value) {
          if (value == 0) {
            context.read<SaleReportCubit>().getDailyReport();
          } else if (value == 1) {
            context.read<SaleReportCubit>().getMonthlyReport();
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
    );
  }

  Widget _buildReportViews() {
    return TabBarView(
      children: [
        _buildDailyReportView(),
        _buildWeeklyReportView(),
        _buildMonthlyReportView(),
      ],
    );
  }

  Widget _buildDailyReportView() {
    return BlocBuilder<SaleReportCubit, SaleReportState>(
      builder: (context, state) {
        if (state is SaleReportDaily) {
          return ReportSummaryWidget(
            name: "To Day",
            cashAmount: state.saleReport.totalPaidCash,
            paidOnline: state.saleReport.totalPaidOnline,
            totalAmount: state.saleReport.totalSales,
          );
        }
        return const ReportSummarySkeleton();
      },
    );
  }

  Widget _buildWeeklyReportView() {
    return BlocBuilder<SaleReportCubit, SaleReportState>(
      builder: (context, state) {
        if (state is SaleReportLoading) {
          return const ReportSummarySkeleton();
        } else if (state is SaleReportWeekly) {
          return ReportSummaryWidget(
            name: "This Week",
            cashAmount: state.saleReport.totalPaidCash,
            paidOnline: state.saleReport.totalPaidOnline,
            totalAmount: state.saleReport.totalSales,
          );
        }else{
          return Container();
        }
      },
    );
  }

  Widget _buildMonthlyReportView() {
    return BlocBuilder<SaleReportCubit, SaleReportState>(
      builder: (context, state) {
        if (state is SaleReportMonthly) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildReportHeader("ယခင်လ"),
              ReportSummaryWidget(
                name: "Last Month",
                cashAmount: state.lastMonthSale.totalPaidCash,
                paidOnline: state.lastMonthSale.totalPaidOnline,
                totalAmount: state.lastMonthSale.totalSales,
              ),
              _buildReportHeader("လက်ရှိလ"),
              ReportSummaryWidget(
                name: "Current Month",
                cashAmount: state.currentMonthSale.totalPaidCash,
                paidOnline: state.currentMonthSale.totalPaidOnline,
                totalAmount: state.currentMonthSale.totalSales,
              ),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildReportHeader("ယခင်လ"),
            const ReportSummarySkeleton(),
            _buildReportHeader("လက်ရှိလ"),
            const ReportSummarySkeleton(),
          ],
        );
      },
    );
  }

  Widget _buildReportHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 20),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// Add these printer methods to your _ReportPageState class
// (place them anywhere in the class, typically with other private methods)

void _printDailyReport(SaleReportDaily state) {
  debugPrint("Daily report date: ${state.saleReport.dailyDate}");
  spu.printReceipt(
    cashAmount: state.saleReport.totalPaidCash,
    paidOnline: state.saleReport.totalPaidOnline,
    totalAmount: state.saleReport.totalGrands,
    taxAmount: 500, // Consider making this dynamic if needed
    discountAmount: 0, // Consider making this dynamic if needed
    report: "${state.saleReport.dailyDate}",
  );
}

void _printWeeklyReport(SaleReportWeekly state) {
  debugPrint(
      "Weekly report range: ${state.saleReport.startOfWeek} to ${state.saleReport.endOfWeek}");
  spu.printReceipt(
    cashAmount: state.saleReport.totalPaidCash,
    paidOnline: state.saleReport.totalPaidOnline,
    totalAmount: state.saleReport.totalGrands,
    taxAmount: 500,
    discountAmount: 0,
    report: "${state.saleReport.startOfWeek} to ${state.saleReport.endOfWeek}",
  );
}

void _printMonthlyReport(SaleReportMonthly state) {
  debugPrint("Monthly report comparison:");
  debugPrint("Current month: ${state.currentMonthSale.currentMonth}");
  debugPrint("Last month: ${state.lastMonthSale.pastMonth}");

  spu.printMontylyReport(
    lastMonthDate: state.lastMonthSale.pastMonth,
    currentMonthDate: state.currentMonthSale.currentMonth,
    lastMonthcashAmount: state.lastMonthSale.totalPaidCash,
    lastMonthpaidOnline: state.lastMonthSale.totalPaidOnline,
    lastMonthtotalAmount: state.lastMonthSale.totalGrands,
    currentMonthcashAmount: state.currentMonthSale.totalPaidCash,
    currentMonthpaidOnline: state.currentMonthSale.totalPaidOnline,
    currentMonthtotalAmount: state.currentMonthSale.totalGrands,
  );
}

class ReportSummaryWidget extends StatelessWidget {
  final String name;
  final int cashAmount;
  final int paidOnline;
  final int totalAmount;

  const ReportSummaryWidget({
    super.key,
    required this.name,
    required this.cashAmount,
    required this.paidOnline,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConst.kHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildReportCard(
                amount: cashAmount,
                title: "စုစုပေါင်းငွေ",
                icon: const Icon(CupertinoIcons.money_dollar, size: 30),
              ),
              const SizedBox(width: 15),
              _buildReportCard(
                amount: paidOnline,
                title: "စုစုပေါင်း Kpay",
                icon: const Icon(CupertinoIcons.creditcard, size: 30),
              ),
              const SizedBox(width: 15),
              _buildReportCard(
                amount: totalAmount,
                title: "စုစုပေါင်းရောင်းအား",
                isTotalSales: true,
                icon: const Icon(CupertinoIcons.chart_pie, size: 30),
              ),
            ],
          ),
          const SizedBox(height: 35),
        ],
      ),
    );
  }

  Widget _buildReportCard({
    required String title,
    required int amount,
    required Widget icon,
    bool isTotalSales = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(15),
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
                  child: icon,
                ),
                const SizedBox(width: 20),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),
            const SizedBox(height: 15),
            Text(
              isTotalSales ? "$amount" : "${formatNumber(amount)} MMK",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
