import 'package:ashera_pet_new/enum/chat_type.dart';
import 'package:ashera_pet_new/utils/app_image.dart';
import 'package:ashera_pet_new/view_model/chat_msg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_color.dart';

class SubscribeAndBeSubscribed extends StatelessWidget {
  const SubscribeAndBeSubscribed({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(child: Consumer<ChatMsgVm>(
          builder: (context, vm, _) {
            return GestureDetector(
              onTap: () => vm.setType(ChatType.GENERAL),
              child: Container(
                width: 55,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Image(
                      image: AssetImage(vm.type == ChatType.GENERAL
                          ? AppImage.iconChatSelected
                          : AppImage.iconChat),
                    ),
                    Container(
                      height: 3,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: vm.type == ChatType.GENERAL
                              ? AppColor.button
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20)),
                    )
                  ],
                ),
              ),
            );
          },
        )),
        Flexible(child: Consumer<ChatMsgVm>(
          builder: (context, vm, _) {
            return GestureDetector(
              onTap: () => vm.setType(ChatType.PET),
              child: Container(
                //height: 60,
                width: 55,
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Image(
                      image: AssetImage(vm.type == ChatType.PET
                          ? AppImage.iconPrivateMsgSelected
                          : AppImage.iconPrivateMsg),
                    ),
                    Container(
                      height: 3,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: vm.type == ChatType.PET
                              ? AppColor.button
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(20)),
                    )
                  ],
                ),
              ),
            );
          },
        ))
      ],
    );
  }
}
