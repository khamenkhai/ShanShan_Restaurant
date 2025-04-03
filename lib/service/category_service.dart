import 'package:fpdart/fpdart.dart';
import 'package:shan_shan/core/const/api_const.dart';
import 'package:shan_shan/core/network/dio_client.dart';
import 'package:shan_shan/core/utils/custom_logger.dart';
import 'package:shan_shan/models/response_models/category_model.dart';

class CategoryService {
  final DioClient dioClient;
  final CustomLogger logger;

  CategoryService({required this.dioClient, required this.logger});

  /// Create Category
  Future<Either<String, bool>> createCategory({
    required Map<String, dynamic> requestBody,
  }) async {
    return _handleRequest(
      () => dioClient.postRequest(
        apiUrl: ApiConstants.CREATE_CATEGORY,
        requestBody: requestBody,
      ),
    );
  }

  /// Delete Category
  Future<Either<String, bool>> deleteCategory({
    required String id,
  }) async {
    return _handleRequest(
      () => dioClient.deleteRequest(
        apiUrl: "${ApiConstants.DELETE_CATEGORY}/$id",
        requestBody: {},
      ),
    );
  }

  /// Update Category
  Future<Either<String, bool>> updateCategory({
    required String id,
    required Map<String, dynamic> requestBody,
  }) async {
    return _handleRequest(
      () => dioClient.postRequest(
        apiUrl: "${ApiConstants.EDIT_CATEGORY}/$id",
        requestBody: requestBody,
      ),
    );
  }

  /// Get All Categories
  Future<Either<String, List<CategoryModel>>> getAllCategories() async {
    try {
      final response = await dioClient.getRequest(apiUrl: ApiConstants.GET_CATEGORY);
      final dataList = response.data["data"] as List;
      final categoryList = dataList.map((e) => CategoryModel.fromJson(e)).toList();
      return Right(categoryList);
    } catch (e) {
      logger.logWarning("Error log : $e", error: 'CategoryService : getAllCategories');
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
      logger.logWarning("Error log : $e", error: 'CategoryService');
      return Left(e.toString());
    }
  }
}
