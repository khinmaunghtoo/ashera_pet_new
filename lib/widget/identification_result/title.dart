import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/utils/utils.dart';
import 'package:flutter/cupertino.dart';

class IdentificationResultTitle extends StatelessWidget {
  const IdentificationResultTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: Utils.appBarHeight,
      alignment: Alignment.center,
      child: const Text(
        '辨識寵物',
        style: TextStyle(
            fontSize: 20, color: AppColor.textFieldTitle, height: 1.1),
      ),
    );
  }
}
