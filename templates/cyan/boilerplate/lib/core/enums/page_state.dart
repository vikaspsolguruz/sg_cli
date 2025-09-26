enum PageState {
  /// This will be initial state when page is loaded for first time
  loading,

  /// This will be state when api has been called with success
  success,

  /// This will be state when api has been called with error
  error,
}
