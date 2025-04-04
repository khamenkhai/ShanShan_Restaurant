import 'package:fpdart/fpdart.dart';
import 'package:shan_shan/core/network/dio_client.dart';
import 'package:shan_shan/core/utils/custom_logger.dart';
import 'package:shan_shan/core/const/api_const.dart';

class SaleService {
  final DioClient dioClient;
  final CustomLogger logger;

  SaleService({required this.dioClient, required this.logger});

  /// Make a sale request to the server
  Future<Either<String, bool>> makeSale({
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      final response = await dioClient.postRequest(
        apiUrl: ApiConstants.MAKE_SALE_URL,
        requestBody: requestBody,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(true);
      } else {
        return Left(response.data["message"]?.toString() ?? "Unknown error");
      }
    } catch (e) {
      logger.logWarning("Error log : $e",
          error: 'SaleService : _handleRequest');
      return Left(e.toString());
    }
  }
}
