import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'dart:math' as math show Random;

const names = [
  'Foo',
  'Bar',
  'Baz',
];

extension RandomElement<T> on Iterable<T> {
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class NamesCubit extends Cubit<String?> {
  NamesCubit() : super(null);
  void pickRandomNames() => emit(names.getRandomElement());
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late NamesCubit cubit;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cubit = NamesCubit();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<String?>(
        stream: cubit.stream,
        builder: (context, snapshot) {
          final button = TextButton(
              onPressed: () => cubit.pickRandomNames(),
              child: const Text("Pick a random name"));
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return button;
          
            case ConnectionState.waiting:
             return button;
           
            case ConnectionState.active:
                return Column(
                  children: [
                    Text(snapshot.data ?? ''),
                    button,
                  ],
                );
              // TODO: Handle this case.
             
            case ConnectionState.done:
              return const SizedBox();
             
          }
        },
      ),
    );
  }
}
