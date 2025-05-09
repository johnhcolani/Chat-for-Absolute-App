import 'package:amplify_api/amplify_api.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:dartz/dartz.dart';

import '../models/Message.dart';

class MessageRepository {
  Future<Either<String, Message?>> sendMessage(Message message)async{
    try{
      final request = ModelMutations.create(message);
      final response = await Amplify.API.mutate(request: request).response;
      return right(response.data);
    } on ApiException catch(e){
      return left(e.message);
    }
  }
}
