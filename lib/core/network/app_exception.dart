import 'dart:io';

import 'package:dio/dio.dart';

class ApiException implements Exception {
  ApiException({
    required this.message,
    this.statusCode,
    this.response,
  });

  final String message;
  final int? statusCode;
  final Response? response;

  @override
  String toString() {
    return 'ApiException: $message (Status Code: $statusCode)';
  }
}

class NetworkException extends ApiException {
  NetworkException({
    super.message = "No internet connection. Please check your network.",
  });
}

class TimeoutException extends ApiException {
  TimeoutException({
    super.message = "The connection has timed out. Please try again.",
  });
}

class ServerException extends ApiException {
  ServerException({
    required super.message,
    super.statusCode,
    super.response,
  });
}

class ClientException extends ApiException {
  ClientException({
    required super.message,
    super.statusCode,
    super.response,
  });
}

class UnauthorizedException extends ClientException {
  UnauthorizedException({
    super.message = "Unauthorized. Please login again.",
    super.response,
  }) : super(statusCode: 401);
}

class BadRequestException extends ClientException {
  BadRequestException({
    super.message = "Bad request. Please check your input.",
    super.response,
  }) : super(statusCode: 400);
}

class NotFoundException extends ClientException {
  NotFoundException({
    super.message = "The requested resource was not found.",
    super.response,
  }) : super(statusCode: 404);
}

class RequestCancelledException extends ClientException {
  RequestCancelledException({
    super.message = "User Cancelled the Request",
    super.response,
  }) : super(statusCode: 499);
}

class ForbiddenException extends ClientException {
  ForbiddenException({
    super.message = "You do not have permission to access this resource.",
    super.response,
  }) : super(statusCode: 403);
}

class InternalServerErrorException extends ServerException {
  InternalServerErrorException({
    super.message = "An unexpected error occurred on the server.",
    super.response,
  }) : super(statusCode: 500);
}

// Helper to map DioError to ApiException
ApiException handleDioError(DioException error) {
  if (error.type == DioExceptionType.connectionTimeout ||
      error.type == DioExceptionType.sendTimeout ||
      error.type == DioExceptionType.receiveTimeout) {
    return TimeoutException();
  } else if (error.type == DioExceptionType.badResponse) {
    final statusCode = error.response?.statusCode;
    final responseData = error.response?.data;
    String errorMessage = "An error occurred";

    if (responseData is Map && responseData.containsKey('message')) {
      errorMessage = responseData['message'];
    } else if (responseData is String && responseData.isNotEmpty) {
      errorMessage = responseData;
    } else if (error.message != null && error.message!.isNotEmpty) {
      errorMessage = error.message!;
    }

    if (statusCode == 400) {
      return BadRequestException(
        message: errorMessage,
        response: error.response,
      );
    } else if (statusCode == 401) {
      return UnauthorizedException(
        message: errorMessage,
        response: error.response,
      );
    } else if (statusCode == 403) {
      return ForbiddenException(
        message: errorMessage,
        response: error.response,
      );
    } else if (statusCode == 404) {
      return NotFoundException(message: errorMessage, response: error.response);
    } else if (statusCode != null && statusCode >= 500) {
      return ServerException(
        message: errorMessage,
        statusCode: statusCode,
        response: error.response,
      );
    } else {
      return ClientException(
        message: errorMessage,
        statusCode: statusCode,
        response: error.response,
      );
    }
  } else if (error.type == DioExceptionType.connectionError ||
      error.error is SocketException) {
    return NetworkException();
  } else {
    return ApiException(message: error.message ?? "An unknown error occurred.");
  }
}
