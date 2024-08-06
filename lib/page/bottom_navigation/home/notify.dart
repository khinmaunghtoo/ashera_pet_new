import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/widget/system_back.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../widget/notify/body.dart';
import '../../../widget/notify/title.dart';

class NotifyPage extends StatefulWidget {
  const NotifyPage({super.key});

  @override
  State<StatefulWidget> createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
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
                NotifyTitle(
                  callback: _back,
                ),
                const Expanded(child: NotifyBody())
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
    //Navigator.of(context).pop();
  }
}
