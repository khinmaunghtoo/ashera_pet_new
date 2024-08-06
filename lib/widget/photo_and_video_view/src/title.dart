import 'package:flutter/cupertino.dart';

import '../../../utils/app_color.dart';
import '../../../utils/utils.dart';
import '../../back_button.dart';

class PhotoAndVideoViewTitle extends StatelessWidget{
  final VoidCallback callback;
  const PhotoAndVideoViewTitle({super.key, required this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: Utils.appBarHeight,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColor.textFieldUnSelect
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
              )
          ),
          Expanded(child: Container())
        ],
      ),
    );
  }
}