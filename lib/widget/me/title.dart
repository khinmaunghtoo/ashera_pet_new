import 'package:ashera_pet_new/enum/me_bar.dart';
import 'package:ashera_pet_new/utils/utils.dart';
import 'package:flutter/material.dart';

import '../../utils/app_color.dart';
import '../ashera_pet_text.dart';

// 设定页面title
class SettingsPageTitle extends StatelessWidget {
  final Function(MeBar) callback;
  const SettingsPageTitle({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: Utils.appBarHeight,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: AppColor.textFieldUnSelect),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Expanded(child: AsheraPetText()),
          // 右侧按钮
          Container(
            padding: const EdgeInsets.only(right: 5),
            child: Row(
              children: MeBar.values.map((e) => _itemBar(e)).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _itemBar(MeBar bar) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => callback(bar),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          child: Icon(
            bar.icon,
            color: AppColor.textFieldTitle,
            size: 25,
          ),
        ));
  }
}
