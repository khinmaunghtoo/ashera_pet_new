import 'package:ashera_pet_new/widget/comments/item/item.dart';
import 'package:flutter/cupertino.dart';

import '../../model/post_message.dart';

class CommentMsgList extends StatelessWidget {
  final List<PostMessageModel>? comments;
  const CommentMsgList({super.key, required this.comments});
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: comments
              ?.map((e) => Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: CommentTile(
                      key: ValueKey('comment-tile-${e.id}'),
                      model: e,
                      canReply: false,
                      isReplyToComment: true,
                    ),
                  ))
              .toList() ??
          [],
    );
  }
}
