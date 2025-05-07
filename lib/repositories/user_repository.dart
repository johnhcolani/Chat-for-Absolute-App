import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dartz/dartz.dart';

class UserRepository {
  Future <Either<String, SignUpResult>> signUp(
      String username, String email, String password) async{
    final Map<AuthUserAttributeKey, String> userAttribute={
      AuthUserAttributeKey.email: email
    };
    try{
      final result = await Amplify.Auth.signUp(
          username: username,
          password: password,
          options: SignUpOptions(userAttributes: userAttribute),
      );
      return right(result);
    }on AuthException catch (e){
      return left(e.message);
    }
  }
Future<Either<String, bool>> ConfirmSignUp(
    {required String username, required String code})async{
    try{
      final result= await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: code,
      );
      return right(result.isSignUpComplete);
    }on AuthException catch (e){
      return left(e.message);
    }
}
}
