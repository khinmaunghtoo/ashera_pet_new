import 'package:ashera_pet_new/model/update_adopt_record_reply.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/member.dart';
import '../../../enum/message_type.dart';
import '../../../model/message.dart';
import '../../../utils/app_color.dart';
import '../../../view_model/adopt_report_vm.dart';
import '../../room/bubble/message_bubble.dart';
import '../../room/chat_ui/chat_pic.dart';
import '../../room/chat_ui/chat_text.dart';
import '../../text_field.dart';

class ReportedDataBody extends StatefulWidget {
  const ReportedDataBody({super.key});

  @override
  State<StatefulWidget> createState() => _ReportedDataBodyState();
}

class _ReportedDataBodyState extends State<ReportedDataBody> {
  AdoptReportVm? _adoptReportVm;
  final TextEditingController _input = TextEditingController();
  final FocusNode focusNodeInput = FocusNode();

  @override
  void initState() {
    super.initState();
    _input.addListener(_listener);
  }

  void _listener() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _input.removeListener(_listener);
    _adoptReportVm!.clearNowRecordId();
  }

  @override
  Widget build(BuildContext context) {
    _adoptReportVm = Provider.of(context);
    return Consumer<AdoptReportVm>(
      builder: (context, vm, _) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  //檢舉內容
                  MessageBubble(
                      member: Member.memberModel,
                      showAvatar: false,
                      message: MessageModel(
                          fromMember: vm.nowRecord.fromMember,
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
                          fromMember: vm.nowRecord.fromMember,
                          fromMemberId: vm.nowRecord.fromMemberId,
                          targetMemberId: vm.nowRecord.targetMemberId,
                          targetMember: '',
                          chatRoomId: 0,
                          content: vm.nowRecord.pic,
                          type: MessageType.PIC,
                          createdAt: vm.nowRecord.createdAt),
                      child: ChatPicWidget(
                        key: ValueKey('${vm.nowRecordId}'),
                        id: vm.nowRecordId,
                        pic: vm.nowRecord.pic,
                      )),
                  //回覆
                  Visibility(
                      visible: vm.nowRecord.reply.isNotEmpty,
                      child: MessageBubble(
                          member: Member.memberModel,
                          showAvatar: false,
                          message: MessageModel(
                              fromMember: '',
                              fromMemberId: vm.nowRecord.targetMemberId,
                              targetMember: vm.nowRecord.fromMember,
                              targetMemberId: vm.nowRecord.fromMemberId,
                              content: vm.nowRecord.reply,
                              type: MessageType.TEXT,
                              chatRoomId: 0,
                              createdAt: vm.nowRecord.updatedAt),
                          child: ChatTextWidget(
                            key: ValueKey('${vm.nowRecordId}'),
                            content: vm.nowRecord.reply,
                          ))),
                ],
              ),
            )),
            //回覆輸入框
            Visibility(
                visible: vm.nowRecord.reply.isEmpty, child: _inputWidget())
          ],
        );
      },
    );
  }

  Widget _inputWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: const BoxDecoration(color: AppColor.textFieldUnSelect),
      child: Row(
        children: [
          //輸入框
          Expanded(
              child: ChatTextField(
            readOnly: false,
            controller: _input,
            focusNode: focusNodeInput,
            hintText: '輸入訊息...',
          )),
          const SizedBox(
            width: 5,
          ),
          _sendButton()
        ],
      ),
    );
  }

  Widget _sendButton() {
    return Consumer<AdoptReportVm>(
      builder: (context, vm, _) {
        return GestureDetector(
          onTap: _input.text.isEmpty
              ? null
              : () {
                  UpdateAdoptRecordReplyDTO dto = UpdateAdoptRecordReplyDTO(
                      id: vm.nowRecordId,
                      fromMember: vm.nowRecord.fromMember,
                      targetMember: '',
                      reply: _input.text,
                      replyPics: '[]');
                  vm.sendUpdateAdoptRecordReply(dto);
                  _input.clear();
                },
          child: Icon(Icons.near_me_sharp,
              color: _input.text.isEmpty
                  ? AppColor.textFieldHintText
                  : AppColor.button,
              size: 35),
        );
      },
    );
  }
}
