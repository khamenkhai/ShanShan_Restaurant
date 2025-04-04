import 'package:fpdart/fpdart.dart';
import 'package:shan_shan/core/network/dio_client.dart';
import 'package:shan_shan/core/utils/custom_logger.dart';
import 'package:shan_shan/models/data_models/sale_report_model.dart';
import 'package:shan_shan/core/const/api_const.dart';

class ReportService {
  final DioClient dioClient;
  final CustomLogger logger;

  ReportService({required this.dioClient, required this.logger});

  /// Get daily sales report
  Future<Either<String, SaleReportModel>> getDailySale() async {
    return _handleRequest(
      () => dioClient.getRequest(apiUrl: ApiConstants.DAILY_SALE_URL),
      (response) => SaleReportModel.fromMap(response.data["data"]),
    );
  }

  /// Get monthly sales report
  Future<Either<String, SaleReportModel>> getMonthlySale({required String url}) async {
    return _handleRequest(
      () => dioClient.getRequest(apiUrl: url),
      (response) => SaleReportModel.fromMap(response.data["data"]),
    );
  }

  /// Generic request handler with status code check
  Future<Either<String, T>> _handleRequest<T>(
    Future<dynamic> Function() request,
    T Function(dynamic response) mapResponse,
  ) async {
    try {
      final response = await request();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(mapResponse(response));
      } else {
        return Left(response.data["message"]?.toString() ?? "Unknown error");
      }
    } catch (e) {
      logger.logWarning("Error log : $e", error: 'ReportService : _handleRequest');
      return Left(e.toString());
    }
  }
}
