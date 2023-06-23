import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testingbloc_course/bloc/app_state.dart';
import 'dart:math' as math;
import 'bloc_events.dart';

typedef AppBlocRandomUrlPicker = String Function(Iterable<String> allUrls);

typedef AppBlocUrlLoader = Future<Uint8List> Function(String url);

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

@immutable
class AppBloc extends Bloc<AppEvent, AppState> {
  String _pickRandomUrl(Iterable<String> allUrls) => allUrls.getRandomElement();
  Future<Uint8List> _loadUrl(String url) => NetworkAssetBundle(Uri.parse(url))
      .load(url)
      .then((value) => value.buffer.asUint8List());
  AppBloc({
    AppBlocRandomUrlPicker? urlPicker,
    Duration? waitBeforeLoading,
    required Iterable<String> urls,
    AppBlocUrlLoader? urlLoader,
  }) : super(const AppState.empty()) {
    on<LoadNextUrlEvent>((event, emit) async {
      emit(
        const AppState(
          isLoading: true,
          hasData: null,
          error: null,
        ),
      );
      final url = (urlPicker ?? _pickRandomUrl)(urls);
      try {
        if (waitBeforeLoading != null) {
          await Future.delayed(waitBeforeLoading);
        }
        final data = await (urlLoader ?? _loadUrl)(url);
        emit(AppState(
          isLoading: false,
          hasData: data,
          error: null,
        ));
      } catch (e) {
        emit(AppState(
          isLoading: false,
          hasData: null,
          error: e,
        ));
      }
    });
  }
}
