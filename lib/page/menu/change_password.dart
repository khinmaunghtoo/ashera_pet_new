import 'package:ashera_pet_new/model/member.dart';
import 'package:ashera_pet_new/utils/shared_preference.dart';
import 'package:ashera_pet_new/view_model/member.dart';
import 'package:ashera_pet_new/widget/system_back.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../dialog/cupertion_alert.dart';
import '../../utils/app_color.dart';
import '../../widget/button.dart';
import '../../widget/text_field.dart';
import '../../widget/title_bar.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  MemberVm? _memberVm;

  final _oldFormKey = GlobalKey<FormState>();
  final _newFormKey = GlobalKey<FormState>();
  final _checkFormKey = GlobalKey<FormState>();

  final TextEditingController _oldPassword = TextEditingController();
  FocusNode oldPasswordFN = FocusNode();
  final TextEditingController _newPassword = TextEditingController();
  FocusNode newPasswordFN = FocusNode();
  final TextEditingController _newPasswordCheck = TextEditingController();
  FocusNode newPasswordCheckFN = FocusNode();

  @override
  Widget build(BuildContext context) {
    _memberVm = Provider.of<MemberVm>(context, listen: false);
    return SystemBack(
        child: Scaffold(
      backgroundColor: AppColor.appBackground,
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              children: [
                TitleBar("變更密碼", left: [backButton()]),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: CombinationTextField(
                    title: '舊密碼',
                    isRequired: false,
                    child: PasswordTextField(
                        formKey: _oldFormKey,
                        hint: '請輸入舊密碼',
                        focusNode: oldPasswordFN,
                        controller: _oldPassword),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: CombinationTextField(
                    title: '新密碼',
                    isRequired: false,
                    child: PasswordTextField(
                        formKey: _newFormKey,
                        hint: '請輸入新密碼',
                        focusNode: newPasswordFN,
                        controller: _newPassword),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: CombinationTextField(
                    title: '新密碼確認',
                    isRequired: false,
                    child: PasswordTextField(
                        formKey: _checkFormKey,
                        hint: '請再次輸入新密碼',
                        focusNode: newPasswordCheckFN,
                        controller: _newPasswordCheck),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                //送出
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: blueRectangleButton('確認變更', _send),
                )
              ],
            ),
          );
        },
      ),
    ));
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
    UpdateMemberPasswordWithOldDTO dto = UpdateMemberPasswordWithOldDTO(
        newPassword: _newPasswordCheck.text, oldPassword: _oldPassword.text);
    if (await _memberVm!.updatePassword(dto)) {
      await _showAlert('變更成功');
      SharedPreferenceUtil.savePassword(_newPasswordCheck.text);
      if (mounted) context.pop();
    } else {
      await _showAlert('變更失敗');
    }
  }

  Future<bool> _judgmentData() async {
    if (_oldPassword.text.trim().isEmpty) {
      return await _showAlert('請輸入舊密碼');
    }
    if (_newPassword.text.trim().isEmpty) {
      return await _showAlert('請輸入新密碼');
    }
    if (_newPasswordCheck.text.trim().isEmpty) {
      return await _showAlert('請輸入新密碼確認');
    }
    if (_newPassword.text != _newPasswordCheck.text) {
      return await _showAlert('兩次密碼輸入不同');
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
