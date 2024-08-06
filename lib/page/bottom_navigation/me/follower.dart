import 'package:ashera_pet_new/enum/tab_bar.dart';
import 'package:ashera_pet_new/widget/follower/body.dart';
import 'package:ashera_pet_new/widget/follower/title.dart';
import 'package:ashera_pet_new/widget/system_back.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/app_color.dart';

class FollowerPage extends StatefulWidget {
  final FollowerTabBarEnum type;
  const FollowerPage({super.key, required this.type});

  @override
  State<StatefulWidget> createState() => _FollowerPageState();
}

class _FollowerPageState extends State<FollowerPage> {
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
                    child: FollowerBody(
                  type: widget.type,
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
