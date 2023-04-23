import 'package:flutter/foundation.dart';
import 'package:testingbloc_course/bloc/person.dart';

const person1Url = 'http://10.0.2.2:5500/api/persons1.json';
const person2Url = 'http://10.0.2.2:5500/api/person2.json';

@immutable
abstract class LoadAction {
  const LoadAction();
}

typedef PersonLoader =Future<Iterable<Person>> Function(String url);

@immutable
class LoadPersonsAction implements LoadAction {
  final String url;
  final PersonLoader loader;


  const LoadPersonsAction( {required this.url, required this.loader,});
}
