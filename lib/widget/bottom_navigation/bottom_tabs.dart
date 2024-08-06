import 'package:ashera_pet_new/enum/bottom_bar.dart';
import 'package:ashera_pet_new/view_model/bottom_bar.dart';
import 'package:ashera_pet_new/view_model/post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_color.dart';

//* 底部導航的tabs
class BottomTabs extends StatelessWidget {
  const BottomTabs({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(child: _itemBar(BottomTab.home)),
        Flexible(child: _itemBar(BottomTab.chat)),
        const SizedBox(
          width: 80,
        ),
        Flexible(child: _itemBar(BottomTab.ranking)),
        Flexible(child: _itemBar(BottomTab.me))
      ],
    );
  }

  Widget _itemBar(BottomTab bar) {
    return Consumer2<BottomBarVm, PostVm>(
      builder: (context, vm, vm1, _) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () => vm.setBottomBar(bar),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //icon
                /*Flexible(
                    child: Image(
                  width: 25,
                  height: 25,
                  image: vm.bottomBar == bar
                      ? AssetImage(bar.iconPressed!)
                      : AssetImage(bar.icon!),
                )),*/
                Image(
                  width: 25,
                  height: 25,
                  image: vm.selectedTab == bar
                      ? AssetImage(bar.iconPressed!)
                      : AssetImage(bar.icon!),
                ),
                //text
                FittedBox(
                  child: Text(
                    bar.zh!,
                    style: TextStyle(
                        fontSize: 12,
                        color: vm.selectedTab == bar
                            ? AppColor.textFieldTitle
                            : AppColor.textFieldUnSelectBorder),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
