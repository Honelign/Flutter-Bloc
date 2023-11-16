import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:testingbloc_course/bloc/app_event.dart';
import 'package:testingbloc_course/bloc/app_state.dart';
import 'package:testingbloc_course/utils/upload_image.dart';

import '../auth/auth_error.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc()
      : super(const AppStateLoggedOut(
          isLoading: false,
        )) {
    // handle go to login
    on<AppEventGoToLogin>(
      (event, emit) {
        emit(const AppStateLoggedOut(isLoading: false));
      },
    );

    //handle registration
    on<AppEventRegister>(
      (event, emit) async {
        emit(const AppStateInRegistrationView(
          isLoading: true,
        ));
        final email = event.email;
        final password = event.password;
        try {
          //creare the user
          final credentials =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: password,
          );
          // get user login
          emit(AppStateLoggedIn(
            isLoading: false,
            user: credentials.user!,
            images: const [],
          ));
        } on FirebaseAuthException catch (e) {
          emit(AppStateInRegistrationView(
            isLoading: false,
            authError: AuthError.from(e),
          ));
        }
      },
    );
    //handle account deletion
    on<AppEventDeleteAccount>(((event, emit) async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const AppStateLoggedOut(isLoading: false));
        return;
      }
      emit(AppStateLoggedIn(
          isLoading: true, user: user, images: state.images ?? []));
      try {
        // delete the user folder
        final folderContents =
            await FirebaseStorage.instance.ref(user.uid).listAll();
        for (final item in folderContents.items) {
          await item.delete().catchError((_) {}); // handle the error
        }
        await FirebaseStorage.instance
            .ref(user.uid)
            .delete()
            .catchError((_) {});
        // delete the user
        await user.delete();
        // log the user out
        await FirebaseAuth.instance.signOut();

        // log the user out
        emit(const AppStateLoggedOut(
          isLoading: false,
        ));
      } on FirebaseAuthException catch (e) {
        emit(AppStateLoggedIn(
            isLoading: false,
            user: user,
            images: state.images ?? [],
            authError: AuthError.from(e)));
      } on FirebaseException {
        // we might not be able to delete the folder but we can log the user out
        emit(const AppStateLoggedOut(isLoading: false));
      }
    }));

    // handle sign the user out
    on<AppEventLogOut>((event, emit) async {
      emit(const AppStateLoggedOut(isLoading: true));
      await FirebaseAuth.instance.signOut();

      // log the user out
      emit(const AppStateLoggedOut(
        isLoading: false,
      ));
    });

    //handle the in app initialization
    on<AppEventInitialize>((event, emit) async {
      // get the current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(const AppStateLoggedOut(
          isLoading: false,
        ));
      } else {
        // go grab the user images
        final images = await _getImages(user.uid);
        emit(AppStateLoggedIn(
          isLoading: false,
          user: user,
          images: images,
        ));
      }
    });

    //handle  upload image
    on<AppEventUploadImage>((event, emit) async {
      final user = state.user;
      // log user out if we don't have an actual user
      if (user == null) {
        emit(const AppStateLoggedOut(isLoading: false));
        return;
      }
      //start .loasinng process
      emit(AppStateLoggedIn(
          isLoading: true, user: user, images: state.images ?? []));
      // uploading an image
      final file = File(event.filePathToUpload);
      await uploadImage(
        file: file,
        userId: user.uid,
      );
      //after uploading is complete, grab the latest file reference
      final images = await _getImages(user.uid);
      //emits the new uploaded images
      emit(AppStateLoggedIn(isLoading: false, user: user, images: images));
    });
  }

  Future<Iterable<Reference>> _getImages(String userId) =>
      FirebaseStorage.instance
          .ref(userId)
          .list()
          .then((listResult) => listResult.items);
}
