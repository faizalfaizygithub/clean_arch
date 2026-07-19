import 'dart:developer';
import 'dart:io';
import 'package:clean_starter/core/network/app_exception.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'api_interceptors.dart';

class ApiClient {
  ApiClient({required this.baseUrl}) {
    final baseOptions = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );

    _dio = Dio(baseOptions);
    _dio.interceptors.add(AuthInterceptor());

    if (!kReleaseMode) {
      _dio.interceptors.add(LoggingInterceptor());
    }
  }

  late final Dio _dio;
  final String baseUrl;

  Future<void> _checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.none)) {
      throw NetworkException();
    }
  }

  Options _mergeOptions(Options? options, Map<String, String>? customHeaders) {
    final effectiveOptions = options ?? Options();
    effectiveOptions.headers = {
      ...?effectiveOptions.headers,
      ...?customHeaders,
    };
    return effectiveOptions;
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    Map<String, String>? customHeaders,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    await _checkConnectivity();

    return await _retry(() {
      return _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: _mergeOptions(options, customHeaders),
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
    });
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    Map<String, String>? customHeaders,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    await _checkConnectivity();

    return await _retry(() {
      return _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, customHeaders),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    });
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    Map<String, String>? customHeaders,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    await _checkConnectivity();
    return await _retry(() {
      return _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, customHeaders),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    });
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    Map<String, String>? customHeaders,
    CancelToken? cancelToken,
  }) async {
    await _checkConnectivity();
    return await _retry(() {
      return _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, customHeaders),
        cancelToken: cancelToken,
      );
    });
  }

  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    Map<String, String>? customHeaders,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    await _checkConnectivity();
    return await _retry(() {
      return _dio.patch<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(options, customHeaders),
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    });
  }

  Future<Response<T>> postFormData<T>(
    String path, {
    required FormData formData,
    Map<String, dynamic>? queryParameters,
    Options? options,
    Map<String, String>? customHeaders,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final effectiveOptions = _mergeOptions(options, customHeaders);
    effectiveOptions.headers?['Content-Type'] = 'multipart/form-data';
    await _checkConnectivity();
    return await post<T>(
      path,
      data: formData,
      queryParameters: queryParameters,
      options: effectiveOptions,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
  }

  Future<Response> downloadFile({
    required String url,
    required String savePath,
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) async {
    await _checkConnectivity();
    try {
      return await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
      );
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException(message: 'Unexpected error: $e');
    }
  }

  Future<Response<T>> _retry<T>(
    Future<Response<T>> Function() requestFn, {
    int retries = 3,
    Duration delay = const Duration(seconds: 2),
  }) async {
    int attempt = 0;
    while (true) {
      try {
        return await requestFn();
      } catch (e) {
        final isNetworkError = e is DioException &&
            (e.type == DioExceptionType.connectionTimeout ||
                e.type == DioExceptionType.sendTimeout ||
                e.type == DioExceptionType.receiveTimeout ||
                e.type == DioExceptionType.connectionError ||
                e.type == DioExceptionType.unknown ||
                e.error is SocketException);

        if (e is DioException && e.type == DioExceptionType.cancel) {
          throw RequestCancelledException();
        }

        if (attempt >= retries || !isNetworkError) {
          if (e is DioException) {
            throw handleDioError(e);
          }
          throw ApiException(message: "Unexpected error: $e");
        }

        attempt++;
        await Future.delayed(delay * attempt);
      }
    }
  }
}

Future<Either<ApiException, T>> handleApiCall<T>(
  Future<Either<ApiException, T>> Function() action,
) async {
  try {
    return await action();
  } on ApiException catch (e) {
    return Left(e);
  } catch (e, s) {
    log(e.toString());
    log(s.toString());
    return Left(ApiException(message: 'Something went wrong'));
  }
}
