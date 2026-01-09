class HttpResult {
  final bool isSuccess;
  final int status;
  dynamic error;
  dynamic result;

  HttpResult({
    this.error,
    required this.isSuccess,
    required this.result,
    required this.status,
  });
}
