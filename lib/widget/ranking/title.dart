import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../ashera_pet_text.dart';

class PostRankingTitle extends StatelessWidget {
  final VoidCallback callback;
  const PostRankingTitle({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: Utils.appBarHeight,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: AppColor.textFieldUnSelect),
      child: const Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: AsheraPetText()),
          /*Container(
            padding: const EdgeInsets.only(right: 5),
            child: GestureDetector(
                onTap: () => callback,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: const Icon(
                    Icons.format_list_bulleted,
                    color: AppColor.textFieldTitle,
                    size: 25,
                  ),
                )),
          )*/
        ],
      ),
    );
  }
}
