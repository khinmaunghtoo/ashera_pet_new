import 'package:ashera_pet_new/widget/back_button.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/app_color.dart';
import '../../utils/utils.dart';

class ExploreTitle extends StatelessWidget {
  final VoidCallback callback;
  const ExploreTitle({super.key, required this.callback});

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
          Expanded(
              child: TopBackButton(
            alignment: Alignment.centerLeft,
            callback: callback,
          )),
          const Text(
            '探索',
            style: TextStyle(
                fontSize: 20, color: AppColor.textFieldTitle, height: 1.1),
          ),
          //
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
