import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:chat_app/widgets/extra/sound_recorder.dart';
import 'package:chat_app/widgets/pickers/chat_video_picker.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../pickers/chat_image_picker.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
  final String roomId;

  NewMessage(this.roomId);
}

class _NewMessageState extends State<NewMessage> {
  final _controller = new TextEditingController();
  String _enteredMessage = '';
  String _audioUrl = '';
  String _uploadFileResult = '';
  bool _isRecording = false;
  final recorder = new SoundRecorder();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    recorder.init();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    recorder.dispose();
  }

  void _showToast() {
    Fluttertoast.showToast(
      msg: 'Hold to record.',
      fontSize: 18,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _record() async {
    recorder.record();

    Fluttertoast.showToast(
      msg: 'recording.',
      fontSize: 18,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _sendAudio() async {
    final user = await FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (!_audioUrl.isEmpty)
      FirebaseFirestore.instance
          .collection('chatroom')
          .doc(widget.roomId)
          .collection('chat')
          .add({
        'textMsg': '',
        'createdAt': DateTime.now(),
        'userId': user.uid,
        'userName': userData['userName'],
        'userPic': userData['url'],
        'imageMsg': '',
        'videoMsg': '',
        'audioMsg': _audioUrl,
      });
    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(widget.roomId)
        .update({
      'lastActivity': DateTime.now(),
      'lastMsg': '${userData['userName']}: 🎧 Audio'
    });
    _controller.clear();
    setState(() {
      _audioUrl = '';
    });
  }

  Future<void> _pickAudio(BuildContext ctx) async {
    recorder.stop();
    setState(() {
      _isRecording = false;
    });
    try {
      final UploadFileResult result = await Amplify.Storage.uploadFile(
          local: File(recorder.filePath),
          key: DateTime.now().toString(),
          onProgress: (progress) {
            print("Fraction completed: " +
                progress.getFractionCompleted().toString());
          });
      setState(() {
        _uploadFileResult = result.key;
      });

      String key = _uploadFileResult;
      GetUrlResult resultURL = await Amplify.Storage.getUrl(key: key);

      setState(() {
        _audioUrl = resultURL.url.substring(0, resultURL.url.indexOf('?'));
      });
      print(_audioUrl);
      setState(() {
        if (recorder.filePath.isNotEmpty) {
          print('Audio picked');
          print(recorder.filePath);
        } else {
          print('No Video selected.');
        }
      });
      // widget.pickImgUrl(_chatImgUrl);
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Send Audio?'),
          content: Text('Choose between yes or no.'),
          actions: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: TextButton(
                onPressed: () {
                  _sendAudio();
                  Navigator.of(context).pop();
                },
                child: Text('Yes'),
              ),
            ),
          ],
        ),
      );
    } catch (error) {
      setState(() {
        print(error);
        throw Exception();
      });
    }
  }

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
    if (!_enteredMessage.isEmpty)
      FirebaseFirestore.instance
          .collection('chatroom')
          .doc(widget.roomId)
          .collection('chat')
          .add({
        'textMsg': _enteredMessage.trim(),
        'createdAt': DateTime.now(),
        'userId': user.uid,
        'userName': userData['userName'],
        'userPic': userData['url'],
        'imageMsg': '',
        'videoMsg': '',
        'audioMsg': '',
      });
    _controller.clear();
    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(widget.roomId)
        .update({
      'lastActivity': DateTime.now(),
      'lastMsg': '${userData['userName']}: ${_enteredMessage.trim()}',
    });
    setState(() {
      _enteredMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(
        children: [
          ChatImagePicker(widget.roomId),
          ChatVideoPicker(widget.roomId),
          Expanded(
            child: TextField(
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              minLines: 1,
              controller: _controller,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: InputDecoration(hintText: 'Send a message...'),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          GestureDetector(
            onLongPress: _enteredMessage.trim().isEmpty ? _record : null,
            onLongPressUp: _enteredMessage.trim().isEmpty
                ? () {
                    _pickAudio(context);
                  }
                : null,
            child: IconButton(
              color: Colors.grey,
              onPressed:
                  _enteredMessage.trim().isEmpty ? _showToast : _sendMessage,
              icon: _enteredMessage.trim().isEmpty
                  ? Icon(Icons.mic_outlined)
                  : Icon(Icons.send),
            ),
          )
        ],
      ),
    );
  }
}
