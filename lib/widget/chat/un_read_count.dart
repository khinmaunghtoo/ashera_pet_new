import 'package:flutter/cupertino.dart';

import '../../utils/app_color.dart';
import '../../utils/utils.dart';

class UnReadCount extends StatelessWidget{
  final int unReadCount;
  const UnReadCount({super.key, required this.unReadCount});

  @override
  Widget build(BuildContext context) {
    if(unReadCount == 0){
      return const SizedBox(height: 20);
    }
    return Container(
      height: 20,
      width: Utils.redDotWidth('$unReadCount'),
      margin: const EdgeInsets.symmetric(vertical: 5),
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: AppColor.button,
          borderRadius: BorderRadius.circular(30)
      ),
      child: Text(
        '$unReadCount',
        style: const TextStyle(
            color: AppColor.textFieldTitle,
            fontSize: 10
        ),
      ),
    );
  }
}