import 'package:flutter/material.dart';

import '../utils/app_color.dart';
import '../utils/utils.dart';

class TitleBarWidget {
  static Widget backButtonWidget() {
    return const SizedBox(
      child: Icon(
        Icons.arrow_back,
        size: 35,
        color: Colors.white,
      ),
    );
  }

  static Widget backButtonClearWidget() {
    return const SizedBox(
      child: Icon(
        Icons.clear,
        size: 35,
        color: Colors.white,
      ),
    );
  }
}

class TitleBar extends StatelessWidget {
  const TitleBar(String this.title, {super.key,this.left,this.right});
  final List<Widget>? left;
  final List<Widget>? right;

  final String? title;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      width: MediaQuery.of(context).size.width,
      height: Utils.appBarHeight,
      decoration: const BoxDecoration(
        color: AppColor.textFieldUnSelect,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          //左按鈕
          if (left != null)
            Positioned(
                left: 10,
                child: Row(
                  children: left!,
                )),
          //標題文字
          FittedBox(
            child: Text(
              title ?? "",
              style: const TextStyle(color: Colors.white, fontSize: 21),
            ),
          ),
          //右按紐
          if (right != null)
            Positioned(
                right: 10,
                child: Row(
                  children: right!,
                )),
        ],
      ),
    );
  }
}
