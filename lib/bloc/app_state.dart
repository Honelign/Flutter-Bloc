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
  @override
  bool operator ==(covariant AppState other) =>
      isLoading == other.isLoading &&
      (hasData ?? []).isEqualTo(other.hasData ?? []) &&
      error == other.error;

  @override
  // TODO: implement hashCode
  int get hashCode => Object.hash(
        isLoading,
        hasData,
        error,
      );
}

extension Comparison<E> on List<E> {
  bool isEqualTo(List<E> other) {
    if (identical(this, other)) {
      return true;
    }
    if (length != other.length) {
      return false;
    }
    for (var i = 0; i < length; i++) {
      if (this[i] != other[i]) {
        return false;
      }
    }
    return true;
  }
}
