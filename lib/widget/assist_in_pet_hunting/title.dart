import 'package:ashera_pet_new/utils/utils.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../routes/route_name.dart';
import '../../utils/app_color.dart';

//* 寵物雷達title
class PetRadarTitle extends StatelessWidget {
  const PetRadarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: Utils.appBarHeight,
      alignment: Alignment.center,
      color: AppColor.textFieldUnSelect,
      child: Row(
        children: [
          Expanded(
              child: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => context.push(RouteName.collection),
                child: Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: const Icon(
                    BootstrapIcons.bookmark,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              )
            ],
          )),
          const Text(
            '搜尋',
            style: TextStyle(
                fontSize: 20, color: AppColor.textFieldTitle, height: 1.1),
          ),
          Expanded(
              child: Row(
            children: [
              Expanded(child: Container()),
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => context.push(RouteName.like),
                child: Container(
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(
                    BootstrapIcons.heart,
                    color: Colors.white,
                    size: 25,
                  ),
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
