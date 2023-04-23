import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:testingbloc_course/bloc/bloc_actions.dart';
import 'package:testingbloc_course/bloc/person.dart';
import 'package:testingbloc_course/bloc/persons_bloc.dart';

const mockedPerson2 = [
  Person(name: 'Foo', age: 20),
  Person(name: 'Bar', age: 30)
];
const mockedPerson1 = [
  Person(name: 'Foo', age: 20),
  Person(name: 'Bar', age: 30)
];
Future<Iterable<Person>> mockGetPerson1(String _) =>
    Future.value(mockedPerson1);
Future<Iterable<Person>> mockGetPerson2(String _) =>
    Future.value(mockedPerson2);
void main() {
  group('Testing bloc', () {
    //writing a test
    late PersonsBloc bloc;
    setUp(() {
      bloc = PersonsBloc();
    });
    blocTest<PersonsBloc, FetchResult?>('Test initial state',
        build: () => bloc, verify: (bloc) => expect(bloc.state, null));
    blocTest('Mock retrieving person1 from first iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(const LoadPersonsAction(
              loader: mockGetPerson1, url: 'Dummy url 1'));

          bloc.add(const LoadPersonsAction(
              loader: mockGetPerson1, url: 'Dummy url 1'));
        },
        expect: () => [
              const FetchResult(
                  persons: mockedPerson1, isRetrievedFromCache: false),
              const FetchResult(
                  persons: mockedPerson1, isRetrievedFromCache: true)
            ]);
    blocTest('Mock retrieving person2 from second iterable',
        build: () => bloc,
        act: (bloc) {
          bloc.add(const LoadPersonsAction(
              loader: mockGetPerson2, url: 'Dummy url 2'));

          bloc.add(const LoadPersonsAction(
              loader: mockGetPerson2, url: 'Dummy url 2'));
        },
        expect: () => [
              const FetchResult(
                  persons: mockedPerson2, isRetrievedFromCache: false),
              const FetchResult(
                  persons: mockedPerson2, isRetrievedFromCache: true)
            ]);
  });
}
