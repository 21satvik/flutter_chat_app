import 'dart:io';

import 'package:flutter/material.dart';

import '../pickers/multi_select.dart';
import '../pickers/user_image_picker.dart';

class AddChatroom extends StatefulWidget {
  AddChatroom(this.submitFn, this.isLoading);

  final bool isLoading;

  final void Function(
    String roomName,
    List<String> selectedUsers,
    File image,
  ) submitFn;

  @override
  State<AddChatroom> createState() => _AddChatroomState();
}

class _AddChatroomState extends State<AddChatroom> {
  final _formKey = GlobalKey<FormState>();
  List<String> _allowedRoles = [];
  String _roomName = '';

  File _roomimageFile = File('');

  void _pickedImage(File image) {
    _roomimageFile = image;
  }

  void _trySubmit() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (_roomimageFile == File('')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    setState(() {});
    if (isValid) {
      _formKey.currentState!.save();
      widget.submitFn(
        _roomName.trim(),
        _allowedRoles,
        _roomimageFile,
      );
    }
    Navigator.of(context).pop();
  }

  void _showMultiSelect() async {
    List<String> _allRoles = [
      'Technical Lead',
      'Technical Member',
      'Editorial Lead',
      'Editorial Member',
      'Sponsorship Lead',
      'Sponsorship Member',
      'Events Lead',
      'Events Member',
      'Growth Lead',
      'Growth Member',
    ];

    final List<String>? results = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelect(items: _allRoles);
      },
    );

    if (results != null) {
      setState(() {
        _allowedRoles = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                UserImagePicker(_pickedImage),
                TextFormField(
                  autocorrect: false,
                  textCapitalization: TextCapitalization.sentences,
                  enableSuggestions: false,
                  validator: (value) {
                    if (value!.isEmpty || value.length < 4) {
                      return 'Please enter atleast four characters';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                      hintText: 'Room name',
                      contentPadding: EdgeInsets.only(left: 15)),
                  onSaved: (value) {
                    _roomName = value!;
                  },
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.white, onPrimary: Colors.black),
                    child: const Text('Select Roles'),
                    onPressed: _showMultiSelect,
                  ),
                ),
                const Divider(
                  height: 30,
                ),
                // display selected items
                Wrap(
                  children: _allowedRoles
                      .map((e) => Chip(
                            label: Text(e),
                          ))
                      .toList(),
                ),
                SizedBox(height: 12),
                if (widget.isLoading) CircularProgressIndicator(),
                if (!widget.isLoading)
                  ElevatedButton(
                    onPressed: _trySubmit,
                    child: Text('Add Chatroom'),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
