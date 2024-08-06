import 'dart:developer';

import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/enum/chat_type.dart';
import 'package:ashera_pet_new/model/member_pet.dart';
import 'package:ashera_pet_new/widget/chat/time_and_uncount.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../dialog/cupertion_alert.dart';
import '../../model/member.dart';
import '../../model/member_view.dart';
import '../../model/message.dart';
import '../../page/bottom_navigation/chat/room.dart';
import '../../utils/app_color.dart';
import '../../view_model/chat_msg.dart';
import '../time_line/app_widget/avatars.dart';
import 'name_and_content.dart';

class ChatMsgItem extends StatefulWidget {
  final MessageModel msgData;
  final ChatType chatType;
  const ChatMsgItem({super.key, required this.msgData, required this.chatType});

  @override
  State<StatefulWidget> createState() => _ChatMsgItemState();
}

class _ChatMsgItemState extends State<ChatMsgItem> {
  MessageModel get msgData => widget.msgData;
  ChatType get chatType => widget.chatType;
  ChatMsgVm? _chatMsgVm;

  MemberAndMsgLast _getNextPageData() {
    return MemberAndMsgLast(
      member: MemberModel.fromMap(_getMember().toMap()),
      msg: msgData,
      chatType: chatType,
    );
  }

  MemberView _getMember() {
    //log('msgData: ${msgData.toMap()}');
    if (msgData.targetMemberId == Member.memberModel.id) {
      return msgData.fromMemberView!;
    } else {
      return msgData.targetMemberView!;
    }
  }

  int _getUnreadCnt() {
    if (msgData.targetMemberId == Member.memberModel.id) {
      return msgData.unreadCnt;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    log('Msg: ${msgData.toMap()}');
    _chatMsgVm = Provider.of<ChatMsgVm>(context);
    return GestureDetector(
      onTap: () async {
        //openOrCloseFirebaseMessaging(false);
        //await context.push(RouteName.room, extra: _getNextPageData());
        await context.pushTransparentRoute(RoomPage(
          userData: _getNextPageData(),
        ));
        //openOrCloseFirebaseMessaging(true);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        child: Slidable(
          endActionPane: ActionPane(
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                borderRadius: BorderRadius.circular(10),
                onPressed: (context) => _deleteChatRoom(),
                backgroundColor: const Color(0xFFFE4A49),
                foregroundColor: Colors.white,
                icon: Icons.delete,
                label: '刪除',
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: AppColor.textFieldUnSelect),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //大頭照
                Avatar.medium(user: MemberModel.fromMap(_getMember().toMap())),
                //名稱、性別與內容
                Expanded(
                    child: NameAndContent(
                  userData: MemberModel.fromMap(_getMember().toMap()),
                  content: msgData.content,
                  type: msgData.type,
                )),
                //時間與未讀
                Expanded(
                    child: TimeAndUnCount(
                  time: msgData.updatedAt,
                  unCount: _getUnreadCnt(),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _showDeleteAlert() async {
    return await showCupertinoAlert(
        context: context,
        content: '確定要刪除聊天室？',
        cancel: true,
        confirmation: true);
  }

  void _deleteChatRoom() async {
    bool r = await _showDeleteAlert();
    if (r) {
      _chatMsgVm!.sendDeleteChatRoom(msgData.chatRoomId);
    }
  }
}
