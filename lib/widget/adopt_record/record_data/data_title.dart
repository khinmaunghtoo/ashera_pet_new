import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../utils/app_color.dart';
import '../../../utils/utils.dart';

class DataTitle extends StatefulWidget{
  const DataTitle({super.key});

  @override
  State<StatefulWidget> createState() => _DataTitleState();
}

class _DataTitleState extends State<DataTitle>{

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
        children: [
          Expanded(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if (context.canPop()) {
                        context.pop();
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 10),
                      child: const Icon(
                        Icons.arrow_back,
                        size: 30,
                      ),
                    ),
                  ),
                  Expanded(child: Container())
                ],
              )
          ),
          const Text(
            '檢舉內容',
            style: TextStyle(
                color: AppColor.textFieldTitle,
                fontSize: 22,
                height: 1.1
            ),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}