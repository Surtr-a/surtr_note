import 'dart:io';
import 'package:dio/dio.dart';

class AppException implements Exception {
  final String? _message;

  String get message => _message ?? this.runtimeType.toString();
  final int? _code;

  int get code => _code ?? -1;

  AppException([this._message, this._code]);

  String toString() {
    return "code:$code--message=$message";
  }

  factory AppException.obtainFromMessage(String? error) {
    return UnknownException(error);
  }

  factory AppException.obtainFromException(Exception error) {
    if (error is DioError) {
      switch (error.type) {
        case DioErrorType.connectTimeout:
        case DioErrorType.receiveTimeout:
        case DioErrorType.sendTimeout:
          return NetworkException(error.error.message);
        case DioErrorType.response:
          return HttpException(error.error.message, error.response?.statusCode);
        case DioErrorType.cancel:
          return CancelException(error.error.message);
        case DioErrorType.other:
          if (error.error is SocketException) {
            // SocketException: Failed host lookup: '***'
            // (OS Error: No address associated with hostname, errno = 7)
            return NetworkException(error.error.message);
          } else {
            return UnknownException(error.error.message);
          }
        default:
          return FetchDataException(error.error.message);
      }
    } else {
      return FetchDataException(error.toString());
    }
  }
}

class HttpException extends AppException {
  HttpException([String? message, int? code]) : super(message, code);
}

class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(
          message,
        );
}

class UnknownException extends AppException {
  UnknownException([String? message])
      : super(
          message,
        );
}

class CancelException extends AppException {
  CancelException([String? message])
      : super(
          message,
        );
}

class NetworkException extends AppException {
  NetworkException([String? message])
      : super(
          message,
        );
}
