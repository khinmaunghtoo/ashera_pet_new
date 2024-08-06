import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/widget/time_line/app_widget/avatars.dart';

import 'package:flutter/material.dart';

import '../../../data/member.dart';
import '../../../model/post.dart';
import '../../text_field.dart';
import 'box_done.dart';
import 'box_emoji.dart';
import 'box_reply.dart';

class CommentBox extends StatefulWidget {
  final PostModel postCardData;
  const CommentBox({super.key, required this.postCardData});

  @override
  State<StatefulWidget> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  FocusNode focusNodeComments = FocusNode();
  final TextEditingController _comment = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: const BoxDecoration(color: AppColor.textFieldUnSelect),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _box(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget _box() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        BoxReply(
          cardData: widget.postCardData,
        ),
        BoxEmoji(
          comment: _comment,
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Avatar.medium(user: Member.memberModel),
            ),
            Expanded(
                child: CommentsTextField(
              focusNode: focusNodeComments,
              controller: _comment,
            )),
            BoxDone(
              comment: _comment,
              cardData: widget.postCardData,
            )
          ],
        )
      ],
    );
  }
}
