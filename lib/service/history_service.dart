import 'package:fpdart/fpdart.dart';
import 'package:shan_shan/core/const/api_const.dart';
import 'package:shan_shan/core/network/dio_client.dart';
import 'package:shan_shan/core/utils/custom_logger.dart';
import 'package:shan_shan/models/response_models/sale_history_detail.dart';
import 'package:shan_shan/models/response_models/sale_history_model.dart';
import 'package:shan_shan/models/response_models/sale_total_model.dart';

class HistoryService {
  final DioClient dioClient;
  final CustomLogger logger;

  HistoryService({required this.dioClient, required this.logger});

  /// Get sale history by pagination
  Future<Either<String, List<SaleHistoryModel>>> getHistoriesByPagination({
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      final response =
          await dioClient.getRequest(apiUrl: ApiConstants.GET_HISTORY_LIST);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final dataList = response.data["data"] as List;
        final historyList =
            dataList.map((e) => SaleHistoryModel.fromMap(e)).toList();
        return Right(historyList);
      } else {
        return Left(response.data["message"]?.toString() ?? "Unknown error");
      }
      // ? Right(response.data)
      // :
    } catch (e) {
      logger.logWarning("Error log : $e", error: 'HistoryService');
      return Left(e.toString());
    }
  }

  /// Search sale history
  Future<Either<String, List<SaleHistoryModel>>> searchSaleHistory({
    required Map<String, dynamic> requestBody,
  }) async {
    return _handleRequest(
      () => dioClient.getRequest(
        apiUrl: ApiConstants.SEARCH_SALE_HISTORY,
      ),
    );
  }

  /// Get sale history detail
  Future<Either<String, SaleHistoryDetail>> getHistoryDetail({
    required Map<String, dynamic> requestBody,
  }) async {
    return _handleRequest(
      () => dioClient.getBodyRequest(
        apiUrl: ApiConstants.GET_SALE_HISTORY_DETAIL,
        requestBody: requestBody,
      ),
    );
  }

  /// Get total sales and total slip number
  Future<Either<String, SaleTotalModel>> getTotalSaleAndTotalSlip({
    required Map<String, dynamic> requestBody,
  }) async {
    return _handleRequest(
      () => dioClient.getBodyRequest(
        apiUrl: ApiConstants.GET_TOTAL_SALE_AND_SLIPS,
        requestBody: requestBody,
      ),
    );
  }

  /// Generic request handler
  Future<Either<String, T>> _handleRequest<T>(
    Future<dynamic> Function() request,
  ) async {
    try {
      final response = await request();
      return (response.statusCode == 200 || response.statusCode == 201)
          ? Right(response.data)
          : Left(response.data["message"]?.toString() ?? "Unknown error");
    } catch (e) {
      logger.logWarning("Error log : $e", error: 'HistoryService');
      return Left(e.toString());
    }
  }
}
