import 'package:chat_for_absolute_app/models/Message.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'text_message.dart';

class MessageTile extends StatelessWidget {
  const MessageTile({
    Key? key,
    required this.message,
    this.isSender = false,
  }) : super(key: key);

  final Message message;
  final bool isSender;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: defaultPadding),
      child: Row(
        mainAxisAlignment:
            isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isSender) ...[
            CircleAvatar(
              radius: 12,
              backgroundColor: kPrimaryColor,
              child: Text(
                message.username[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: defaultPadding / 2),
          ],
          TextMessage(message: message.message, isSender: isSender),
        ],
      ),
    );
  }
}
