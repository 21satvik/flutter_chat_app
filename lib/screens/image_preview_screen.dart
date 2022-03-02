import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImagePreviewScreen extends StatelessWidget {
  static const routeName = '/imagepreview';

  @override
  Widget build(BuildContext context) {
    String url = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Image Preview',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: PhotoView(
        imageProvider: NetworkImage(url),
        minScale: PhotoViewComputedScale.contained * 1,
        maxScale: PhotoViewComputedScale.covered * 2.0,
      ),
    );
  }
}
