// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:typed_data';


class AppState {
  final bool isLoading;
  final Uint8List? hasData;
  final Object? error;
  const AppState({
    required this.isLoading,
    this.hasData, 
    this.error,
  });
  const AppState.empty()
      : isLoading = false,
        hasData = null,
        error = null;

  @override
  String toString() => {
        'isLoading': isLoading,
        'hasData': hasData != null,
        'error': error
      }.toString();
}
