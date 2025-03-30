import 'package:shan_shan/core/network/dio_client.dart';
import 'package:shan_shan/core/utils/custom_logger.dart';
import 'package:shan_shan/model/response_models/product_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:shan_shan/core/const/api_const.dart';

class ProductService {
  final DioClient dioClient;
  final CustomLogger logger;

  ProductService({required this.dioClient,required this.logger});

  /// Add new product
  Future<Either<String, bool>> addNewProduct({
    required Map<String, dynamic> requestBody,
  }) async {
    return _handleRequest(
      () => dioClient.postRequest(
        apiUrl: ApiConstants.CREATE_PRODUCT,
        requestBody: requestBody,
      ),
    );
  }

  /// Update product
  Future<Either<String, bool>> updateProduct({
    required String id,
    required Map<String, dynamic> requestBody,
  }) async {
    return _handleRequest(
      () => dioClient.postRequest(
        apiUrl: "${ApiConstants.EDIT_PRODUCT}/$id",
        requestBody: requestBody,
      ),
    );
  }

  /// Delete product
  Future<Either<String, bool>> deleteProduct({
    required String id,
    required Map<String, dynamic> requestBody,
  }) async {
    return _handleRequest(
      () => dioClient.deleteRequest(
        apiUrl: "${ApiConstants.DELETE_PRODUCT}/$id",
        requestBody: requestBody,
      ),
    );
  }

  /// Get all products by category
  Future<Either<String, List<ProductModel>>> getProductsByCategory({
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      final response = await dioClient.postRequest(
        apiUrl: ApiConstants.GET_PRODUCTS_BY_CATEGORY,
        requestBody: requestBody,
      );
      final dataList = response.data["data"] as List;
      final productList = dataList.map((e) => ProductModel.fromMap(e)).toList();
      return Right(productList);
    } catch (e) {
      logger.logWarning("Error log : $e", error: 'ProductService : getProductsByCategory');
      return Left(e.toString());
    }
  }

  /// Get all products by pagination
  Future<Either<String, List<ProductModel>>> getProductsByPagination({
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      final response = await dioClient.postRequest(
        apiUrl: ApiConstants.GET_PRODUCTS_BY_PAGINATION,
        requestBody: requestBody,
      );
      final dataList = response.data["data"] as List;
      final productList = dataList.map((e) => ProductModel.fromMap(e)).toList();
      return Right(productList);
    } catch (e) {
      logger.logWarning("Error log : $e", error: 'ProductService : getProductsByPagination');
      return Left(e.toString());
    }
  }

  /// Get all products
  Future<Either<String, List<ProductModel>>> getAllProducts() async {
    try {
      final response = await dioClient.getRequest(apiUrl: ApiConstants.GET_PRODUCTS);
      final dataList = response.data["data"] as List;
      final productList = dataList.map((e) => ProductModel.fromMap(e)).toList();
      return Right(productList);
    } catch (e) {
      logger.logWarning("Error log : $e", error: 'ProductService : getAllProducts');
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
      logger.logWarning("Error log : $e", error: 'ProductService');
      return Left(e.toString());
    }
  }
}
