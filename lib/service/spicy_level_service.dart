import 'package:fpdart/fpdart.dart';
import 'package:shan_shan/core/const/api_const.dart';
import 'package:shan_shan/core/network/dio_client.dart';
import 'package:shan_shan/core/utils/custom_logger.dart';
import 'package:shan_shan/model/data_models/spicy_level.dart';

class SpicyLevelService {
  final DioClient dioClient;
  final CustomLogger logger;

  SpicyLevelService({required this.dioClient,required this.logger});

  /// Create Spicy Level
  Future<Either<String, bool>> addSpicyLevel({
    required Map<String, dynamic> requestBody,
  }) async {
    return _handleRequest(
      () => dioClient.postRequest(
        apiUrl: ApiConstants.STORE_SPICY_LEVEL,
        requestBody: requestBody,
      ),
    );
  }

  /// Delete Spicy Level
  Future<Either<String, bool>> deleteSpicyLevel({
    required String id,
  }) async {
    return _handleRequest(
      () => dioClient.deleteRequest(
        apiUrl: "${ApiConstants.DELETE_SPICY_LEVEL}/$id", requestBody: {},
      ),
    );
  }

  /// Edit Spicy Level
  Future<Either<String, bool>> editSpicyLevel({
    required String id,
    required Map<String, dynamic> requestBody,
  }) async {
    return _handleRequest(
      () => dioClient.postRequest(
        apiUrl: "${ApiConstants.EDIT_SPICY_LEVEL}/$id",
        requestBody: requestBody,
      ),
    );
  }

  /// Get all Spicy Levels
  Future<Either<String, List<SpicyLevelModel>>> getSpicyLevels() async {
    try {
      final response = await dioClient.getRequest(
        apiUrl: ApiConstants.GET_SPICY_LEVEL,
      );
      final dataList = response.data["data"] as List;
      final levels = dataList.map((e) => SpicyLevelModel.fromMap(e)).toList();
      return Right(levels);
    } catch (e) {
      logger.logWarning("Error log : $e", error: 'SpicyLevelService : getSpicyLevels');
      return Left(e.toString());
    }
  }

  /// Generic request handler
  Future<Either<String, bool>> _handleRequest(Future<dynamic> Function() request) async {
    try {
      final response = await request();
      return (response.statusCode == 200 || response.statusCode == 201)
          ? Right(true)
          : Left(response.data["message"]?.toString() ?? "Unknown error");
    } catch (e) {
      logger.logWarning("Error log : $e", error: 'SpicyLevelService');
      return Left(e.toString());
    }
  }
}
