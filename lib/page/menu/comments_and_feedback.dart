import 'dart:developer';

import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/model/member_feedback.dart';
import 'package:ashera_pet_new/view_model/member_feedback.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../dialog/cupertion_alert.dart';
import '../../model/tuple.dart';
import '../../utils/app_color.dart';
import '../../widget/button.dart';
import '../../widget/text_field.dart';
import '../../widget/title_bar.dart';

class CommentsAndFeedback extends StatefulWidget {
  const CommentsAndFeedback({super.key});

  @override
  State<CommentsAndFeedback> createState() => _CommentsAndFeedbackState();
}

class _CommentsAndFeedbackState extends State<CommentsAndFeedback> {
  final TextEditingController _commentsAndFeedback = TextEditingController();
  FocusNode commentsAndFeedback = FocusNode();

  MemberFeedbackVm? _memberFeedbackVm;

  @override
  Widget build(BuildContext context) {
    _memberFeedbackVm = Provider.of<MemberFeedbackVm>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColor.appBackground,
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              children: [
                TitleBar("意見及問題反饋", left: [backButton()]),
                card(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget card() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColor.textFieldUnSelect,
      ),
      child: Column(
        children: [
          CombinationTextField(
            title: '意見',
            isRequired: false,
            child: FeedBackInputField(
              focusNode: commentsAndFeedback,
              controller: _commentsAndFeedback,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: blueRectangleButton('送出', _send),
          )
        ],
      ),
    );
  }

  Widget backButton() {
    return GestureDetector(
      onTap: () {
        context.pop();
      },
      child: TitleBarWidget.backButtonWidget(),
    );
  }

  void _send() async {
    if (await _judgmentData()) {
      return;
    }
    AddMemberFeedbackDTO dto = AddMemberFeedbackDTO(
        memberId: Member.memberModel.id, body: _commentsAndFeedback.text);
    Tuple<bool, String> r = await _memberFeedbackVm!.addMemberFeedback(dto);
    if (r.i1!) {
      await _showAlert('送出成功');
      if (mounted) context.pop();
    } else {
      log('error: ${r.i2}');
      await _showAlert(r.i2!);
    }
  }

  Future<bool> _judgmentData() async {
    if (_commentsAndFeedback.text.isEmpty) {
      return await _showAlert('請輸入意見');
    }
    return false;
  }

  Future<bool> _showAlert(String text) async {
    Future.delayed(const Duration(milliseconds: 1800),
        () => Navigator.of(context).pop(true));
    return await showCupertinoAlert(
        context: context, content: text, cancel: false, confirmation: false);
  }
}
