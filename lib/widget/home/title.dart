import 'package:ashera_pet_new/enum/home_bar.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/utils.dart';
import '../../view_model/member.dart';
import '../ashera_pet_text.dart';

//* home page 頂部
// 原作者是想，用這個widget 右側的幾個icon button
// 結果，好像是搞的更複雜，以後要改為單獨的 route 了
class HomeTitle extends StatelessWidget {
  //* 這裡callback是一個function，還有個變量是HomeBar。 也就是說，主的view，還要判斷一次。很麻煩。
  final Function(HomeBar) callback;
  const HomeTitle({super.key, required this.callback});

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
          const Expanded(child: AsheraPetText()),
          Container(
            padding: const EdgeInsets.only(right: 5),
            child: Row(
              children: HomeBar.values.map((e) => _itemBar(e)).toList(),
            ),
          )
        ],
      ),
    );
  }

  Widget _itemBar(HomeBar bar) {
    switch (bar) {
      //* 創建新post
      case HomeBar.newPost:
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Icon(
              bar.icon,
              color: AppColor.textFieldTitle,
              size: 25,
            ),
          ),
          onTap: () => callback(bar),
        );
      //* search icon button
      case HomeBar.search:
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Icon(
              bar.icon,
              color: AppColor.textFieldTitle,
              size: 25,
            ),
          ),
          onTap: () => callback(bar),
        );
      // 通知icon button
      case HomeBar.notify:
        return Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                child: Icon(
                  bar.icon,
                  color: AppColor.textFieldTitle,
                  size: 25,
                ),
              ),
              onTap: () => callback(bar),
            ),
            Positioned(
                top: 15,
                left: 10,
                child: Consumer<MemberVm>(
                  builder: (context, vm, _) {
                    return Visibility(
                      visible: vm.messageNotifyStatus,
                      child: Container(
                        height: 8,
                        width: 8,
                        decoration: const BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle),
                      ),
                    );
                  },
                ))
          ],
        );
    }
  }
}
