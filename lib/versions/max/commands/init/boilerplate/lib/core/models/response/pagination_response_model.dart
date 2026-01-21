import 'package:max_arch/core/models/pagination_data_model.dart';
import 'package:max_arch/core/models/response/base_response_model.dart';

class PaginationResponse<T> extends BaseResponseModel {
  final String? message;
  final PaginationData<T>? paginationData;
  final bool isSuccess;
  final int? statusCode;

  bool get hasError => !isSuccess;

  const PaginationResponse({
    required this.isSuccess,
    required this.message,
    this.paginationData,
    this.statusCode,
  });
}
