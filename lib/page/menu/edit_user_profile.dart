import 'dart:developer';

import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/enum/gender.dart';
import 'package:ashera_pet_new/view_model/member.dart';
import 'package:ashera_pet_new/widget/system_back.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../dialog/cupertion_alert.dart';
import '../../utils/app_color.dart';
import '../../widget/edit_user_profile/body.dart';
import '../../widget/edit_user_profile/title.dart';

class EditUserProfile extends StatefulWidget {
  const EditUserProfile({super.key});

  @override
  State<StatefulWidget> createState() => _EditUserProfileState();
}

class _EditUserProfileState extends State<EditUserProfile> {
  MemberVm? _memberVm;
  final TextEditingController _aboutMe = TextEditingController();
  final TextEditingController _nickname = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _birthday = TextEditingController();

  _onLayoutDone(_) {
    log('Member: ${Member.memberModel.toMap()}');
    _aboutMe.text = Member.memberModel.aboutMe;
    _nickname.text = Member.memberModel.nickname;
    _gender.text = GenderEnum.values[Member.memberModel.gender].zh;
    _birthday.text = Member.memberModel.birthday;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
  }

  @override
  Widget build(BuildContext context) {
    _memberVm = Provider.of<MemberVm>(context, listen: false);
    return SystemBack(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.appBackground,
      body: LayoutBuilder(builder: (context, constraints) {
        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //title
              EditUserProfileTitle(
                callback: _back,
                doneCallBack: _done,
              ),
              Expanded(
                  child: EditUserProfileBody(
                constraints: constraints,
                aboutMe: _aboutMe,
                nickname: _nickname,
                gender: _gender,
                birthday: _birthday,
              ))
            ],
          ),
        );
      }),
    ));
  }

  //返回
  void _back() async {
    await _memberVm!.getMemberInforWithUserIDAndPersistent();
    if (mounted) context.pop();
  }

  //完成
  void _done() async {
    if (await _judgmentData()) {
      return;
    }
    _memberVm!.setNickname(_nickname.text);
    if (_aboutMe.text.isNotEmpty) {
      _memberVm!.setAbout(_aboutMe.text);
    }
    if (Member.memberModel.mugshot.isNotEmpty &&
        !Member.memberModel.mugshot.contains(Member.memberModel.name)) {
      await _memberVm!.updateMemberAvatar();
    }
    await _memberVm!.updateMember();
    if (mounted) context.pop();
  }

  //資料判斷
  Future<bool> _judgmentData() async {
    if (_nickname.text.trim().isEmpty) {
      return await _showAlert('暱稱不可為空');
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
