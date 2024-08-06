import 'package:flutter/cupertino.dart';

class ChatTextWidget extends StatelessWidget{
  final String content;
  const ChatTextWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(content);
  }
}