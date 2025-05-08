import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
  final _userRepository = UserRepository();
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  AuthUser? _currentUser; // ✅ Add this
  AuthUser? get currentUser => _currentUser;

  void _setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<Either<String, SignUpResult>> signUp(String username, String email,
      String password) async {
    _setIsLoading(true);
    final response = await _userRepository.signUp(username, email, password);
    _setIsLoading(false);
    return response;
  }

  Future<Either<String, bool>> confirmSignUp(
      {required String username, required String code}) async {
    _setIsLoading(true);
    final response = await _userRepository.ConfirmSignUp(
        username: username,
        code: code
    );
    _setIsLoading(false);
    return response;
  }

  Future<Either<String, SignInResult>> signIn(
      {required String username, required String password}) async {
    _setIsLoading(true);
    final response = await _userRepository.signIn(
      username: username,
      password: password,
    );
    _setIsLoading(false);
    return response;
  }


  Future<Either<String, SignOutResult>> signOut() async {
    _setIsLoading(true);
    final response = await _userRepository.signOut();
    _setIsLoading(false);
    return response;
  }

  Future<AuthUser?> checkedLoggedInUser() async {
    final authSession = await _userRepository.isUserLoggedIn();
    if (authSession.isSignedIn) {
      _currentUser = await _userRepository.getCurrentUser();
      return _currentUser;
    }
    return null;
  }

}
