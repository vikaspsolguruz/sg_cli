import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:max_arch/core/network/api/api_exception.dart';
import 'package:max_arch/core/utils/console_print.dart';
import 'package:max_arch/core/utils/log_out.dart';

class ApiInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!kReleaseMode) {
      options.extra['stopwatch'] = Stopwatch()..start();
    }
    xPayloadPrint(options.headers, title: 'API HEADERS');
    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!kReleaseMode) {
      final Stopwatch stopWatch = response.requestOptions.extra['stopwatch'];
      stopWatch.stop();
      final String time = stopWatch.elapsedMilliseconds.toString();
      Object? payload = response.requestOptions.data;
      if (payload is FormData) {
        payload = payload.fields.map((e) => e.toString());
      }
      xPayloadPrint(payload);
      xPrint("${response.statusCode} | ${response.requestOptions.method} | ${response.requestOptions.uri} | $time ms", title: 'API SUCCESS');
      xResponsePrint(response.data);
    }

    return super.onResponse(response, handler);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      logOutUser();
      xErrorPrint(err.response?.data);
      return;
    }
    if (!kReleaseMode) {
      final Stopwatch stopWatch = err.requestOptions.extra['stopwatch'];
      stopWatch.stop();
      final String time = stopWatch.elapsedMilliseconds.toString();
      xPayloadPrint(err.requestOptions.data);
      xPrint("${err.response?.statusCode ?? ''} ${err.requestOptions.method} | ${err.requestOptions.uri} | $time ms", title: 'API ERROR');

      if (err.response != null) {
        xResponsePrint(err.response?.data);
      }
    }

    final ApiException exception = ApiException.fromDioError(err);
    return super.onError(exception.dioError, handler);
  }
}
