import 'package:flutter/material.dart';
import 'package:testingbloc_course/bloc/app_state.dart';
import 'package:testingbloc_course/bloc/bloc_events.dart';
import '/extension/stream/start_with.dart';
import '../bloc/app_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocView<T extends AppBloc> extends StatelessWidget {
  const AppBlocView({super.key});
  void startUpdatingBloc(BuildContext context) {
    Stream.periodic(
      const Duration(seconds: 10),
      (_) => const LoadNextUrlEvent(),
    ).startWith(const LoadNextUrlEvent()).forEach((event) {
      context.read<T>().add(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    startUpdatingBloc(context);
    return Expanded(
      child: BlocBuilder<T, AppState>(
        builder: (context, appState) {
          if (appState.error != null) {
            return const Text('an error occured');
          } else if (appState.hasData != null) {
            return Image.memory(
              appState.hasData!,
              fit: BoxFit.cover,
            );
          } else {  
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
