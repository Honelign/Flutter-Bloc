import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

import 'package:testingbloc_course/auth/auth_error.dart';

@immutable
abstract class AppState {
  final bool isLoading;
  final AuthError? authError;

  const AppState({required this.isLoading, this.authError});
}

@immutable
class AppStateLoggedIn extends AppState {
  final User user;
  final Iterable<Reference> images;

  const AppStateLoggedIn({
    required bool isLoading,
    AuthError? authError,
    required this.user,
    required this.images,
  }) : super(isLoading: isLoading, authError: authError);

  @override
  bool operator ==(other) {
    final otherClass = other;
    if (otherClass is AppStateLoggedIn) {
      return user.uid == otherClass.user.uid &&
          images == otherClass.images &&
          isLoading == otherClass.isLoading;
    } else {
      return false;
    }
  }

  @override
  // TODO: implement hashCode
  int get hashCode => Object.hash(user.uid, images);
  @override
  String toString() {
    // TODO: implement toString
    return 'AppStateLoggedIn{user: $user, images: $images, isLoading: $isLoading}';
  }
}

@immutable
class AppStateLoggedOut extends AppState {
  const AppStateLoggedOut({
    required bool isLoading,
    AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );
  @override
  String toString() {
    // TODO: implement toString
    return 'AppStateLoggedOut{isLoading: $isLoading, authError: $authError}';
  }
}

@immutable
class AppStateInRegistrationView extends AppState {
  const AppStateInRegistrationView({
    required bool isLoading,
     AuthError? authError,
  }) : super(
          isLoading: isLoading,
          authError: authError,
        );
}

extension GetUser on AppState {
  User? get user {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.user;
    } else {
      return null;
    }
  }
}

extension GetImages on AppState {
  Iterable<Reference>? get images {
    final cls = this;
    if (cls is AppStateLoggedIn) {
      return cls.images;
    } else {
      return null;
    }
  }
}
