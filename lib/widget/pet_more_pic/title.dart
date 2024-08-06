import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/widget/back_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/utils.dart';

class PetMorePicTitle extends StatelessWidget {
  const PetMorePicTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: Utils.appBarHeight,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: AppColor.textFieldUnSelect),
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
          )),
          const Text(
            '上傳寵物照片',
            style: TextStyle(
                color: AppColor.textFieldTitle, fontSize: 22, height: 1.1),
          ),
          Expanded(
              child: TopDoneButton(
            alignment: Alignment.centerRight,
            callback: () {
              if (context.canPop()) {
                context.pop();
              }
            },
          )),
        ],
      ),
    );
  }
}
