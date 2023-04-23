import 'dart:convert';
import 'dart:developer' as devtools show log;
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';





Future<Iterable<Person>> getPersons(String url) => HttpClient()
    .getUrl(Uri.parse(url))
    .then((req) => req.close())
    .then((res) => res.transform(utf8.decoder).join())
    .then((str) => json.decode(str) as List<dynamic>)
    .then((list) => list.map((e) => Person.fromJson(e)));

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrievedFromCache;

  const FetchResult(
      {required this.persons, required this.isRetrievedFromCache});
  @override
  String toString() {
    return 'fetch result (isRetrivedFromCashe = $isRetrievedFromCache , persons= $persons)';
  }
}

//loggin
extension Log on Object {
  void log() => devtools.log(toString());
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<PersonUrl, Iterable<Person>> _chache = {};

  PersonsBloc() : super(null) {
    on<LoadPersonsAction>((event, emit) async {
      final url = event.personUrl;

      if (_chache.containsKey(url)) {
        final chachedPersons = _chache[url];
        final result =
            FetchResult(persons: chachedPersons!, isRetrievedFromCache: true);
        emit(result);
      } else {
        final person = await getPersons(url.urlString);
        _chache[url] = person;
        final result =
            FetchResult(persons: person, isRetrievedFromCache: false);
        emit(result);
      }
    });
  }
}

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) {
    return length > index ? elementAt(index) : null;
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {
                    context
                        .read<PersonsBloc>()
                        .add(const LoadPersonsAction(personUrl: PersonUrl.persons1));
                  },
                  child: const Text('Load 1st Json')),
              TextButton(
                  onPressed: () {
                    context
                        .read<PersonsBloc>()
                        .add(const LoadPersonsAction(personUrl: PersonUrl.persons2));
                  },
                  child: const Text('Load 2nd Json'))
            ],
          ), 
          BlocBuilder<PersonsBloc, FetchResult?>(
            buildWhen: (previous, current) {
              return previous?.persons != current?.persons;
            },
            builder: (context, state) {
              state?.log();
              final persons = state?.persons;
              if (persons == null) {
                return const SizedBox();
              } else {
                return Expanded(
                  child: ListView.builder(
                      itemCount: persons.length,
                      itemBuilder: (context, index) {
                        final person = persons[index]!;
                        return ListTile(title: Text(person.name));
                      }),
                );
              }
            },
          )
        ],
      ),
    ));
  }
}
