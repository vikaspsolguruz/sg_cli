import 'package:max_arch/core/models/response/base_response_model.dart';

class NormalResponse<T> extends BaseResponseModel {
  final String? message;
  final T? data;
  final bool isSuccess;
  final int? statusCode;

  bool get hasError => !isSuccess;

  const NormalResponse({
    required this.isSuccess,
    required this.message,
    this.data,
    this.statusCode,
  });
}
