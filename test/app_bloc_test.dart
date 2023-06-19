// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testingbloc_course/apis/login_api.dart';
import 'package:testingbloc_course/apis/notes_api.dart';
import 'package:testingbloc_course/bloc/actions.dart';
import 'package:testingbloc_course/bloc/app_bloc.dart';
import 'package:testingbloc_course/bloc/app_state.dart';
import 'package:testingbloc_course/models.dart';

const Iterable<Note> mockNotes = [
  Note(title: 'Note 1'),
  Note(title: 'Note 2'),
  Note(title: 'Note 3'),
];

@immutable
class DummyNotesApi implements NotesApiProtocol {
  final LoginHandle acceptedLogin;
  final Iterable<Note>? notesToReturn;
  const DummyNotesApi({
    required this.acceptedLogin,
    this.notesToReturn,
  });
  const DummyNotesApi.empty()
      : acceptedLogin = const LoginHandle.fooBar(),
        notesToReturn = null;

  @override
  Future<Iterable<Note>?> getNotes({required LoginHandle loginHandle}) async {
    if (loginHandle == acceptedLogin) {
      return notesToReturn;
    } else {
      return null;
    }
  }
}

@immutable
class DummyLoginApi implements LoginApiProtocol {
  final String acceptedEmail;
  final String acceptedPassword;
  final LoginHandle handleToReturn;
  const DummyLoginApi({
    required this.acceptedEmail,
    required this.acceptedPassword,
    required this.handleToReturn,
  });
  const DummyLoginApi.empty()
      : acceptedEmail = '',
        acceptedPassword = '',
        handleToReturn = const LoginHandle.fooBar();

  @override
  Future<LoginHandle?> login(
      {required String email, required String password}) async {
    if (email == acceptedEmail && password == acceptedPassword) {
      return handleToReturn;
    } else {
      return null;
    }
  }
}

void main() {
  blocTest<AppBloc, AppState>(
    'Initial State if the bloc',
    build: () => AppBloc(
        loginApi: const DummyLoginApi.empty(),
        notesApi: const DummyNotesApi.empty(),
        acceptedLogin: const LoginHandle(token: 'ABC')),
    verify: (appState) => expect(appState.state, const AppState.empty()),
  );
  blocTest<AppBloc, AppState>(
    'Can we login with correct credentials',
    build: () => AppBloc(
      acceptedLogin: const LoginHandle(token: 'ABC'),
      loginApi: const DummyLoginApi(
          acceptedEmail: 'foo@bar.com',
          acceptedPassword: 'foobar',
          handleToReturn: LoginHandle(token: 'ABC')),
      notesApi: const DummyNotesApi.empty(),
    ),
    act: (appBloc) => appBloc.add(
      const LoginAction(email: 'foo@bar.com', password: 'foobar'),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandle: null,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: null,
        loginHandle: LoginHandle(token: 'ABC'),
        fetchedNotes: null,
      )
    ],
  );
  const acceptedLogin = LoginHandle(token: "ABC");
  blocTest<AppBloc, AppState>(
    'Can we login with wrong credentials',
    build: () => AppBloc(
      acceptedLogin: acceptedLogin,
      loginApi: const DummyLoginApi(
          acceptedEmail: 'bar@baz.com',
          acceptedPassword: 'foo',
          handleToReturn: acceptedLogin),
      notesApi: const DummyNotesApi.empty(),
    ),
    act: (appBloc) => appBloc.add(
      const LoginAction(email: 'hone@baz.com', password: 'foo'),
    ),
    expect: () => [
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandle: null,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: LoginErrors.invalidHandle,
        loginHandle: null,
        fetchedNotes: null,
      )
    ],
  );
  blocTest<AppBloc, AppState>(
    'Load Notes with correct credentials',
    build: () => AppBloc(
      acceptedLogin: acceptedLogin,
      loginApi: const DummyLoginApi(
          acceptedEmail: 'foo@bar.com',
          acceptedPassword: 'foobar',
          handleToReturn: acceptedLogin),
      notesApi: const DummyNotesApi(
        notesToReturn: mockNotes,
        acceptedLogin: acceptedLogin,
      ),
    ),
    act: (appBloc) {
      appBloc.add(
        const LoginAction(email: 'foo@bar.com', password: 'foobar'),
      );
      appBloc.add(const LoadNoteActions());
    },
    expect: () => [
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandle: null,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: null,
        loginHandle: acceptedLogin,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: true,
        loginError: null,
        loginHandle: acceptedLogin,
        fetchedNotes: null,
      ),
      const AppState(
        isLoading: false,
        loginError: null,
        loginHandle: acceptedLogin,
        fetchedNotes: mockNotes,
      ),
    ],
  );
}
