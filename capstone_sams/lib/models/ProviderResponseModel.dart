class ProviderResponse<T> {
  final bool success;
  final T data;
  final String? errorMessage;

  ProviderResponse({
    required this.success,
    required this.data,
    this.errorMessage,
  });
}