import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  final String roomId;

  Messages(this.roomId);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    print(roomId);
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('chatroom')
          .doc(roomId)
          .collection('chat')
          .orderBy(
            'createdAt',
            descending: true,
          )
          .snapshots(),
      builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
        if (chatSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final chatDocs = chatSnapshot.data!.docs;
        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) => MessageBubble(
            chatDocs[index]['textMsg'],
            chatDocs[index]['imageMsg'],
            chatDocs[index]['videoMsg'],
            chatDocs[index]['audioMsg'],
            chatDocs[index]['userName'],
            chatDocs[index]['userPic'],
            chatDocs[index]['userId'] == user!.uid,
            ValueKey(chatDocs[index].id), //key
          ),
        );
      },
    );
  }
}
