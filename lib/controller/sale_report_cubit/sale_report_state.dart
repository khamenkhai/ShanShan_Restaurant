part of 'sale_report_cubit.dart';

@immutable
sealed class SaleReportState {}

final class SaleReportInitial extends SaleReportState {}

final class SaleReportLoading extends SaleReportState {}

final class SaleReportDaily extends SaleReportState {
  final SaleReportModel saleReport;
  SaleReportDaily({required this.saleReport});
}

final class SaleReportWeekly extends SaleReportState {
  final SaleReportModel saleReport;
  SaleReportWeekly({required this.saleReport});
}

final class SaleReportMonthly extends SaleReportState {
  final SaleReportModel lastMonthSale;
  final SaleReportModel currentMonthSale;
  SaleReportMonthly({
    required this.lastMonthSale,
    required this.currentMonthSale,
  });
}

final class SaleReportError extends SaleReportState {
  final String error;
  SaleReportError({required this.error});
}
