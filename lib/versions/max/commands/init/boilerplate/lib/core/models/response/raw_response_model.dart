import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:max_arch/core/constants/app_strings.dart';
import 'package:max_arch/core/models/pagination_data_model.dart';
import 'package:max_arch/core/models/response/normal_response_model.dart';
import 'package:max_arch/core/models/response/pagination_response_model.dart';
import 'package:max_arch/core/utils/console_print.dart';
import 'package:max_arch/environments/environments.dart';

class RawResponse {
  int? statusCode;
  String? message;
  bool? _isSuccess;
  dynamic rawData;

  bool get hasError => !isSuccess;

  bool get isSuccess => _isSuccess ?? false;

  RawResponse({
    required bool isSuccess,
    this.rawData,
    this.statusCode,
    this.message,
  }) {
    _isSuccess = isSuccess;
  }

  RawResponse.from({required Response? response, required Object? error, required StackTrace? stackTrace}) {
    bool isSuccess = error == null && response?.data is Map<String, dynamic> && response!.data['status'] == 1;
    dynamic data = response?.data;
    int? statusCode;
    String? message;
    try {
      message = response?.data?['message'];
    } catch (e, s) {
      xErrorPrint(e, stackTrace: s);
      if (response?.statusCode == 413) {
        message = AppStrings.fileTooLarge;
      } else {
        message = error?.toString();
      }
      isSuccess = false;
    }

    if (isSuccess) {
      data = response?.data;
      statusCode = response?.statusCode;
      message = response?.data['message'];
    } else {
      if (error is DioException) {
        message = error.message ?? error.error?.toString();
        data = error.response?.data;
        statusCode = error.response?.statusCode;
      }
      message ??= error?.toString();
      xErrorPrint(message, stackTrace: stackTrace);
    }
    _isSuccess = isSuccess;
    rawData = data;
    this.statusCode = statusCode;
    this.message = message;
  }

  NormalResponse<T> getNormalResponse<T>({
    T Function(dynamic rawData)? dataParser,
    bool Function(T data)? verifySuccess,
  }) {
    bool isSuccess = this.isSuccess;
    String? errorMessage;
    T? data;

    if (isSuccess) {
      // Trying data parser if exists
      try {
        data = dataParser?.call(rawData);
      } catch (e, s) {
        xErrorPrint(e, stackTrace: s);
        isSuccess = false;
        errorMessage = _parsingErrorMessage();
      }

      // Trying custom success verifier if exists
      if (isSuccess) {
        try {
          isSuccess = verifySuccess?.call(data as T) ?? isSuccess;
        } catch (e, s) {
          xErrorPrint(e, stackTrace: s);
          isSuccess = false;
          errorMessage = _parsingErrorMessage();
        }
      }
    }

    return NormalResponse<T>(
      isSuccess: isSuccess,
      message: errorMessage ?? message,
      data: data,
      statusCode: statusCode,
    );
  }

  PaginationResponse<T> getPaginationResponse<T>({
    List<T> Function(dynamic rawData)? dataParser,
    bool Function(List<T> data)? verifySuccess,
  }) {
    bool isSuccess = this.isSuccess;
    String? errorMessage;
    PaginationData<T>? paginationData;
    List<T>? data;

    if (isSuccess) {
      // Trying data parser if exists
      try {
        data = dataParser?.call(rawData);
      } catch (e, s) {
        xErrorPrint(e, stackTrace: s);
        errorMessage = _parsingErrorMessage();
        isSuccess = false;
      }

      // Trying custom success verifier if exists
      if (isSuccess) {
        try {
          isSuccess = verifySuccess?.call(data as List<T>) ?? isSuccess;
        } catch (e, s) {
          xErrorPrint(e, stackTrace: s);
          isSuccess = false;
          errorMessage = _parsingErrorMessage();
        }
      }
    }

    if (isSuccess) {
      // Trying to parse for pagination data if data been parsed successfully
      try {
        paginationData = PaginationData.fromJson(rawData);
        paginationData.list = data;
      } catch (e, s) {
        xErrorPrint(e, stackTrace: s);
        isSuccess = false;
        errorMessage = _parsingErrorMessage();
      }
    }
    return PaginationResponse<T>(
      isSuccess: isSuccess,
      message: errorMessage ?? message,
      paginationData: paginationData,
      statusCode: statusCode,
    );
  }
}

String _parsingErrorMessage() {
  if (currentEnvironment == Environments.prod && kReleaseMode) return AppStrings.somethingWentWrong;
  return AppStrings.failedToParse;
}
