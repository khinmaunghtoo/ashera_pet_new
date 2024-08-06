import 'dart:developer';

import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/view_model/adopt_report_vm.dart';
import 'package:ashera_pet_new/widget/room/bubble/message_bubble.dart';
import 'package:ashera_pet_new/widget/room/chat_ui/chat_pass.dart';
import 'package:ashera_pet_new/widget/room/chat_ui/chat_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../../enum/adopt_status.dart';
import '../../../enum/message_type.dart';
import '../../../model/message.dart';
import '../../room/chat_ui/chat_pic.dart';

class ReportDataBody extends StatefulWidget {
  const ReportDataBody({super.key});

  @override
  State<StatefulWidget> createState() => _ReportDataBodyState();
}

class _ReportDataBodyState extends State<ReportDataBody> {
  AdoptReportVm? _adoptReportVm;

  @override
  void dispose() {
    super.dispose();
    _adoptReportVm!.clearNowRecordId();
  }

  @override
  Widget build(BuildContext context) {
    _adoptReportVm = Provider.of(context);
    return Consumer<AdoptReportVm>(
      builder: (context, vm, _) {
        log('nowRecord: ${vm.nowRecord.toMap()}');
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //檢舉內容
              MessageBubble(
                  member: Member.memberModel,
                  showAvatar: false,
                  message: MessageModel(
                      fromMember: '',
                      fromMemberId: vm.nowRecord.fromMemberId,
                      targetMember: '',
                      targetMemberId: vm.nowRecord.targetMemberId,
                      content: vm.nowRecord.reason,
                      type: MessageType.TEXT,
                      chatRoomId: 0,
                      createdAt: vm.nowRecord.createdAt),
                  child: ChatTextWidget(
                    key: ValueKey('${vm.nowRecordId}'),
                    content: vm.nowRecord.reason,
                  )),
              //檢舉截圖
              MessageBubble(
                  member: Member.memberModel,
                  showAvatar: false,
                  message: MessageModel(
                      fromMember: '',
                      fromMemberId: vm.nowRecord.fromMemberId,
                      targetMember: '',
                      targetMemberId: vm.nowRecord.targetMemberId,
                      content: vm.nowRecord.pic,
                      type: MessageType.PIC,
                      chatRoomId: 0,
                      createdAt: vm.nowRecord.createdAt),
                  child: ChatPicWidget(
                    key: ValueKey('${vm.nowRecordId}'),
                    id: vm.nowRecordId,
                    pic: vm.nowRecord.pic,
                  )),
              //檢舉結果
              Visibility(
                  visible: vm.nowRecord.status !=
                      ComplaintRecordStatus.WAITING_REPLY,
                  child: MessageBubble(
                      member: Member.memberModel,
                      showAvatar: false,
                      message: MessageModel(
                          fromMember: '',
                          fromMemberId: vm.nowRecord.targetMemberId,
                          targetMember: '',
                          targetMemberId: vm.nowRecord.fromMemberId,
                          content: '',
                          type: MessageType.TEXT,
                          chatRoomId: 0,
                          createdAt: vm.nowRecord.updatedAt),
                      child: ChatTextWidget(
                        key: ValueKey('${vm.nowRecordId}'),
                        content: '平台已審核你的檢舉內容',
                      ))),
              Visibility(
                  visible: vm.nowRecord.status !=
                      ComplaintRecordStatus.WAITING_REPLY,
                  child: MessageBubble(
                      member: Member.memberModel,
                      showAvatar: false,
                      message: MessageModel(
                          fromMember: '',
                          fromMemberId: vm.nowRecord.targetMemberId,
                          targetMember: '',
                          targetMemberId: vm.nowRecord.fromMemberId,
                          content: '',
                          type: MessageType.TEXT,
                          chatRoomId: 0,
                          createdAt: vm.nowRecord.updatedAt),
                      child: ChatPassOrNotTextWidget(
                        key: ValueKey('${vm.nowRecordId + 1}'),
                        status: vm.nowRecord.status,
                      ))),
              //回覆
              /*Visibility(
                visible: vm.nowRecord.reply.isNotEmpty,
                child: MessageBubble(
                    member: Member.memberModel,
                    showAvatar: false,
                    message: MessageModel(
                        fromMember: '',
                        fromMemberId: vm.nowRecord.targetMemberId,
                        targetMember: '',
                        targetMemberId: vm.nowRecord.fromMemberId,
                        content: vm.nowRecord.reply,
                        type: MessageType.TEXT,
                        chatRoomId: 0,
                        createdAt: vm.nowRecord.updatedAt
                    ),
                    child: ChatTextWidget(
                      key: ValueKey('${vm.nowRecordId}'),
                      content: vm.nowRecord.reply,
                    )
                )
            )*/
            ],
          ),
        );
      },
    );
  }
}
