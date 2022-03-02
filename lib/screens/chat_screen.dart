import 'package:flutter/material.dart';

import '../widgets/chat/messages.dart';
import '../widgets/chat/new_message.dart';

class ChatScreen extends StatefulWidget {
  @override
  State<ChatScreen> createState() => _ChatScreenState();
  static const routeName = '/chat';
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    final String roomId = arguments['roomId'];
    final String roomName = arguments['roomName'];

    return Scaffold(
      appBar: AppBar(
        title: Text(roomName),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Messages(roomId),
            ),
            NewMessage(roomId),
          ],
        ),
      ),
    );
  }
}
