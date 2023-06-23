import 'dart:typed_data';

import 'package:bloc_test/bloc_test.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:testingbloc_course/bloc/app_bloc.dart';
import 'package:testingbloc_course/bloc/app_state.dart';
import 'package:testingbloc_course/bloc/bloc_events.dart';

extension ToList on String {
  Uint8List toUint8List() => Uint8List.fromList(codeUnits);
}

final text1Data = 'Foo'.toUint8List();
final text2Data = 'Bar'.toUint8List();

enum Errors { dummy }

void main() {
  blocTest<AppBloc, AppState>(
    'Initial State of thhe bloc is empty',
    build: () => AppBloc(urls: const []),
    verify: (appBloc) => expect(
      appBloc.state,
      const AppState.empty(),
    ),
  );
  // load valid data and compare states
  blocTest<AppBloc, AppState>(
    'testing load url event',
    build: () => AppBloc(
      urls: const [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text1Data),
    ),
    act: (appBloc) => appBloc.add(
      const LoadNextUrlEvent(),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        hasData: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        hasData: text1Data,
        error: null,
      ),
    ],
  );
  blocTest<AppBloc, AppState>(
    'Throw an error in url Loader and catch it',
    build: () => AppBloc(
      urls: const [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.error(Errors.dummy),
    ),
    act: (appBloc) => appBloc.add(
      const LoadNextUrlEvent(),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        hasData: null,
        error: null,
      ),
      const AppState(
        isLoading: false,
        hasData: null,
        error: Errors.dummy,
      ),
    ],
  );
  blocTest<AppBloc, AppState>(
    'test the ability to load more than one url',
    build: () => AppBloc(
      urls: const [],
      urlPicker: (_) => '',
      urlLoader: (_) => Future.value(text2Data),
    ),
    act: (appBloc) {
      appBloc.add(
        const LoadNextUrlEvent(),
      );
      appBloc.add(
        const LoadNextUrlEvent(),
      );
    },
    expect: () => [
      const AppState(
        isLoading: true,
        hasData: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        hasData: text2Data,
        error: null,
      ),
      const AppState(
        isLoading: true,
        hasData: null,
        error: null,
      ),
      AppState(
        isLoading: false,
        hasData: text2Data,
        error: null,
      ),
    ],
  );
}
