import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../widgets/chatrooms/add_chatroom.dart';

class AddChatScreen extends StatefulWidget {
  static const routeName = '/add-chat';

  @override
  State<AddChatScreen> createState() => _AddChatScreenState();
}

class _AddChatScreenState extends State<AddChatScreen> {
  bool _isLoading = false;

  void addChatFn(
    String roomName,
    List<String> rolesAllowed,
    File image,
  ) {
    try {
      setState(() {
        _isLoading = true;
      });
      final ref = FirebaseStorage.instance
          .ref()
          .child('user_image')
          .child(roomName + '.jpg');

      rolesAllowed.add('Core');

      UploadTask uploadTask = ref.putFile(image);

      uploadTask.whenComplete(() async {
        final url = await ref.getDownloadURL();
        await FirebaseFirestore.instance.collection('chatroom').add({
          'roomName': roomName,
          'rolesAllowed': rolesAllowed,
          'roomPic': url,
          'lastActivity': DateTime.now(),
          'lastMsg': '',
        });
      });
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Chat'),
      ),
      body: AddChatroom(addChatFn, _isLoading),
    );
  }
}
