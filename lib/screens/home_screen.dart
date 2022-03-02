import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './add_chat_screen.dart';
import '../widgets/chatrooms/chat_rooms.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tether Chat'),
        actions: [
          DropdownButton(
            underline: Container(),
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text('Add chatroom'),
                    ],
                  ),
                ),
                value: 'add_chat',
              ),
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text('Log Out'),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
              if (itemIdentifier == 'add_chat') {
                Navigator.of(context).pushNamed(AddChatScreen.routeName);
              }
            },
          )
        ],
      ),
      body: ChatRooms(),
    );
  }
}
