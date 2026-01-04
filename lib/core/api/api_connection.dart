import 'package:dio/dio.dart';
import 'package:vizinhanca_solidaria/core/errors/exceptions.dart';

class ApiConnection {
  final Dio _dio;

  ApiConnection(this._dio);

  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      return fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<T> post<T>(
    String path, {
    data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic json) fromJson,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return fromJson(response.data);
    } on DioException catch (e) {
      print("============= API ERROR START =============");
      print(e);
      print("============= API ERROR END =============");
      throw _handleDioError(e);
    }
  }

  // Implemente outros métodos para POST, PUT, DELETE, etc.

  Exception _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException();
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 401) {
          return UnauthorizedException();
        } else {
          return ApiException(e.response?.statusCode ?? 500,
              e.response?.data.toString() ?? e.message ?? '');
        }
      case DioExceptionType.cancel:
        return CancelException();
      default:
        return ServerException();
    }
  }
}
