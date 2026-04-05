import 'package:dio/dio.dart';
import 'package:exam/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ApiClient {
  final Dio _dio;

  static const _defaultHeaders = {'Content-Type': 'application/json', 'Accept': 'application/json'};

  ApiClient({String? baseUrl})
    : _dio = Dio(
        BaseOptions(
          baseUrl: baseUrl ?? '',
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: _defaultHeaders,
        ),
      ) {
    AppLogger.info('api url $baseUrl ${_dio.options.baseUrl}');
    if (kDebugMode) {
      _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true, error: true));
    }
  }

  Dio get dio => _dio;

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters, Options? options}) =>
      _dio.get(path, queryParameters: queryParameters, options: options);

  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _dio.post(path, data: data, queryParameters: queryParameters, options: options);

  Future<Response> patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _dio.patch(path, data: data, queryParameters: queryParameters, options: options);

  Future<Response> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) => _dio.delete(path, data: data, queryParameters: queryParameters, options: options);
}

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: 'https://sheets.googleapis.com/v4/spreadsheets/');
});
