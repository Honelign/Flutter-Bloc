import 'package:flutter/foundation.dart';

import 'app_bloc.dart';
@immutable
class TopBloc extends AppBloc {
  TopBloc({
    required super.urls,
    Duration? waitBeforeLoading,
  });
}
