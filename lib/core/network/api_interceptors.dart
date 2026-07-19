import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:clean_starter/app/app_routes.dart';
import 'package:clean_starter/core/services/navigation_service.dart';
import 'package:clean_starter/di/locator.dart';
import '../services/token_service.dart';

final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.i(
      "--> ${options.method.toUpperCase()} ${options.baseUrl}${options.path}",
    );
    _logger.d("Headers: ${options.headers}");
    _logger.d("QueryParameters: ${options.queryParameters}");

    if (options.data != null) {
      if (options.data is FormData) {
        _logger.d(
          "Body: FormData fields: ${options.data.fields}, files: ${options.data.files.map((e) => e.value.filename)}",
        );
      } else {
        try {
          _logger.d("Body: ${jsonEncode(options.data)}");
        } catch (e) {
          _logger.w("Body: (Not JSON encodable) ${options.data.toString()}");
        }
      }
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.i(
      "<-- ${response.statusCode} ${response.requestOptions.method.toUpperCase()} ${response.requestOptions.baseUrl}${response.requestOptions.path}",
    );
    try {
      _logger.d("Response: ${jsonEncode(response.data)}");
    } catch (e) {
      _logger.w("Response: (Not JSON encodable) ${response.data.toString()}");
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      "<-- Error ${err.response?.statusCode} ${err.requestOptions.method.toUpperCase()} ${err.requestOptions.baseUrl}${err.requestOptions.path}",
      error: err.error,
      stackTrace: err.stackTrace,
    );
    if (err.response?.data != null) {
      try {
        _logger.e("Error Data: ${jsonEncode(err.response?.data)}");
      } catch (e) {
        _logger.w(
          "Error Data: (Not JSON encodable) ${err.response?.data.toString()}",
        );
      }
    }
    super.onError(err, handler);
  }
}

class AuthInterceptor extends Interceptor {
  final TokenService _tokenService = TokenService();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra["skipAuth"] == true) {
      return handler.next(options);
    }

    final accessToken = await _tokenService.getAccessToken();
    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final accessToken = await _tokenService.getAccessToken();

    if (err.response?.statusCode == 401 && accessToken != null) {
      await _tokenService.clearTokens();
      await getIt<NavigationService>().pushNamedAndRemoveUntil(AppRoutes.login);
    }

    handler.next(err);
  }
}
