import 'package:ashera_pet_new/widget/button.dart';
import 'package:ashera_pet_new/widget/register_member/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/member.dart';
import '../dialog/cupertion_alert.dart';
import '../routes/app_router.dart';
import '../routes/route_name.dart';
import '../utils/app_color.dart';
import '../view_model/member.dart';
import '../widget/register_member/avatar.dart';
import '../widget/text_field.dart';

class RegisterMemberPage extends StatefulWidget {
  const RegisterMemberPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterMemberPageState();
}

class _RegisterMemberPageState extends State<RegisterMemberPage> {
  MemberVm? _memberVm;

  FocusNode focusNodeGender = FocusNode();
  FocusNode focusNodeBirthday = FocusNode();

  final TextEditingController _gender = TextEditingController();
  final TextEditingController _birthday = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _memberVm = Provider.of(context, listen: false);
    return WillPopScope(
      child: Scaffold(
        backgroundColor: AppColor.appBackground,
        resizeToAvoidBottomInset: false,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //title
                  const RegisterMemberTitle(),
                  //image
                  Container(
                    height: constraints.maxWidth / 2.8,
                    width: constraints.maxWidth / 2.8,
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    child: const RegisterMemberAvatar(),
                  ),
                  //性別
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    child: CombinationTextField(
                      title: '性別',
                      isRequired: true,
                      child: GenderTextField(
                        controller: _gender,
                        focusNode: focusNodeGender,
                      ),
                    ),
                  ),
                  //生日
                  Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: CombinationTextField(
                        title: '生日',
                        isRequired: true,
                        child: BirthdayTextField(
                          focusNode: focusNodeBirthday,
                          controller: _birthday,
                        ),
                      )),
                  //註冊
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 40),
                    child: blueRectangleButton('完成', _register),
                  )
                ],
              ),
            );
          },
        ),
      ),
      onWillPop: () => AppRouter.pop(),
    );
  }

  //註冊
  void _register() async {
    if (mounted) SVProgressHUD.show();
    if (await _judgmentData()) {
      return;
    }
    if (Member.memberModel.mugshot.isNotEmpty &&
        !Member.memberModel.mugshot.contains(Member.memberModel.name)) {
      await _memberVm!.updateMemberAvatar();
    }
    await _memberVm!.updateMember();
    if (mounted) SVProgressHUD.dismiss();
    if (mounted) context.push(RouteName.registerPet);
  }

  //資料驗證
  Future<bool> _judgmentData() async {
    if (textFieldJudgment(_gender) || textFieldJudgment(_birthday)) {
      if (textFieldJudgment(_gender)) {
        return await _showAlert('請選擇性別');
      } else if (textFieldJudgment(_birthday)) {
        return await _showAlert('請選擇生日');
      }
    }
    return false;
  }

  bool textFieldJudgment(TextEditingController controller) {
    if (controller.text.trim().isEmpty) {
      return true;
    }
    return false;
  }

  //錯誤提示對話框
  Future<bool> _showAlert(String text) async {
    Future.delayed(const Duration(milliseconds: 1800),
        () => Navigator.of(context).pop(true));
    return await showCupertinoAlert(
        context: context, content: text, cancel: false, confirmation: false);
  }
}
