import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
  final _userRepository = UserRepository();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  AuthUser? _currentUser;
  AuthUser? get currentUser => _currentUser;
  String? get currentUserId => _currentUser?.userId;

  void _setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Sign up a new user
  Future<Either<String, SignUpResult>> signUp(
      String username, String email, String password) async {
    _setIsLoading(true);
    final response = await _userRepository.signUp(username, email, password);
    _setIsLoading(false);
    return response;
  }

  /// Confirm sign-up with verification code
  Future<Either<String, bool>> confirmSignUp({
    required String username,
    required String code,
  }) async {
    _setIsLoading(true);
    final response =
    await _userRepository.ConfirmSignUp(username: username, code: code);
    if (response.isRight()) {
      _currentUser = await _userRepository.getCurrentUser();
    }
    _setIsLoading(false);
    return response;
  }

  /// Sign in and load current user info
  Future<Either<String, SignInResult>> signIn({
    required String username,
    required String password,
  }) async {
    _setIsLoading(true);
    final response = await _userRepository.signIn(
      username: username,
      password: password,
    );
    if (response.isRight()) {
      _currentUser = await _userRepository.getCurrentUser();
    }
    _setIsLoading(false);
    return response;
  }

  /// Sign out the current user
  Future<Either<String, SignOutResult>> signOut() async {
    _setIsLoading(true);
    final response = await _userRepository.signOut();
    _currentUser = null;
    _setIsLoading(false);
    return response;
  }

  /// Used at app launch to check if a user is already logged in
  Future<AuthUser?> checkedLoggedInUser() async {
    final authSession = await _userRepository.isUserLoggedIn();
    if (authSession.isSignedIn) {
      _currentUser = await _userRepository.getCurrentUser();
      notifyListeners();
      return _currentUser;
    }
    return null;
  }
}
