import 'package:dio/dio.dart';
import 'package:newarch/core/constants/app_strings.dart';
import 'package:newarch/core/models/pagination_model.dart';
import 'package:newarch/core/models/response_data_model.dart';
import 'package:newarch/core/utils/console_print.dart';
import 'package:newarch/environments/environments.dart';

class ApiData {
  int? statusCode;
  String? message;
  bool? _isSuccess;
  dynamic data;

  bool get hasError => !isSuccess;

  bool get isSuccess => _isSuccess ?? false;

  ApiData({
    required bool isSuccess,
    this.data,
    this.statusCode,
    this.message,
  }) {
    _isSuccess = isSuccess;
  }

  ApiData.from({required Response? response, required Object? error, required StackTrace? stackTrace}) {
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
    this.data = data;
    this.statusCode = statusCode;
    this.message = message;
  }

  ResponseData<T> getResponseData<T>({T Function(dynamic data)? dataParser, bool Function(dynamic data)? verifySuccess}) {
    bool isSuccess = this.isSuccess;
    String? errorMessage;
    T? data;

    if (isSuccess) {
      try {
        data = dataParser?.call(this.data);
      } catch (e, s) {
        xErrorPrint(e, stackTrace: s);
        errorMessage = AppStrings.failedToParse;
        isSuccess = false;
        if (currentEnvironment == Environments.prod) {
          errorMessage = AppStrings.somethingWentWrong;
        }
      }

      try {
        isSuccess = verifySuccess?.call(this.data) ?? isSuccess;
      } catch (e) {
        isSuccess = false;
        if (currentEnvironment == Environments.prod) {
          errorMessage = AppStrings.somethingWentWrong;
        }
      }
    }

    return ResponseData<T>(
      isSuccess: isSuccess,
      message: errorMessage ?? message,
      data: data,
      statusCode: statusCode,
    );
  }

  ResponseData<PaginationData<T>> getPaginationData<T>({T Function(dynamic data)? dataParser, bool Function(dynamic data)? verifySuccess}) {
    bool isSuccess = this.isSuccess;
    String? errorMessage;
    PaginationData<T>? paginationData;
    T? data;

    if (isSuccess) {
      // Trying to parse for data
      try {
        data = dataParser?.call(this.data);
      } catch (e, s) {
        xErrorPrint(e, stackTrace: s);
        errorMessage = AppStrings.failedToParse;
        isSuccess = false;
      }
      try {
        isSuccess = verifySuccess?.call(this.data) ?? isSuccess;
      } catch (e) {
        isSuccess = false;
        if (currentEnvironment == Environments.prod) {
          errorMessage = AppStrings.somethingWentWrong;
        }
      }
    }

    if (isSuccess) {
      // Trying to parse for pagination data
      try {
        paginationData = PaginationData.fromJson(this.data);
        paginationData.list = data;
      } catch (e, s) {
        xErrorPrint(e, stackTrace: s);
        errorMessage = AppStrings.failedToParse;
        isSuccess = false;
        if (currentEnvironment == Environments.prod) {
          errorMessage = AppStrings.somethingWentWrong;
        }
      }
    }
    return ResponseData<PaginationData<T>>(
      isSuccess: isSuccess,
      message: errorMessage ?? message,
      data: paginationData,
      statusCode: statusCode,
    );
  }
}
