import 'dart:developer';

import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/data/pet.dart';
import 'package:ashera_pet_new/enum/health_status.dart';
import 'package:ashera_pet_new/enum/member_status.dart';
import 'package:ashera_pet_new/model/member_pet.dart';
import 'package:ashera_pet_new/view_model/member_pet.dart';
import 'package:ashera_pet_new/widget/register_pet/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../dialog/cupertion_alert.dart';
import '../enum/animal.dart';
import '../model/member_view.dart';
import '../model/tuple.dart';
import '../routes/route_name.dart';
import '../utils/app_color.dart';
import '../widget/button.dart';
import '../widget/register_pet/avatar.dart';
import '../widget/text_field.dart';

class RegisterPetPage extends StatefulWidget {
  const RegisterPetPage({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterPetPageState();
}

class _RegisterPetPageState extends State<RegisterPetPage> {
  MemberPetVm? _memberPetVm;

  FocusNode focusNodeNickname = FocusNode();
  FocusNode focusNodeAnimalType = FocusNode();
  FocusNode focusNodeGender = FocusNode();
  FocusNode focusNodeBirthday = FocusNode();

  final TextEditingController _nickname = TextEditingController();
  final TextEditingController _animalType = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _birthday = TextEditingController();

  _onLayoutDone(_) {
    if (Pet.petModel.isEmpty) {
      Pet.petModel.add(MemberPetModel(
          id: 0,
          memberId: Member.memberModel.id,
          mugshot: '',
          nickname: '',
          aboutMe: '',
          age: 0,
          birthday: '',
          animalType: AnimalType.dog.index,
          gender: 0,
          healthStatus: 0,
          member: MemberView.fromMap(Member.memberModel.toMap()),
          status: MemberStatus.ACTIVE));
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
  }

  @override
  Widget build(BuildContext context) {
    _memberPetVm = Provider.of<MemberPetVm>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColor.appBackground,
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                /*Positioned(
                left: 10,
                  top: 10 + MediaQuery.of(context).viewPadding.top,
                  child: TopBackButton(
                    callback: () => _back(),
                    alignment: Alignment.centerLeft,
                  )
              ),*/
                SingleChildScrollView(
                  padding: EdgeInsets.zero,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: constraints.maxHeight * 0.12,
                      ),
                      //title
                      const RegisterPetTitle(),
                      //image
                      Container(
                        height: constraints.maxWidth / 2.8,
                        width: constraints.maxWidth / 2.8,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: const RegisterPetAvatar(
                          index: null,
                        ),
                      ),
                      //nickname
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        child: CombinationTextField(
                          title: '暱稱',
                          isRequired: true,
                          child: NicknameTextField(
                            controller: _nickname,
                            focusNode: focusNodeNickname,
                          ),
                        ),
                      ),
                      //type
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        child: CombinationTextField(
                          title: '類型',
                          isRequired: true,
                          subheading: '選擇後無法更改',
                          child: AnimalTypeTextField(
                            controller: _animalType,
                            focusNode: focusNodeAnimalType,
                          ),
                        ),
                      ),
                      //gender
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 20),
                        child: CombinationTextField(
                          title: '性別',
                          isRequired: true,
                          child: PetGenderTextField(
                            controller: _gender,
                            focusNode: focusNodeGender,
                          ),
                        ),
                      ),
                      //birthday
                      Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 5, horizontal: 20),
                          child: CombinationTextField(
                            title: '生日',
                            isRequired: true,
                            child: PetBirthdayTextField(
                              focusNode: focusNodeBirthday,
                              controller: _birthday,
                            ),
                          )),
                      //add
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 40),
                        child: blueRectangleButton('完成', _register),
                      ),
                      //略過
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 40),
                        child: grayRectangleButton('略過', _skip),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  //註冊
  void _register() async {
    if (mounted) SVProgressHUD.show();
    if (await _judgmentData()) {
      return;
    }
    _memberPetVm!.setNickname(_nickname.text);
    _memberPetVm!.setHealthStatus(HealthStatus.healthy.index);
    if (Pet.petModel[0].mugshot.isNotEmpty &&
        !Pet.petModel[0].mugshot.contains(Member.memberModel.name)) {
      await _memberPetVm!.updatePetAvatar();
    }
    log('${Pet.petModel[0].toMap()}');
    Tuple<bool, String> r = await _memberPetVm!.addPet();
    if (mounted) SVProgressHUD.dismiss();
    if (r.i1!) {
      if (mounted) context.pushReplacement(RouteName.bottomNavigation);
    } else {
      await _showAlert(r.i2!);
    }
  }

  //略過
  void _skip() async {
    context.pushReplacement(RouteName.bottomNavigation);
  }

  //資料驗證
  Future<bool> _judgmentData() async {
    if (textFieldJudgment(_nickname) ||
        textFieldJudgment(_animalType) ||
        textFieldJudgment(_gender) ||
        textFieldJudgment(_birthday)) {
      if (textFieldJudgment(_nickname)) {
        return await _showAlert('請輸入暱稱');
      } else if (textFieldJudgment(_animalType)) {
        return await _showAlert('請選擇寵物類型');
      } else if (textFieldJudgment(_gender)) {
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

  //返回
  void _back() {
    context.pop();
  }
}
