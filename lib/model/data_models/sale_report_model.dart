class SaleReportModel {
  final int? total_sales;
  final int? total_paid_cash;
  final int? total_paid_online;
  final String? daily_date;
  final String? current_month;
  final String? past_month;
  final String? start_of_week;
  final String? end_of_week;
  final int? total_Grands;

  SaleReportModel({
    this.total_paid_cash,
    this.total_paid_online,
    this.total_sales,
    this.daily_date,
    this.total_Grands,
    this.current_month,
    this.past_month,
    this.start_of_week,
    this.end_of_week,
  });

  factory SaleReportModel.fromMap(Map<String, dynamic> map) {
    return SaleReportModel(
      total_sales: map["total_sales"] ?? 0,
      total_paid_cash: map["total_paid_cash"] ?? 0,
      total_paid_online: map["total_paid_online"] ?? 0,
      daily_date: map["daily_date"] ?? "",
      total_Grands: map["total_Grands"] ?? 0,
      current_month: map["current_month"] ?? "",
      past_month: map["past_month"] ?? "",
      end_of_week: map["end_of_week"] ?? "",
      start_of_week: map["start_of_week"] ?? "",
    );
  }
}
