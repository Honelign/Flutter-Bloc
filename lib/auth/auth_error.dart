import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

Map<String, AuthError> authErrorMapping = {
  'user-not-found': AuthErrorUserNotFound(),
  'weak-password': AuthErrorWeakPassword(),
  'invalid-email': AuthErrorInvalidEmail(),
  'operation-not-allowed': AuthErrorOperationNotAllowed(),
  'email-already-in-use': AuthErrorEmailAlreadyInUse(),
  'requires-recent-login': AuthErrorRequiresRecentLogin(),
  'no-current-user': AuthErrorNoCurrentUser(),
};

abstract class AuthError {
  final String dialogTitle;
  final String dialogText;

  AuthError({
    required this.dialogTitle,
    required this.dialogText,
  });

  factory AuthError.from(FirebaseAuthException exception) {
    return authErrorMapping[exception.code.toLowerCase().trim()] ??
        AuthErrorUnknown();
  }
}

@immutable
class AuthErrorUnknown extends AuthError {
  AuthErrorUnknown()
      : super(
            dialogTitle: 'Authentication Error',
            dialogText: 'An unknown error has occurred.');
}

@immutable
class AuthErrorNoCurrentUser extends AuthError {
  AuthErrorNoCurrentUser()
      : super(
            dialogTitle: 'No current user',
            dialogText: 'No current user with this information');
}

// requires-recent-login
@immutable
class AuthErrorRequiresRecentLogin extends AuthError {
  AuthErrorRequiresRecentLogin()
      : super(
            dialogTitle: 'Requires recent login',
            dialogText: 'You need to login again to perform this action');
}

//operation-not-allowed
@immutable
class AuthErrorOperationNotAllowed extends AuthError {
  AuthErrorOperationNotAllowed()
      : super(
            dialogTitle: 'Operation not allowed',
            dialogText: 'You cannot register with this method at this method');
}

// auth/user-not-found
@immutable
class AuthErrorUserNotFound extends AuthError {
  AuthErrorUserNotFound()
      : super(
            dialogTitle: 'User not found',
            dialogText: 'The given user does not exist');
}

// auth/weak-password
@immutable
class AuthErrorWeakPassword extends AuthError {
  AuthErrorWeakPassword()
      : super(
            dialogTitle: 'Weak Password',
            dialogText:
                'The given password is weak please try using strong password again');
}

//auth/invalid-email
@immutable
class AuthErrorInvalidEmail extends AuthError {
  AuthErrorInvalidEmail()
      : super(
            dialogTitle: 'Invalid Email',
            dialogText:
                'The given email is invalid please try using valid email again');
}

//email-already-in-use
@immutable
class AuthErrorEmailAlreadyInUse extends AuthError {
  AuthErrorEmailAlreadyInUse()
      : super(
            dialogTitle: 'Email already in use',
            dialogText:
                'The given email is already in use please try using another email');
}
