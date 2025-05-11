import 'dart:async';

import 'package:amplify_api/amplify_api.dart';
import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';

import '../models/Message.dart';
import '../repositories/message_repository.dart';

class MessageProvider with ChangeNotifier {
  final _messageRepository = MessageRepository();

  bool _isLoading = false;
  List<Message> _messages = [];
  String? _errorMessage;

  StreamSubscription<GraphQLResponse<Message>>? _messageSubscription;

  bool get isLoading => _isLoading;
  List<Message> get messages => _messages;
  String? get errorMessage => _errorMessage;

  void _setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  /// Send a message and add it to UI immediately
  Future<Either<String, Message?>> sendMessage(Message message) async {
    final result = await _messageRepository.sendMessage(message);

    result.fold(
          (error) => print("❌ Send error: $error"),
          (sentMessage) {
        if (sentMessage != null) {
          print("🟢 Adding message to UI immediately: ${sentMessage.message}");
         // addMessage(sentMessage);
        }
      },
    );

    return result;
  }

  /// Load the latest messages
  Future<void> getMessages() async {
    _setIsLoading(true);
    final response = await _messageRepository.getLatestMessages();
    response.fold(
          (error) {
        _errorMessage = error;
        print("❌ Failed to load messages: $error");
      },
          (loadedMessages) {
        _messages = loadedMessages;
        print("✅ Messages loaded: ${_messages.length}");
      },
    );
    _setIsLoading(false);
  }

  /// Subscribe to new messages in real time
  void startSubscription() {
    print("📡 Starting subscription to onCreateMessage...");
    _messageSubscription = _messageRepository
        .subscribeToMessages()
        .listen((response) {
      if (response.data != null) {
        print("📥 Subscription received: ${response.data!.message}");
        addMessage(response.data!);
      } else if (response.hasErrors) {
        print("❌ Subscription error: ${response.errors.first.message}");
      }
    });
  }

  /// Cancel the subscription when no longer needed
  void disposeSubscription() {
    _messageSubscription?.cancel();
  }

  /// Add a message to the list and update UI
  void addMessage(Message message) {
    print("📝 Inserting message: ${message.message}");
    _messages.insert(0, message); // Most recent first
    notifyListeners();
  }
}
