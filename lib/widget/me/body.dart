import 'package:ashera_pet_new/view_model/post.dart';
import 'package:ashera_pet_new/widget/me/user_post_grid_view.dart';
import 'package:ashera_pet_new/widget/me/user_profile_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../utils/app_color.dart';

// 设定页面body
class SettingsPageBody extends StatelessWidget {
  final VoidCallback callback;
  const SettingsPageBody({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        // 用户个人资料
        SliverToBoxAdapter(
          child: UserProfileHeader(
            callback: callback,
          ),
        ),
        Consumer<PostVm>(builder: (context, postProvider, _) {
          if (postProvider.mePostData.isEmpty) {
            //如果沒資料
            return const SliverFillRemaining(
              child: Center(
                child: Text(
                  '目前還沒有貼文',
                  style: TextStyle(color: AppColor.textFieldTitle),
                ),
              ),
            );
          }
          // 用户的帖子
          return UserPostGridView(
            imgList: postProvider.mePostData,
          );
        }),
      ],
    );
  }
}
