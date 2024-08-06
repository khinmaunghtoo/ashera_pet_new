import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdoptRecordTitle extends StatelessWidget {
  const AdoptRecordTitle({super.key});

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
            '檢舉紀錄',
            style: TextStyle(
                color: AppColor.textFieldTitle, fontSize: 22, height: 1.1),
          ),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}
