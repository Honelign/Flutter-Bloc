import 'package:flutter/foundation.dart';

import 'app_bloc.dart';
@immutable
class BottomBloc extends AppBloc {
  BottomBloc({
    required super.urls,
    Duration? waitBeforeLoading,
  });
}
