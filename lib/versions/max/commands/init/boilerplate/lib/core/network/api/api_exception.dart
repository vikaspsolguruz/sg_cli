import 'dart:io';

import 'package:dio/dio.dart';
import 'package:max_arch/core/utils/extensions.dart';

class ApiException {
  late DioException _dioException;
  String? _message;

  DioException get dioError => DioException(
    error: _dioException.error,
    requestOptions: _dioException.requestOptions,
    message: _message,
  );

  ApiException.fromDioError(DioException dioException) {
    _dioException = dioException;

    String? preError;
    if (dioException.response?.data is Map<String, dynamic>) {
      preError = dioException.response?.data?['message'];
    }
    preError ??= dioException.response?.statusMessage;
    if (preError != null) {
      _message = preError;
      return;
    }

    final error = dioException.error;

    switch (dioException.type) {
      case DioExceptionType.cancel:
        return; // when we cancel api calls by cancelToken, it will comes to this exception. we do not need to show as error.
      case DioExceptionType.connectionTimeout:
        _message = "Connection timeout with server";
        break;
      case DioExceptionType.receiveTimeout:
        _message = "Receive timeout";
        break;
      case DioExceptionType.badResponse:
        _message = 'Bad response';
        break;
      case DioExceptionType.sendTimeout:
        _message = "Send timeout";
        break;
      case DioExceptionType.connectionError:
        _message = "Could not connect to server";
        break;
      case DioExceptionType.badCertificate:
        _message = dioException.message ?? "Bad certificate";
        break;
      case DioExceptionType.unknown:
        if (error is SocketException) {
          _message = error.message.nullable ?? 'No Internet';
        }
        if (error is HttpException) {
          _message = error.message.nullable ?? 'Unexpected http error';
        }
        break;
    }
    _message ??= "Something went wrong";
  }

  @override
  String toString() => _message ?? '';
}
