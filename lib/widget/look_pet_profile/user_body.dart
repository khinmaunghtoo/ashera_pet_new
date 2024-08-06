import 'package:ashera_pet_new/model/member.dart';
import 'package:ashera_pet_new/widget/time_line/app_widget/avatars.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../model/hero_view_params.dart';
import '../../routes/route_name.dart';
import '../../utils/app_color.dart';

class UserProfileBody extends StatefulWidget {
  final MemberModel userData;
  const UserProfileBody({super.key, required this.userData});

  @override
  State<StatefulWidget> createState() => _UserProfileBodyState();
}

class _UserProfileBodyState extends State<UserProfileBody> {
  MemberModel get user => widget.userData;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                //頭像
                Avatar.huge(
                  user: user,
                  callback: () => context.push(RouteName.netWorkImageHeroView,
                      extra: HeroViewParamsModel(
                          tag: 'Avatar_${user.id}',
                          data: user.mugshot,
                          index: 0)),
                ),
                //名稱
                _itemBodyWidget('暱稱', user.nickname),
                //生日
                _itemBodyWidget('生日', user.birthday),
                //年齡
                _itemBodyWidget('年齡', '${user.age}'),
              ],
            ),
          ),
        ))
      ],
    );
  }

  Widget _itemBodyWidget(String title, String value) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 50,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: AppColor.textFieldUnSelect,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    color: AppColor.textFieldUnSelectBorder, width: 1)),
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
