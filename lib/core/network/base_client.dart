import 'package:dio/dio.dart';

import '../error/result.dart';
import '../error/app_error.dart';
import '../utils/constants/constants.dart';

class BaseClient {
  late final Dio _dio;

  BaseClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Constants.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<Result<Response>> get(
      String path, {
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
      );
      return Success(response);
    } on DioException catch (e) {
      return Failure(_mapDioError(e));
    } catch (e) {
      return Failure(
        UnknownError(e.toString()),
      );
    }
  }

  Future<Result<Response>> post(
      String path, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
      }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return Success(response);
    } on DioException catch (e) {
      return Failure(_mapDioError(e));
    } catch (e) {
      return Failure(
        UnknownError(e.toString()),
      );
    }
  }

  AppError _mapDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const NetworkError('Error de conexión');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        return ServerError(
          'Error del servidor (${statusCode ?? 'desconocido'})',
        );

      case DioExceptionType.cancel:
        return const NetworkError('Petición cancelada');

      default:
        return UnknownError(e.message ?? 'Error desconocido');
    }
  }
}
