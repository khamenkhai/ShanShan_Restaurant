class SaleReportModel {
  final int totalSales;
  final int totalPaidCash;
  final int totalPaidOnline;
  final int totalGrands;
  final String dailyDate;
  final String currentMonth;
  final String pastMonth;
  final String startOfWeek;
  final String endOfWeek;

  const SaleReportModel({
    this.totalSales = 0,
    this.totalPaidCash = 0,
    this.totalPaidOnline = 0,
    this.totalGrands = 0,
    this.dailyDate = "",
    this.currentMonth = "",
    this.pastMonth = "",
    this.startOfWeek = "",
    this.endOfWeek = "",
  });

  factory SaleReportModel.fromMap(Map<String, dynamic> map) {
    return SaleReportModel(
      totalSales: map["total_sales"] as int? ?? 0,
      totalPaidCash: map["total_paid_cash"] as int? ?? 0,
      totalPaidOnline: map["total_paid_online"] as int? ?? 0,
      totalGrands: map["total_Grands"] as int? ?? 0,
      dailyDate: map["daily_date"] as String? ?? "",
      currentMonth: map["current_month"] as String? ?? "",
      pastMonth: map["past_month"] as String? ?? "",
      startOfWeek: map["start_of_week"] as String? ?? "",
      endOfWeek: map["end_of_week"] as String? ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "total_sales": totalSales,
      "total_paid_cash": totalPaidCash,
      "total_paid_online": totalPaidOnline,
      "total_Grands": totalGrands,
      "daily_date": dailyDate,
      "current_month": currentMonth,
      "past_month": pastMonth,
      "start_of_week": startOfWeek,
      "end_of_week": endOfWeek,
    };
  }
}
