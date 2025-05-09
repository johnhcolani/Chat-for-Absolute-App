import 'package:chat_for_absolute_app/models/Message.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';

import '../repositories/message_repository.dart';

class MessageProvider with ChangeNotifier {
  final _messageRepository = MessageRepository();
  Future<Either<String, Message?>> sendMessage(Message message){
    return _messageRepository.sendMessage(message);
  }
}
