import 'package:fpdart/fpdart.dart';
import 'package:shan_shan/core/const/api_const.dart';
import 'package:shan_shan/core/network/dio_client.dart';
import 'package:shan_shan/core/utils/custom_logger.dart';
import 'package:shan_shan/model/data_models/ahtone_level_model.dart';

class AhtoneLevelService {
  final DioClient dioClient;
  final CustomLogger logger;

  AhtoneLevelService({required this.dioClient, required this.logger});

  /// Create Ahtone Level
  Future<Either<String, bool>> addAhtoneLevel({
    required Map<String, dynamic> requestBody,
  }) async {
    return _handleRequest(
      () => dioClient.postRequest(
        apiUrl: ApiConstants.STORE_HTONE_LEVEL,
        requestBody: requestBody,
      ),
    );
  }

  /// Delete Ahtone Level
  Future<Either<String, bool>> deleteAhtoneLevel({
    required String id,
    required Map<String, dynamic> requestBody,
  }) async {
    return _handleRequest(
      () => dioClient.deleteRequest(
        apiUrl: "${ApiConstants.DELETE_HTONE_LEVEL}/${id}",
        requestBody: requestBody,
      ),
    );
  }

  /// Edit Ahtone Level
  Future<Either<String, bool>> editAhtoneLevel({
    required String id,
    required Map<String, dynamic> requestBody,
  }) async {
    return _handleRequest(
      () => dioClient.postRequest(
        apiUrl: ApiConstants.Edit_HTONE_LEVEL + "/${id}",
        requestBody: requestBody,
      ),
    );
  }

  /// Get all Ahtone Levels
  Future<Either<String, List<AhtoneLevelModel>>> getAllAthoneLevels() async {
    try {
      final response = await dioClient.getRequest(
        apiUrl: ApiConstants.GET_HTONE_LEVEL,
      );
      final dataList = response.data["data"] as List;
      final productList =
          dataList.map((e) => AhtoneLevelModel.fromMap(e)).toList();
      return Right(productList);
    } catch (e) {
      logger.logWarning(
        "Error log : $e",
        error: 'AhtoneLevelService : getAllAthoneLevels',
      );
      return Left(e.toString());
    }
  }

  /// Generic request handler
  Future<Either<String, bool>> _handleRequest(
    Future<dynamic> Function() request,
  ) async {
    try {
      final response = await request();
      return (response.statusCode == 200 || response.statusCode == 201)
          ? Right(true)
          : Left(response.data["message"]?.toString() ?? "Unknown error");
    } catch (e) {
      logger.logWarning("Error log : $e", error: 'AhtoneLevelService');
      return Left(e.toString());
    }
  }
}
