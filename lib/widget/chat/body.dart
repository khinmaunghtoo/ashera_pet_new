import 'package:ashera_pet_new/enum/chat_type.dart';
import 'package:ashera_pet_new/view_model/chat_msg.dart';
import 'package:ashera_pet_new/widget/chat/pet/pet_msg_item.dart';
import 'package:ashera_pet_new/widget/chat/subscribe_and_be_subscribed.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../utils/app_color.dart';
import 'msg_item.dart';

//* chat page body
class ChatBody extends StatelessWidget {
  const ChatBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //追隨中與跟隨中
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          child: const SubscribeAndBeSubscribed(),
        ),
        //訊息列表

        Expanded(child: Consumer<ChatMsgVm>(
          builder: (context, vm, _) {
            if (vm.lastMsgList.isEmpty) {
              return const Center(
                child: Text(
                  '目前還沒有新訊息',
                  style: TextStyle(color: AppColor.textFieldTitle),
                ),
              );
            }
            switch (vm.type) {
              case ChatType.GENERAL:
                return ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    itemCount: vm.lastMsgList.length,
                    itemBuilder: (context, index) {
                      //log('這裡面 ${vm.lastMsgList[index].toMap()} ${vm.lastMsgList.length}');
                      return ChatMsgItem(
                          msgData: vm.lastMsgList[index], chatType: vm.type);
                      //return Container();
                    });
              case ChatType.PET:
                return const PetChatMsgItem();
            }
          },
        ))
      ],
    );
  }
}
