import 'package:chat_app/widgets/chatrooms/room_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatRooms extends StatefulWidget {
  @override
  State<ChatRooms> createState() => _ChatRoomsState();
}

class _ChatRoomsState extends State<ChatRooms> {
  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .snapshots(),
      builder: (ctx, AsyncSnapshot userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final userDocs = userSnapshot.data!.data();
        final userRole = userDocs['role'];
        print(userRole);
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('chatroom')
              .where('rolesAllowed', arrayContains: userRole)
              .orderBy('lastActivity', descending: true)
              .snapshots(),
          builder: (ctx, AsyncSnapshot<QuerySnapshot> chatSnapshot) {
            if (chatSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final chatDocs = chatSnapshot.data!.docs;
            return ListView.builder(
                itemCount: chatDocs.length,
                itemBuilder: (ctx, index) => RoomTile(
                      chatDocs[index]['roomName'],
                      chatDocs[index]['roomPic'],
                      chatDocs[index]['lastMsg'],
                      chatDocs[index]['lastActivity'],
                      chatDocs[index].id,
                    ));
          },
        );
      },
    );
  }
}
