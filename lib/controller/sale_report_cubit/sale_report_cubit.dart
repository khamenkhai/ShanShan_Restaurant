import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shan_shan/core/const/api_const.dart';
import 'package:shan_shan/model/data_models/sale_report_model.dart';
import 'package:shan_shan/service/report_service.dart';
import 'package:flutter/material.dart';
part 'sale_report_state.dart';

class SaleReportCubit extends Cubit<SaleReportState> {
  final ReportService reportService;

  SaleReportCubit({required this.reportService}) : super(SaleReportInitial());

  /// Get the daily report data
  void getDailyReport() async {
    emit(SaleReportLoading());
    final result = await reportService.getDailySale();
    result.fold(
      (failure) => emit(SaleReportError(error: failure)),
      (saleReport) => emit(SaleReportDaily(saleReport: saleReport)),
    );
  }

  /// Get the weekly report data
  void getWeeklyReport() async {
    emit(SaleReportLoading());
    final result = await reportService.getDailySale();
    result.fold(
      (failure) => emit(SaleReportError(error: failure)),
      (saleReport) => emit(SaleReportWeekly(saleReport: saleReport)),
    );
  }

  /// Get the monthly report data
  void getMonthlyReport() async {
    emit(SaleReportLoading());
    final currentMonthResult = await reportService.getMonthlySale(url: ApiConstants.CURRENT_MONTH_SALE_URL);
    final pastMonthResult = await reportService.getMonthlySale(url: ApiConstants.PAST_MONTH_SALE_URL);

    currentMonthResult.fold(
      (failure) => emit(SaleReportError(error: failure)),
      (currentMonthSale) => pastMonthResult.fold(
        (failure) => emit(SaleReportError(error: failure)),
        (pastMonthSale) => emit(SaleReportMonthly(
          lastMonthSale: pastMonthSale,
          currentMonthSale: currentMonthSale,
        )),
      ),
    );
  }
}
