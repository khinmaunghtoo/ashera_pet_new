import 'package:flutter/cupertino.dart';

import '../../../model/post_message.dart';
import '../msg.dart';

class ItemChild extends StatelessWidget{
  final List<PostMessageModel>? msg;
  const ItemChild({
    super.key,
    required this.msg
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 34.0),
      child: CommentMsgList(
        comments: msg,
      ),
    );
  }
}