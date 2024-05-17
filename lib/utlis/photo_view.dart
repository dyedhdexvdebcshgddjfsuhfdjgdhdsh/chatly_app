import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class PhotoViewScreen extends StatefulWidget {
  const PhotoViewScreen({super.key, required this.img});

  final String img;
  @override
  State<PhotoViewScreen> createState() => _PhotoViewScreenState();
}

class _PhotoViewScreenState extends State<PhotoViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Container(
        child:PhotoView(
          imageProvider: NetworkImage(widget.img),
        ),
      ),
    );
  }
}
