import 'package:flutter/cupertino.dart';

import '../../utils/app_color.dart';
import '../../utils/utils.dart';
import '../back_button.dart';

class EditUserProfileTitle extends StatelessWidget{
  final VoidCallback callback;
  final VoidCallback doneCallBack;

  const EditUserProfileTitle({
    super.key,
    required this.callback,
    required this.doneCallBack
  });

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
          Expanded(child: TopBackButton(
            alignment: Alignment.centerLeft,
            callback: callback,
          )),
          const Text(
            '編輯個人資料',
            style: TextStyle(
                fontSize: 20,
                color: AppColor.textFieldTitle,
                height: 1.1
            ),
          ),
          //完成按鈕
          Expanded(child: TopDoneButton(
            alignment: Alignment.centerRight,
            callback: doneCallBack,
          ))
        ],
      ),
    );
  }
}