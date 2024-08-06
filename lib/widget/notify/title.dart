import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/widget/back_button.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class NotifyTitle extends StatelessWidget {
  final VoidCallback callback;
  const NotifyTitle({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: Utils.appBarHeight,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColor.textFieldUnSelect,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: TopBackButton(
            alignment: Alignment.centerLeft,
            callback: callback,
          )),
          const Text(
            '通知',
            style: TextStyle(
                fontSize: 20, color: AppColor.textFieldTitle, height: 1.1),
          ),
          Expanded(child: Container())
        ],
      ),
    );
  }
}
