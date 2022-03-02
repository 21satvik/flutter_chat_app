import 'package:chat_app/screens/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RoomTile extends StatelessWidget {
  final String roomName;
  final String roomPic;
  final String lastMsg;
  final Timestamp lastActivity;
  final String roomId;

  RoomTile(
    this.roomName,
    this.roomPic,
    this.lastMsg,
    this.lastActivity,
    this.roomId,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(roomName),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(roomPic),
        ),
        subtitle: Text(lastMsg),
        trailing: Text(
          DateFormat('hh:mm a').format(lastActivity.toDate()).toLowerCase(),
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(ChatScreen.routeName,
              arguments: {'roomId': roomId, 'roomName': roomName});
        },
      ),
    );
  }
}
