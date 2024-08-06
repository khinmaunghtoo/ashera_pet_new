import 'package:ashera_pet_new/view_model/comments_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../model/post_message.dart';
import '../../../utils/app_color.dart';

class ItemReplyAndLiked extends StatelessWidget {
  final bool canReply;
  final PostMessageModel parent;
  final int numberOfLikes;

  const ItemReplyAndLiked(
      {super.key,
      required this.canReply,
      required this.parent,
      required this.numberOfLikes});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Visibility(
              visible: canReply,
              child: Consumer<CommentsVm>(
                builder: (context, vm, _) {
                  return GestureDetector(
                    onTap: () => vm.setParentId(parent.id),
                    child: const SizedBox(
                      width: 40,
                      child: Text(
                        '回覆',
                        style: TextStyle(
                            color: AppColor.textFieldHintText, fontSize: 12),
                      ),
                    ),
                  );
                },
              )),
          Visibility(
              visible: numberOfLikes > 0,
              child: SizedBox(
                width: 50,
                child: Text(
                  '$numberOfLikes人喜歡',
                  style: const TextStyle(
                      color: AppColor.textFieldTitle, fontSize: 12),
                ),
              )),
        ],
      ),
    );
  }
}
