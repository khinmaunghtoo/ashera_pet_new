import 'package:ashera_pet_new/model/member.dart';
import 'package:ashera_pet_new/widget/system_back.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../widget/look_pet_profile/title.dart';
import '../../../widget/look_pet_profile/user_body.dart';

class UserProfile extends StatefulWidget {
  final MemberModel userData;
  const UserProfile({super.key, required this.userData});

  @override
  State<StatefulWidget> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  MemberModel get userData => widget.userData;

  @override
  Widget build(BuildContext context) {
    return SystemBack(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.appBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //title
                LookPetProfileTitle(title: userData.nickname),
                //body
                Expanded(child: UserProfileBody(userData: userData))
              ],
            ),
          );
        },
      ),
    ));
  }
}
