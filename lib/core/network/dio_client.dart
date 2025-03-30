// ignore_for_file: use_rethrow_when_possible
import 'package:dio/dio.dart';
import 'package:shan_shan/core/const/api_const.dart';
import 'package:shan_shan/core/local_data/shared_prefs.dart';

class DioClient {
  final SharedPref sharedPref;
  final Dio dio;

  DioClient({required this.sharedPref, required this.dio});

  /// Common request headers
  Future<Map<String, String>> _getHeaders() async {
    String? token = await sharedPref.getString(key: sharedPref.BEARER_TOKEN);
    return {'Authorization': 'Bearer $token'};
  }

  /// GET Request with Cache Interceptor
  Future<Response<T>> getRequest<T>({required String apiUrl}) async {
    try {
      final headers = await _getHeaders();
      // DioCacheInterceptor dioCacheInterceptor = DioCacheInterceptor(
      //   options: CacheOptions(
      //     store: MemCacheStore(),
      //   ),
      // );
      // dio.interceptors.add(dioCacheInterceptor);
      return await dio.get<T>(
        "${ApiConstants.BASE_URL_DEV}/$apiUrl",
        options: Options(
          headers: headers,
          receiveDataWhenStatusError: true,
          validateStatus: (status) => true,
        ),
      );
    } on DioException catch (e) {
      throw e; // Rethrow the exception or handle it as needed
    }
  }

  /// POST Request
  Future<Response<T>> postRequest<T>({
    required String apiUrl,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      final headers = await _getHeaders();
      return await dio.post<T>(
        "${ApiConstants.BASE_URL_DEV}/$apiUrl",
        data: requestBody,
        options: Options(
          headers: headers,
          receiveDataWhenStatusError: true,
          validateStatus: (status) => true,
        ),
      );
    } on DioException catch (e) {
      throw e; // Rethrow the exception or handle it as needed
    }
  }

  /// POST Request with Custom Header
  Future<Response<T>> postRequestWithCustomHeader<T>({
    required String apiUrl,
    required Map<String, dynamic> requestBody,
    required Map<String, dynamic> header,
  }) async {
    try {
      return await dio.post<T>(
        apiUrl,
        data: requestBody,
        options: Options(headers: header),
      );
    } on DioException catch (e) {
      throw e; // Rethrow the exception or handle it as needed
    }
  }

  /// DELETE Request
  Future<Response<T>> deleteRequest<T>({
    required String apiUrl,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      final headers = await _getHeaders();
      return await dio.delete<T>(
        apiUrl,
        data: requestBody,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      throw e; // Rethrow the exception or handle it as needed
    }
  }

  /// PUT Request
  Future<Response<T>> putRequest<T>({
    required String apiUrl,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      final headers = await _getHeaders();
      return await dio.put<T>(
        apiUrl,
        data: requestBody,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      throw e; // Rethrow the exception or handle it as needed
    }
  }

  /// GET with Query Params
  Future<Response<T>> getBodyRequest<T>({
    required String apiUrl,
    required Map<String, dynamic> requestBody,
  }) async {
    try {
      final headers = await _getHeaders();
      return await dio.get<T>(
        apiUrl,
        queryParameters: requestBody,
        options: Options(headers: headers),
      );
    } on DioException catch (e) {
      throw e; // Rethrow the exception or handle it as needed
    }
  }
}
