import 'package:ashera_pet_new/routes/route_name.dart';
import 'package:ashera_pet_new/widget/time_line/app_widget/avatars.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../model/post_like.dart';
import '../../utils/app_color.dart';

class PostLikeBottomSheet extends StatefulWidget {
  final ScrollController controller;
  final List<PostLikeModel> postLikes;
  const PostLikeBottomSheet(
      {super.key, required this.controller, required this.postLikes});

  @override
  State<StatefulWidget> createState() => _PostLikeBottomSheetState();
}

class _PostLikeBottomSheetState extends State<PostLikeBottomSheet> {
  List<PostLikeModel> get postLikes => widget.postLikes;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 100,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ListView.separated(
          padding: EdgeInsets.zero,
          controller: widget.controller,
          itemBuilder: (context, index) => _itemWidget(postLikes[index]),
          separatorBuilder: (context, index) => _separatorWidget(),
          itemCount: postLikes.length),
    );
  }

  Widget _itemWidget(PostLikeModel data) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => context.push(RouteName.searchPet, extra: data.member),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        child: Row(
          children: [
            Avatar.medium(user: data.member),
            const SizedBox(
              width: 10,
            ),
            Text(
              data.member.nickname,
              style:
                  const TextStyle(color: AppColor.textFieldTitle, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _separatorWidget() {
    return Container(
      height: 1,
      decoration: const BoxDecoration(color: Colors.black),
    );
  }
}
