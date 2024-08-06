
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

import '../../../data/member.dart';
import '../../../data/pet.dart';
import '../../../dialog/cupertion_alert.dart';
import '../../../model/member.dart';
import '../../../model/member_pet.dart';
import '../../../model/member_view.dart';
import '../../../model/message.dart';
import '../../../page/bottom_navigation/chat/room.dart';
import '../../../utils/app_color.dart';
import '../../../view_model/chat_msg.dart';
import '../../time_line/app_widget/avatars.dart';
import '../name_and_content.dart';
import '../time_and_uncount.dart';

class PetChatMsgItemRoomData extends StatefulWidget{
  final MessageModel data;
  const PetChatMsgItemRoomData({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => _PetChatMsgItemRoomDataState();
}

class _PetChatMsgItemRoomDataState extends State<PetChatMsgItemRoomData>{

  MessageModel get data => widget.data;
  ChatMsgVm? _chatMsgVm;

  @override
  void initState() {
    super.initState();
  }

  MemberAndMsgLast _getNextPageData(){
    return MemberAndMsgLast(
      member: MemberModel.fromMap(_getMember().toMap()),
      msg: data,
      chatType: data.chatType,
      pet: Pet.allPets.firstWhere((element) => element.id == data.memberPetId),
      chatRoomId: data.chatRoomId
    );
  }

  MemberView _getMember(){
    if(data.targetMemberId == Member.memberModel.id){
      return data.fromMemberView!;
    } else {
      return data.targetMemberView!;
    }
  }

  int _getUnreadCnt(){
    if(data.targetMemberId == Member.memberModel.id){
      return data.unreadCnt;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    _chatMsgVm = Provider.of<ChatMsgVm>(context);
    return GestureDetector(
      onTap: () async {
        await context.pushTransparentRoute(RoomPage(
          userData: _getNextPageData(),
        ));
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
                color: AppColor.textFieldUnSelect
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //大頭照
                Avatar.medium(user: MemberModel.fromMap(_getMember().toMap())),
                //名稱、性別與內容
                Expanded(child: NameAndContent(userData: MemberModel.fromMap(_getMember().toMap()),content: data.content, type: data.type,)),
                //時間與未讀
                Expanded(child: TimeAndUnCount(time: data.updatedAt, unCount: _getUnreadCnt(),)),
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
    if(r){
      _chatMsgVm!.sendDeleteChatRoom(data.chatRoomId);
    }
  }
}