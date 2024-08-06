import 'package:ashera_pet_new/view_model/comments_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/post.dart';
import '../../../model/post_message.dart';
import '../../../utils/app_color.dart';

class BoxReply extends StatelessWidget {
  final PostModel cardData;
  const BoxReply({super.key, required this.cardData});

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentsVm>(
      builder: (context, vm, _) {
        return Visibility(
            visible: vm.parentId != null,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '回覆: ${_getChildMessage(vm.parentId, vm)}',
                    style: const TextStyle(color: AppColor.textFieldHintText),
                  ),
                  GestureDetector(
                    onTap: () => vm.setParentId(null),
                    child: const Icon(
                      Icons.clear,
                      color: AppColor.textFieldTitle,
                    ),
                  )
                ],
              ),
            ));
      },
    );
  }

  String _getChildMessage(int? id, CommentsVm vm) {
    if (id != null) {
      List<PostMessageModel> comment =
          vm.postDataMessage.where((element) => element.id == id).toList();
      if (comment.isNotEmpty) {
        return comment.first.message;
      }
    }
    return '';
  }
}
