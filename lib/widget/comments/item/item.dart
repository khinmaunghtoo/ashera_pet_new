import 'package:ashera_pet_new/model/post_message.dart';
import 'package:ashera_pet_new/routes/route_name.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../model/member.dart';
import '../../../view_model/post.dart';
import '../../time_line/app_widget/avatars.dart';
import 'item_child.dart';
import 'item_reply_and_liked.dart';

class CommentTile extends StatefulWidget {
  final PostMessageModel model;
  final bool canReply;
  final bool isReplyToComment;

  const CommentTile(
      {super.key,
      required this.model,
      this.canReply = true,
      this.isReplyToComment = false});

  @override
  State<StatefulWidget> createState() => _CommentTileState();
}

class _CommentTileState extends State<CommentTile> {
  late final userData = widget.model.member;
  late final message = widget.model.message;

  @override
  Widget build(BuildContext context) {
    return Consumer<PostVm>(
      builder: (context, vm, _) {
        List<PostMessageModel> list = vm.postDataMessage
            .where((element) =>
                element.postId == widget.model.postId &&
                element.postMessageId == widget.model.id)
            .toList();
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: (widget.isReplyToComment)
                      ? Avatar.tiny(
                          user: MemberModel.fromMap(userData!.toMap()),
                          callback: () => context.push(RouteName.searchPet,
                              extra: userData!),
                        )
                      : Avatar.small(
                          user: MemberModel.fromMap(userData!.toMap()),
                          callback: () => context.push(RouteName.searchPet,
                              extra: userData!),
                        ),
                ),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(child: _userName()),
                        //愛心
                        /*Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Consumer<PostVm>(builder: (context, vm, _){
                              return Center(
                                child: FavoriteIconButton(
                                  isLiked: vm.postDataMessageLike.where((element) => element.postId == widget.model.postId && element.postMessageId == widget.model.id).isNotEmpty,
                                  size: 14,
                                  onTap: (value) {
                                    if(value){
                                      vm.addPostMessageLike(widget.model);
                                    }else{
                                      vm.removePostMessageLike(vm.postDataMessageLike.where((element) => element.postId == widget.model.postId && element.postMessageId == widget.model.id).first.id);
                                    }
                                  },
                                ),
                              );
                            },),
                          )*/
                      ],
                    ),
                    //文章
                    Text(
                      message,
                      style: const TextStyle(
                          color: AppColor.textFieldHintText, fontSize: 16),
                    ),
                    //回覆與喜歡
                    Consumer<PostVm>(
                      builder: (context, vm, _) {
                        return ItemReplyAndLiked(
                          canReply: widget.canReply,
                          parent: widget.model,
                          numberOfLikes: vm.postDataMessageLike
                              .where((element) =>
                                  element.postId == widget.model.postId &&
                                  element.postMessageId == widget.model.id)
                              .length,
                        );
                      },
                    )
                  ],
                ))
              ],
            ),
            //child Message
            ItemChild(msg: list)
          ],
        );
      },
    );
  }

  Widget _userName() {
    return GestureDetector(
      onTap: () => context.push(RouteName.searchPet, extra: userData),
      child: Text.rich(
        TextSpan(children: [
          TextSpan(
            text: userData!.nickname,
            style: const TextStyle(
              color: AppColor.textFieldTitle,
              fontSize: 16,
            ),
          ),
          const TextSpan(text: ' '),
          TextSpan(
              text: Utils.getPostTime(widget.model.createdAt),
              style: const TextStyle(
                  color: AppColor.textFieldHintText, fontSize: 10))
        ]),
      ),
    );
  }
}
