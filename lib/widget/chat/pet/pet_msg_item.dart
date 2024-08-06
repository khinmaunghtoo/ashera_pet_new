import 'package:accordion/accordion.dart';
import 'package:ashera_pet_new/data/pet.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/view_model/chat_msg.dart';
import 'package:ashera_pet_new/widget/chat/pet/pet_msg_room.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/member.dart';
import '../../../model/member.dart';
import '../../../model/member_pet.dart';
import '../../time_line/app_widget/avatars.dart';
import '../un_read_count.dart';

//依寵物分類
class PetChatMsgItem extends StatelessWidget {
  const PetChatMsgItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ChatMsgVm>(
      builder: (context, vm, _) {
        if (vm.petLastMsgList.isEmpty) {
          return Container();
        }
        return Accordion(
          openAndCloseAnimation: true,
          scaleWhenAnimating: false,
          paddingListTop: 0,
          children: vm.petLastMsgList.keys.map((e) => _petRoom(e)).toList(),
        );
      },
    );
  }

  AccordionSection _petRoom(int key) {
    MemberPetModel? pet =
        Pet.allPets.where((element) => element.id == key).first;
    return AccordionSection(
        isOpen: false,
        headerPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 0),
        header: Consumer<ChatMsgVm>(
          builder: (context, vm, _) {
            int unreadCnt = vm.petLastMsgList[key]!
                .where((element) =>
                    element.targetMemberId == Member.memberModel.id)
                .fold(
                    0,
                    (previousValue, element) =>
                        previousValue += element.unreadCnt);
            return Container(
              height: 50,
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      //寵物大頭照
                      Avatar.small(user: MemberModel.fromMap(pet.toMap())),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        pet.nickname,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ],
                  )),
                  UnReadCount(
                    unReadCount: unreadCnt,
                  )
                ],
              ),
            );
          },
        ),
        contentBackgroundColor: AppColor.appBackground,
        contentBorderColor: AppColor.appBackground,
        contentBorderWidth: 0,
        content: Consumer<ChatMsgVm>(
          builder: (context, vm, _) {
            return Column(
              children: vm.petLastMsgList[key]!
                  .map((e) => PetChatMsgItemRoomData(data: e))
                  .toList(),
            );
          },
        ));
  }
}
