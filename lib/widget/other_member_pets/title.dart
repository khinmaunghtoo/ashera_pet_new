import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/utils.dart';

class OtherMemberPetsTitle extends StatelessWidget {
  const OtherMemberPetsTitle({super.key});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: Utils.appBarHeight,
      alignment: Alignment.center,
      color: AppColor.textFieldUnSelect,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => context.pop(),
            child: const Icon(
              Icons.arrow_back,
              color: Colors.white,
              size: 25,
            ),
          ),
          const Text(
            '寵物列表',
            style: TextStyle(
                fontSize: 20, color: AppColor.textFieldTitle, height: 1.1),
          ),
          Container()
        ],
      ),
    );
  }
}
