import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatImagePicker extends StatefulWidget {
  final String roomId;

  ChatImagePicker(this.roomId);

  @override
  _ChatImagePickerState createState() => _ChatImagePickerState();
}

class _ChatImagePickerState extends State<ChatImagePicker> {
  String _uploadFileResult = '';
  String _getUrlResult = '';

  void _sendImage() async {
    final user = await FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();
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
      'imageMsg': _getUrlResult,
      'videoMsg': '',
      'audioMsg': '',
    });
    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(widget.roomId)
        .update({
      'lastActivity': DateTime.now(),
      'lastMsg': '${userData['userName']}: 🖼️ Image'
    });
    setState(() {
      _getUrlResult = '';
    });
  }

  Future<void> _pickImage(ImageSource source, BuildContext ctx) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(
      source: source,
    );

    try {
      final UploadFileResult result = await Amplify.Storage.uploadFile(
          local: File(pickedImage!.path),
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
        _getUrlResult = resultURL.url.substring(0, resultURL.url.indexOf('?'));
      });
      print(_getUrlResult);
      setState(() {
        if (pickedImage != null) {
          print('image picked');
        } else {
          print('No image selected.');
        }
      });
      // widget.pickImgUrl(_chatImgUrl);
      Navigator.pop(ctx);
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Send Image?'),
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
                  _sendImage();
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

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (BuildContext ctx) {
              return Container(
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text('Camera'),
                      onTap: () {
                        _pickImage(ImageSource.camera, context);
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.image),
                      title: Text('Gallery'),
                      onTap: () {
                        _pickImage(ImageSource.gallery, context);
                      },
                    ),
                  ],
                ),
              );
            });
      },
      icon: Icon(
        Icons.image,
        color: Colors.grey,
      ),
    );
  }
}
