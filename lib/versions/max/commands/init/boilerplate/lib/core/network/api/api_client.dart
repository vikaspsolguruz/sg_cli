import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:max_arch/core/constants/constants.dart';
import 'package:max_arch/core/models/api_data_model.dart';
import 'package:max_arch/core/network/api/api_interceptor.dart';
import 'package:max_arch/core/network/api/api_urls.dart';

class ApiClient {
  static ApiClient? _apiClient;

  static ApiClient get instance => _apiClient ??= ApiClient();

  CancelToken _cancelToken = CancelToken();

  void cancelAll() => _cancelToken.cancel();

  void reset() {
    _cancelToken = CancelToken();
    _apiClient = null;
  }

  final Dio _dio = Dio();

  ApiClient() {
    // Setting base options
    _dio.options = BaseOptions(
      baseUrl: ApiLinks.baseUrl,
      headers: {'Content - Type': 'application / json'},
      sendTimeout: const Duration(seconds: 300),
      receiveTimeout: const Duration(seconds: 300),
      connectTimeout: const Duration(seconds: 300),
      followRedirects: true,
      persistentConnection: true,
      preserveHeaderCase: true,
      validateStatus: (status) => status! < 500 && status != 401,
    );

    // Setting http client
    _dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final client = HttpClient();
        client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
        return client;
      },
    );

    // Setting interceptors
    _dio.interceptors.add(ApiInterceptor());
  }

  void setBaseToken({String? token}) {
    _dio.options.headers.addAll({"Authorization": "Bearer ${token ?? kStaticToken}"});
  }

  void removeBaseToken() {
    _dio.options.headers.addAll({"Authorization": "Bearer $kStaticToken"});
  }

  Future<ApiData> get(String url, {Map<String, dynamic>? queryParameters}) async {
    Response? response;
    Object? error;
    StackTrace? stackTrace;
    if (kDebugMode) {
      await Future.delayed(const Duration(milliseconds: 800));
    }
    try {
      response = await _dio.get(url, queryParameters: queryParameters, cancelToken: _cancelToken);
    } catch (e, s) {
      error = e;
      stackTrace = s;
    }
    return ApiData.from(response: response, error: error, stackTrace: stackTrace);
  }

  Future<ApiData> post(String url, {required Map<String, dynamic> body, Map<String, dynamic>? queryParameters}) async {
    Response? response;
    Object? error;
    StackTrace? stackTrace;
    if (kDebugMode) {
      await Future.delayed(const Duration(milliseconds: 800));
    }
    try {
      response = await _dio.post(url, data: json.encode(body), cancelToken: _cancelToken, queryParameters: queryParameters);
    } catch (e, s) {
      error = e;
      stackTrace = s;
    }
    return ApiData.from(response: response, error: error, stackTrace: stackTrace);
  }

  Future<ApiData> patch(String url, {Map<String, dynamic>? body, Map<String, dynamic>? queryParameters}) async {
    Response? response;
    Object? error;
    StackTrace? stackTrace;
    if (kDebugMode) {
      await Future.delayed(const Duration(milliseconds: 800));
    }
    try {
      response = await _dio.patch(url, data: body != null ? json.encode(body) : null, queryParameters: queryParameters, cancelToken: _cancelToken);
    } catch (e, s) {
      error = e;
      stackTrace = s;
    }
    return ApiData.from(response: response, error: error, stackTrace: stackTrace);
  }

  Future<ApiData> put(String url, {required Map<String, dynamic> body, Map<String, dynamic>? headers, dynamic param}) async {
    Response? response;
    Object? error;
    StackTrace? stackTrace;
    if (kDebugMode) {
      await Future.delayed(const Duration(milliseconds: 800));
    }
    try {
      response = await _dio.put(
        url,
        data: body,
        options: headers != null ? Options(headers: headers) : null,
        queryParameters: param,
        cancelToken: _cancelToken,
      );
    } catch (e, s) {
      error = e;
      stackTrace = s;
    }
    return ApiData.from(response: response, error: error, stackTrace: stackTrace);
  }

  Future<ApiData> delete(String url, {Map<String, dynamic>? body, dynamic param}) async {
    Response? response;
    Object? error;
    StackTrace? stackTrace;
    if (kDebugMode) {
      await Future.delayed(const Duration(milliseconds: 800));
    }
    try {
      response = await _dio.delete(url, data: body, queryParameters: param, cancelToken: _cancelToken);
    } catch (e, s) {
      error = e;
      stackTrace = s;
    }
    return ApiData.from(response: response, error: error, stackTrace: stackTrace);
  }

  Future<ApiData> uploadImage({required XFile file, Function(int progress)? onProgressChange, required String folder}) async {
    String fileName = file.name;

    // Get MIME type
    final String mime = lookupMimeType(file.path, headerBytes: await file.readAsBytes()) ?? '';

    // Get file name if not provided
    var extension = extensionFromMime(mime);
    fileName = "${DateTime.now().millisecondsSinceEpoch}.$extension";

    // Set Content-Type
    final contentType = DioMediaType.parse(mime);

    // Create MultipartFile based on source
    MultipartFile multipartFile;

    multipartFile = await MultipartFile.fromFile(file.path, contentType: contentType, filename: fileName);

    // Prepare FormData
    final formData = FormData.fromMap(
      {
        "folder": folder,
        "file": multipartFile,
      },
    );

    // Calling Api
    Response? response;
    Object? error;
    StackTrace? stackTrace;
    try {
      response = await _dio.post(
        ApiLinks.uploadImage,
        data: formData,
        onSendProgress: (count, total) {
          int progress = ((count / total) * 100).toInt();
          if (progress < 100) onProgressChange?.call(progress);
        },
        onReceiveProgress: (count, total) {
          int progress = ((count / total) * 100).toInt();
          if (progress == 100) onProgressChange?.call(progress);
        },
        cancelToken: _cancelToken,
      );
    } catch (e, s) {
      error = e;
      stackTrace = s;
    }
    return ApiData.from(response: response, error: error, stackTrace: stackTrace);
  }

  Future<ApiData> uploadMultipleFiles({required List<XFile> files, Function(int progress)? onProgressChange, required String folder}) async {
    List<MultipartFile> multipartFiles = [];

    for (var file in files) {
      String fileName = file.name;

      // Get MIME type
      final String mime = lookupMimeType(file.path, headerBytes: await file.readAsBytes()) ?? '';

      // Get file name if not provided
      var extension = extensionFromMime(mime);
      fileName = "${DateTime.now().millisecondsSinceEpoch}.$extension";

      // Set Content-Type
      final contentType = DioMediaType.parse(mime);

      multipartFiles.add(await MultipartFile.fromFile(file.path, contentType: contentType, filename: fileName));
    }

    // Prepare FormData
    final formData = FormData.fromMap(
      {
        "folder": folder,
        "files": multipartFiles,
      },
    );

    // Calling Api
    Response? response;
    Object? error;
    StackTrace? stackTrace;
    try {
      response = await _dio.post(
        ApiLinks.uploadImages,
        data: formData,
        onSendProgress: (count, total) {
          int progress = ((count / total) * 100).toInt();
          if (progress < 100) onProgressChange?.call(progress);
        },
        onReceiveProgress: (count, total) {
          int progress = ((count / total) * 100).toInt();
          if (progress == 100) onProgressChange?.call(progress);
        },
        cancelToken: _cancelToken,
      );
    } catch (e, s) {
      error = e;
      stackTrace = s;
    }
    return ApiData.from(response: response, error: error, stackTrace: stackTrace);
  }
}
