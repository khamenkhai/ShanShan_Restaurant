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
      child: const TabBar(
        dividerColor: Colors.transparent,
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
            cashAmount: state.saleReport.total_paid_cash ?? 0,
            kpayAmount: state.saleReport.total_paid_online ?? 0,
            totalAmount: state.saleReport.total_sales ?? 0,
          );
        }
        return const ReportSummarySkeleton();
      },
    );
  }

  Widget _buildWeeklyReportView() {
    return BlocBuilder<SaleReportCubit, SaleReportState>(
      builder: (context, state) {
        if (state is SaleReportWeekly) {
          return ReportSummaryWidget(
            name: "This Week",
            cashAmount: state.saleReport.total_paid_cash ?? 0,
            kpayAmount: state.saleReport.total_paid_online ?? 0,
            totalAmount: state.saleReport.total_sales ?? 0,
          );
        }
        return const ReportSummarySkeleton();
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
                cashAmount: state.lastMonthSale.total_paid_cash ?? 0,
                kpayAmount: state.lastMonthSale.total_paid_online ?? 0,
                totalAmount: state.lastMonthSale.total_sales ?? 0,
              ),
              _buildReportHeader("လက်ရှိလ"),
              ReportSummaryWidget(
                name: "Current Month",
                cashAmount: state.currentMonthSale.total_paid_cash ?? 0,
                kpayAmount: state.currentMonthSale.total_paid_online ?? 0,
                totalAmount: state.currentMonthSale.total_sales ?? 0,
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
  debugPrint("Daily report date: ${state.saleReport.daily_date}");
  spu.printReceipt(
    cashAmount: state.saleReport.total_paid_cash ?? 0,
    KpayAmount: state.saleReport.total_paid_online ?? 0,
    totalAmount: state.saleReport.total_Grands ?? 0,
    taxAmount: 500, // Consider making this dynamic if needed
    discountAmount: 0, // Consider making this dynamic if needed
    report: "${state.saleReport.daily_date}",
  );
}

void _printWeeklyReport(SaleReportWeekly state) {
  debugPrint(
      "Weekly report range: ${state.saleReport.start_of_week} to ${state.saleReport.end_of_week}");
  spu.printReceipt(
    cashAmount: state.saleReport.total_paid_cash ?? 0,
    KpayAmount: state.saleReport.total_paid_online ?? 0,
    totalAmount: state.saleReport.total_Grands ?? 0,
    taxAmount: 500,
    discountAmount: 0,
    report:
        "${state.saleReport.start_of_week} to ${state.saleReport.end_of_week}",
  );
}

void _printMonthlyReport(SaleReportMonthly state) {
  debugPrint("Monthly report comparison:");
  debugPrint("Current month: ${state.currentMonthSale.current_month}");
  debugPrint("Last month: ${state.lastMonthSale.past_month}");

  spu.printMontylyReport(
    lastMonthDate: state.lastMonthSale.past_month ?? "",
    currentMonthDate: state.currentMonthSale.current_month ?? "",
    lastMonthcashAmount: state.lastMonthSale.total_paid_cash ?? 0,
    lastMonthKpayAmount: state.lastMonthSale.total_paid_online ?? 0,
    lastMonthtotalAmount: state.lastMonthSale.total_Grands ?? 0,
    currentMonthcashAmount: state.currentMonthSale.total_paid_cash ?? 0,
    currentMonthKpayAmount: state.currentMonthSale.total_paid_online ?? 0,
    currentMonthtotalAmount: state.currentMonthSale.total_Grands ?? 0,
  );
}

class ReportSummaryWidget extends StatelessWidget {
  final String name;
  final int cashAmount;
  final int kpayAmount;
  final int totalAmount;

  const ReportSummaryWidget({
    super.key,
    required this.name,
    required this.cashAmount,
    required this.kpayAmount,
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
                amount: kpayAmount,
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

