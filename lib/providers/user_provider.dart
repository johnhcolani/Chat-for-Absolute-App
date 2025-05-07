import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../repositories/user_repository.dart';

class UserProvider with ChangeNotifier {
  final _userRepository = UserRepository();
  bool _isLoading = false;
  bool get isLoading =>_isLoading;
  void _setIsLoading(bool value){
    _isLoading = value;
    notifyListeners();
  }
  Future<Either<String, SignUpResult>> signUp (
      String username, String email , String password)async{
    _setIsLoading(true);
    final response = await _userRepository.signUp(username, email, password);
    _setIsLoading(false);
    return response;
  }

}
