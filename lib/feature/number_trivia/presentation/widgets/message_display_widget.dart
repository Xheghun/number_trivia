import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String message;
  final double height;
  const MessageDisplay({Key key, this.height, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: height,
      child: SingleChildScrollView(
        child: Text("Start Searching",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
      ),
    );
  }
}
