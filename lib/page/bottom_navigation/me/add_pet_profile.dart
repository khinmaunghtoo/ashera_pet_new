import 'dart:developer';

import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/widget/system_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/pet.dart';
import '../../../dialog/cupertion_alert.dart';
import '../../../enum/health_status.dart';
import '../../../model/tuple.dart';
import '../../../view_model/member_pet.dart';
import '../../../widget/add_pet_profile/body.dart';
import '../../../widget/add_pet_profile/title.dart';

class AddPetProfile extends StatefulWidget {
  const AddPetProfile({super.key});

  @override
  State<StatefulWidget> createState() => _AddPetProfileState();
}

class _AddPetProfileState extends State<AddPetProfile> {
  MemberPetVm? _petVm;

  final TextEditingController _aboutMe = TextEditingController();
  final TextEditingController _nickname = TextEditingController();
  final TextEditingController _animalType = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _birthday = TextEditingController();
  final TextEditingController _healthStatus = TextEditingController();

  _onLayoutDone(_) {
    for (var element in Pet.petModel) {
      log('Pet: ${element.toMap()}');
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
  }

  @override
  Widget build(BuildContext context) {
    _petVm = Provider.of<MemberPetVm>(context);
    return SystemBack(
        child: Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.appBackground,
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
                AppPetProfileTitle(
                  callback: _back,
                  doneCallBack: _done,
                ),
                Expanded(
                    child: AddPetProfileBody(
                  constraints: constraints,
                  aboutMe: _aboutMe,
                  nickname: _nickname,
                  animalType: _animalType,
                  gender: _gender,
                  birthday: _birthday,
                  healthStatus: _healthStatus,
                ))
              ],
            ),
          );
        },
      ),
    ));
  }

  //返回
  void _back() async {
    await _petVm!.getPet();
    if (mounted) context.pop();
  }

  //新增
  void _done() async {
    if (await _judgmentData()) {
      return;
    }
    if (mounted) SVProgressHUD.show();

    _petVm!.setNickname(_nickname.text, Pet.petModel.length - 1);
    _petVm!.setAboutMe(_aboutMe.text, Pet.petModel.length - 1);
    _petVm!.setHealthStatus(
        HealthStatus.values
            .where((element) => element.zh == _healthStatus.text)
            .first
            .index,
        Pet.petModel.length - 1);
    log('${Pet.petModel[Pet.petModel.length - 1].toMap()}');
    Tuple<bool, String> r = await _petVm!.addPet(Pet.petModel.length - 1);
    _petVm!.getPet();

    if (mounted) SVProgressHUD.dismiss();
    if (r.i1!) {
      if (mounted) context.pop();
    } else {
      await _showAlert(r.i2!);
    }
  }

  //資料判斷
  Future<bool> _judgmentData() async {
    if (_nickname.text.trim().isEmpty) {
      return await _showAlert('暱稱不可為空');
    }
    if (_animalType.text.trim().isEmpty) {
      return await _showAlert('請選擇寵物類型');
    }
    if (_gender.text.trim().isEmpty) {
      return await _showAlert('請選擇寵物性別');
    }
    if (_birthday.text.trim().isEmpty) {
      return await _showAlert('請選擇寵物生日');
    }
    if (_healthStatus.text.trim().isEmpty) {
      return await _showAlert('請選擇寵物狀態');
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
