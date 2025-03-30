import 'package:fpdart/fpdart.dart';
import 'package:shan_shan/core/network/dio_client.dart';
import 'package:shan_shan/core/utils/custom_logger.dart';
import 'package:shan_shan/model/request_models/shop_login_request_model.dart';
import 'package:shan_shan/model/response_models/shop_model.dart';

class AuthService {
  final DioClient dioClient;
  final CustomLogger logger;

  AuthService({required this.dioClient, required this.logger});

  /// Check login status
  Future<Either<String, ShopModel>> checkLoginStatus({
    required String url,
  }) async {
    try {
      final response = await dioClient.getRequest(apiUrl: url);

      if (response.statusCode == 200) {
        ShopModel shopData = ShopModel.fromMap(response.data["data"]);
        return Right(shopData);
      } else {
        return Left("${response.data["message"] ?? "Auth Failed"}");
      }
    } catch (e) {
      logger.logWarning(
        "Error log : $e",
        error: 'AuthService : checkLoginStatus',
      );
      return Left(e.toString());
    }
  }

  /// Login with shop data
  Future<Either<String, ShopModel>> loginWithShop({
    required String url,
    required ShopLoginRequest shopLoginRequest,
  }) async {
    try {
      final response = await dioClient.postRequest(
        apiUrl: url,
        requestBody: shopLoginRequest.toMap(),
      );

      ShopModel shopData = ShopModel.fromMap(response.data["data"]);

      if (shopData.accessToken != "") {
        return Right(shopData);
      } else {
        return Left(response.data["message"] ?? "");
      }
    } catch (e) {
      logger.logWarning(
        "Error log : $e",
        error: 'AuthService : loginWithShop',
      );
      return Left(e.toString());
    }
  }

  /// Register with shop data
  Future<Either<String, ShopModel>> register({
    required String url,
    required ShopLoginRequest shopLoginRequest,
  }) async {
    try {
      final response = await dioClient.postRequest(
        apiUrl: url,
        requestBody: shopLoginRequest.toMap(),
      );

      if (response.statusCode == 200) {
        ShopModel shopData = ShopModel.fromMap(response.data);
        return Right(shopData);
      } else {
        return Left("${response.data["message"] ?? "Registration Failed"}");
      }
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'AuthService : register',
      );
      return Left(e.toString());
    }
  }

  /// Logout
  Future<Either<String, bool>> logout({
    required String url,
  }) async {
    try {
      final response = await dioClient.postRequest(
        apiUrl: url,
        requestBody: {},
      );

      if (response.statusCode == 200) {
        return Right(true); // Return true on successful logout
      } else {
        return Left("${response.data["message"] ?? "Logout Failed"}");
      }
    } catch (e) {
      logger.logWarning(
        "Error log : ${e}",
        error: 'AuthService : logout',
      );
      return Left(e.toString());
    }
  }
}
