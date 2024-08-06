import 'package:ashera_pet_new/widget/system_back.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../model/follower.dart';
import '../../../utils/app_color.dart';
import '../../../widget/follower/other_pet_follower_body.dart';
import '../../../widget/follower/title.dart';

class OtherPetFollower extends StatefulWidget {
  final OtherPetFollowerModel data;
  const OtherPetFollower({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => _OtherPetFollowerState();
}

class _OtherPetFollowerState extends State<OtherPetFollower> {
  @override
  Widget build(BuildContext context) {
    return SystemBack(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
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
                FollowerTitle(callback: _back),
                Expanded(
                    child: OtherPetFollowerBody(
                  data: widget.data,
                ))
              ],
            ),
          );
        },
      ),
    ));
  }

  //返回
  void _back() {
    context.pop();
  }
}
