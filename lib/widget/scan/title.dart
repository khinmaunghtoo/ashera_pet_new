import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/utils/utils.dart';
import 'package:ashera_pet_new/widget/back_button.dart';
import 'package:flutter/cupertino.dart';

class ScanTitle extends StatelessWidget {
  final VoidCallback callback;
  final String title;
  const ScanTitle({super.key, required this.callback, required this.title});

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
          Expanded(child: Container()),
          Text(
            title,
            style: const TextStyle(
                fontSize: 20, color: AppColor.textFieldTitle, height: 1.1),
          ),
          Expanded(
              child: TopCloseBackButton(
            alignment: Alignment.centerRight,
            callback: callback,
          ))
        ],
      ),
    );
  }
}
