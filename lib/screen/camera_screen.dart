import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class ImgPreview extends StatefulWidget {
  ImgPreview(this.file, {super.key});
  XFile file;

  @override
  State<ImgPreview> createState() => _ImgPreviewState();
}

class _ImgPreviewState extends State<ImgPreview> {
  @override
  Widget build(BuildContext context) {
    File pic = File(widget.file.path);
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo preview'),
      ),
      body: Center(
        child: Image.file(pic)
      ),
    );
  }
}