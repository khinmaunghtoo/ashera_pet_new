import 'package:flutter/cupertino.dart';

import '../../data/member.dart';
import '../../utils/app_color.dart';
import '../../utils/utils.dart';
import '../back_button.dart';

class SearchMeTitle extends StatelessWidget{
  final VoidCallback callback;
  const SearchMeTitle({super.key, required this.callback});

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
          Text(
            Member.memberModel.nickname,
            style: const TextStyle(
                fontSize: 20,
                color: AppColor.textFieldTitle,
                height: 1.1
            ),
          ),
          Expanded(child: Container())
        ],
      ),
    );
  }
}