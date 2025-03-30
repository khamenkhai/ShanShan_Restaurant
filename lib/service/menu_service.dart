import 'package:fpdart/fpdart.dart';
import 'package:shan_shan/core/const/api_const.dart';
import 'package:shan_shan/core/network/dio_client.dart';
import 'package:shan_shan/core/utils/custom_logger.dart';
import 'package:shan_shan/model/response_models/menu_model.dart';

class MenuService {
  final DioClient dioClient;
  final CustomLogger logger;

  MenuService({required this.dioClient, required this.logger});

  /// Create menu
  Future<Either<String, bool>> createMenu({
    required Map<String, dynamic> requestBody,
  }) async {
    return _handleRequest(
      () => dioClient.postRequest(
        apiUrl: ApiConstants.CREATE_MENU,
        requestBody: requestBody,
      ),
    );
  }

  /// Delete menu
  Future<Either<String, bool>> deleteMenu({
    required String id,
    required Map<String, dynamic> requestBody,
  }) async {
    return _handleRequest(
      () => dioClient.deleteRequest(
        apiUrl: "${ApiConstants.DELETE_MENU}/$id",
        requestBody: requestBody,
      ),
    );
  }

  /// Edit menu
  Future<Either<String, bool>> editMenu({
    required String id,
    required Map<String, dynamic> requestBody,
  }) async {
    return _handleRequest(
      () => dioClient.postRequest(
        apiUrl: "${ApiConstants.EDIT_MENU}/$id",
        requestBody: requestBody,
      ),
    );
  }

  /// Get all menu list
  Future<Either<String, List<MenuModel>>> getMenuList({
    required String url,
  }) async {
    try {
      final response = await dioClient.getRequest(apiUrl: url);
      final dataList = response.data["data"] as List;
      final menuList = dataList.map((e) => MenuModel.fromMap(e)).toList();
      return Right(menuList);
    } catch (e) {
      logger.logWarning("Error log : $e", error: 'MenuService : getMenuList');
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
      logger.logWarning("Error log : $e", error: 'MenuService');
      return Left(e.toString());
    }
  }
}
