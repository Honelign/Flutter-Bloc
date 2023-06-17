import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:testingbloc_course/apis/login_api.dart';
import 'package:testingbloc_course/bloc/actions.dart';
import 'package:testingbloc_course/bloc/app_bloc.dart';
import 'package:testingbloc_course/dialog/generic_dialog.dart';
import 'package:testingbloc_course/dialog/loading_screen.dart';
import 'package:testingbloc_course/models.dart';
import 'package:testingbloc_course/strings.dart';
import 'package:testingbloc_course/view/iterable_listview.dart';
import 'package:testingbloc_course/view/screen/login_view.dart';

import 'apis/notes_api.dart';
import 'bloc/app_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => AppBloc(
              loginApi: LoginApi(),
              notesApi: NoteApi(),
            ),
        child: Scaffold(
          body: BlocConsumer<AppBloc, AppState>(
            listener: (context, appState) {
              if (appState.isLoading) {
                LoadingScreen.instance()
                    .show(context: context, text: pleaseWait);
              } else {
                LoadingScreen.instance().hide();
              }
              if (appState.loginError != null) {
                showGenericDialog(
                  context: context,
                  title: loginErrorDialogTitle,
                  content: loginErrorDialogContent,
                  optionsBuilder: () => {ok: true},
                );
              }
              if (appState.isLoading == false &&
                  appState.loginError == null &&
                  appState.loginHandle == const LoginHandle.fooBar() &&
                  appState.fetchedNotes == null) {
                context.read<AppBloc>().add(
                      const LoadNoteActions(),
                    );
              }
            },
            builder: (context, appState) {
              final notes = appState.fetchedNotes;
              if (notes == null) {
                return LoginView(
                  onLoginTapped: (email, password) {
                    context
                        .read<AppBloc>()
                        .add(LoginAction(email: email, password: password));
                  },
                );
              } else {
                return notes.toListView();
              }
            },
          ),
        ));
  }
}
