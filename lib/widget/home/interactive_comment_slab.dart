import 'package:ashera_pet_new/model/post_message.dart';
import 'package:ashera_pet_new/routes/route_name.dart';
import 'package:ashera_pet_new/utils/utils.dart';
import 'package:ashera_pet_new/view_model/post.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/member.dart';
import '../../model/post.dart';
import '../../utils/app_color.dart';
import '../time_line/app_widget/avatars.dart';

///其他人的留言
class InteractiveCommentSlab extends StatefulWidget {
  final PostModel postCardData;

  const InteractiveCommentSlab({super.key, required this.postCardData});

  @override
  State<StatefulWidget> createState() => _InteractiveCommentSlabState();
}

class _InteractiveCommentSlabState extends State<InteractiveCommentSlab> {
  PostModel get postCardData => widget.postCardData;

  @override
  Widget build(BuildContext context) {
    const spacePadding = EdgeInsets.only(left: 16.0, top: 4);
    return Consumer<PostVm>(
      builder: (context, vm, _) {
        List<PostMessageModel> list = vm.postDataMessage
            .where((element) => element.postId == postCardData.id)
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /*if(list.length > 0 && list.isNotEmpty)
            Padding(
              padding: spacePadding,
              child: Text.rich(
                  TextSpan(
                      children: [
                        TextSpan(
                            text: list[0].member!.nickname,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColor.textFieldTitle
                            )
                        ),
                        const TextSpan(text: '  '),
                        TextSpan(
                            text: list[0].message,
                            style: const TextStyle(
                                color: AppColor.textFieldHintText
                            )
                        ),
                      ]
                  )
              ),
            ),
          if(list.length > 1 && list.isNotEmpty)
            Padding(
              padding: spacePadding,
              child: Text.rich(
                TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                        text: list[1].member.nickname,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            color: AppColor.textFieldTitle
                        )),
                    const TextSpan(text: '  '),
                    TextSpan(
                        text: list[1].message,
                        style: const TextStyle(
                            color: AppColor.textFieldHintText
                        )
                    ),
                  ],
                ),
              ),
            ),
          if (list.length > 2)*/
            Padding(
              padding: spacePadding,
              child: GestureDetector(
                onTap: () => _pushComments(),
                child: Text(
                  '查看全部 ${list.length} 則',
                  style: const TextStyle(
                      color: AppColor.textFieldHintText,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 3, right: 8),
              child: Row(
                children: [
                  const _ProfilePicture(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => _pushComments(),
                        child: const Text(
                          '新增留言...',
                          style: TextStyle(
                            color: AppColor.textFieldHintText,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  /*GestureDetector(
                onTap: () => _pushComments(),
                child: const Padding(
                  padding: textPadding,
                  child: Text('❤️'),
                ),
              ),
              GestureDetector(
                onTap: () => _pushComments(),
                child: const Padding(
                  padding: textPadding,
                  child: Text('🙌'),
                ),
              ),*/
                ],
              ),
            ),
            //發文時間
            Padding(
              padding: const EdgeInsets.only(left: 16.0, top: 4),
              child: Text(
                Utils.getPostTime(postCardData.createdAt),
                style: const TextStyle(
                  color: AppColor.textFieldHintText,
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _pushComments() {
    context.push(RouteName.comments, extra: widget.postCardData);
  }
}

class _ProfilePicture extends StatelessWidget {
  const _ProfilePicture();

  @override
  Widget build(BuildContext context) {
    var streamagramUser = Member.memberModel;
    if (streamagramUser.mugshot.isEmpty) {
      return const Icon(Icons.error);
    }
    return Avatar.small(
      user: streamagramUser,
    );
  }
}
