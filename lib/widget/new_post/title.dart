import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/utils/utils.dart';
import 'package:ashera_pet_new/widget/back_button.dart';
import 'package:flutter/cupertino.dart';

class NewPostTitle extends StatelessWidget {
  final VoidCallback callback;
  final VoidCallback postCallback;
  final VoidCallback cropCallback;
  const NewPostTitle(
      {super.key,
      required this.callback,
      required this.postCallback,
      required this.cropCallback});

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
              child: TopCloseBackButton(
            alignment: Alignment.centerLeft,
            callback: callback,
          )),
          const Text(
            '動態發佈',
            style: TextStyle(
                fontSize: 20, color: AppColor.textFieldTitle, height: 1.1),
          ),
          //發佈按鈕
          Expanded(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              /*TopCropImageButton(
                      callback: cropCallback,
                      alignment: Alignment.centerLeft
                  ),*/
              TopNewPostButton(
                alignment: Alignment.centerRight,
                callback: postCallback,
              ),
            ],
          ))
        ],
      ),
    );
  }
}
