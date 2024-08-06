import 'package:ashera_pet_new/widget/me/user_and_post_follow.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../data/member.dart';
import '../button.dart';
import 'about_me.dart';

class UserProfileHeader extends StatelessWidget {
  final VoidCallback callback;
  const UserProfileHeader({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Column(
        children: [
          //最上 會員 貼文數 跟隨中 追隨中
          Container(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 15, bottom: 5),
            child: UserAndPostFollow(
              userData: Member.memberModel,
              callback: callback,
            ),
          ),
          //關於
          const MeAbout(),
          //編輯個人資料
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: grayRectangleButton('編輯寵物資料', callback),
          ),
        ],
      );
    });
  }
}
