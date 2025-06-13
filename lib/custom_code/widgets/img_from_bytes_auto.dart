// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';

class ImgFromBytesAuto extends StatefulWidget {
  const ImgFromBytesAuto({
    Key? key,
    this.width,
    this.height,
    this.base64String,
  }) : super(key: key);

  final double? width;
  final double? height;
  final String? base64String;

  @override
  _ImgFromBytesAutoState createState() => _ImgFromBytesAutoState();
}

class _ImgFromBytesAutoState extends State<ImgFromBytesAuto> {
  late Uint8List bytes;

  @override
  void initState() {
    super.initState();
    updateBytes();
  }

  @override
  void didUpdateWidget(ImgFromBytesAuto oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.base64String != oldWidget.base64String) {
      updateBytes();
    }
  }

  void updateBytes() {
    bytes = base64Decode(widget.base64String ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Image.memory(bytes, fit: BoxFit.cover),
      ),
    );
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
