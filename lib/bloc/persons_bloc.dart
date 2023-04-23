import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc_actions.dart';
import 'person.dart';

extension IsEqualIgnoringOrdering<T> on Iterable<T>{
  bool isEqualIgnoringOrdering(Iterable<T> other)
  => length ==other.length && {...this}.intersection({...other}).length==length;
}


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
  @override bool operator == (covariant FetchResult other)=>
  persons.isEqualIgnoringOrdering(other.persons)&&
  isRetrievedFromCache==other.isRetrievedFromCache;
  
  @override
  // TODO: implement hashCode
  int get hashCode => Object.hash(persons, isRetrievedFromCache);
  
}


class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<String, Iterable<Person>> _chache = {};

  PersonsBloc() : super(null) {
    on<LoadPersonsAction>((event, emit) async {
      final url = event.url;

      if (_chache.containsKey(url)) {
        final chachedPersons = _chache[url];
        final result =
            FetchResult(persons: chachedPersons!, isRetrievedFromCache: true);
        emit(result);
      } else {
        final loader=event.loader;
        final person = await loader(url);
        _chache[url] = person;
        final result =
            FetchResult(persons: person, isRetrievedFromCache: false);
        emit(result);
      }
    });
  }
}