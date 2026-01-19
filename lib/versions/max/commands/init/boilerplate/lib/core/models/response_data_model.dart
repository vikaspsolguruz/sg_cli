class ResponseData<T> {
  final String? message;
  final T? data;
  final bool isSuccess;
  final int? statusCode;

  bool get hasError => !isSuccess;

  const ResponseData({
    required this.isSuccess,
    required this.message,
    this.data,
    this.statusCode,
  });
}
