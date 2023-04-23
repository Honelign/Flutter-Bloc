import 'package:flutter/foundation.dart';

@immutable
abstract class LoadAction {
  const LoadAction();
}
enum PersonUrl { persons1, persons2 }

extension GetPersonUrl on PersonUrl {
  String get urlString {
    switch (this) {
      case PersonUrl.persons1:
        return 'http://10.0.2.2:5500/api/persons1.json';

      case PersonUrl.persons2:
        return 'http://10.0.2.2:5500/api/person2.json';
    }
  }
}

@immutable
class LoadPersonsAction implements LoadAction {
  final PersonUrl personUrl;

  const LoadPersonsAction({required this.personUrl});

}
