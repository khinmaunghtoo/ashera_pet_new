import 'dart:developer';

import 'package:ashera_pet_new/data/pet.dart';
import 'package:ashera_pet_new/enum/gender.dart';
import 'package:ashera_pet_new/enum/health_status.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/view_model/member_pet.dart';
import 'package:ashera_pet_new/widget/edit_pet_profile/body.dart';
import 'package:ashera_pet_new/widget/system_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../data/member.dart';
import '../../../dialog/cupertion_alert.dart';
import '../../../model/tuple.dart';
import '../../../widget/edit_pet_profile/title.dart';

class EditPetProfile extends StatefulWidget {
  const EditPetProfile({super.key});

  @override
  State<StatefulWidget> createState() => _EditPetProfileState();
}

class _EditPetProfileState extends State<EditPetProfile> {
  MemberPetVm? _petVm;
  final TextEditingController _aboutMe = TextEditingController();
  final TextEditingController _nickname = TextEditingController();
  final TextEditingController _animalType = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _birthday = TextEditingController();
  final TextEditingController _healthStatus = TextEditingController();

  _onLayoutDone(_) {
    log('總寵物：${_petVm!.petTotal}');
    if (_petVm!.petTotal != 0) {
      _aboutMe.text = Pet.petModel[0].aboutMe;
      _nickname.text = Pet.petModel[0].nickname;
      _gender.text = GenderEnum.values[Pet.petModel[0].gender].zh;
      _birthday.text = Pet.petModel[0].birthday;
      _healthStatus.text = HealthStatus.values[Pet.petModel[0].healthStatus].zh;
      _petVm!.setTarget(0);
    }
    _petVm!.addListener(_petVmListener);
  }

  void _petVmListener() {
    log('PetVmListener:${_petVm!.petTotal}');
    if (Pet.petModel.isEmpty) {
      _aboutMe.clear();
      _nickname.clear();
      _gender.clear();
      _birthday.clear();
      _healthStatus.clear();
      setState(() {});
    } else {
      _aboutMe.text = Pet.petModel[_petVm!.petTarget].aboutMe;
      _nickname.text = Pet.petModel[_petVm!.petTarget].nickname;
      _gender.text =
          GenderEnum.values[Pet.petModel[_petVm!.petTarget].gender].zh;
      _birthday.text = Pet.petModel[_petVm!.petTarget].birthday;
      _healthStatus.text =
          HealthStatus.values[Pet.petModel[_petVm!.petTarget].healthStatus].zh;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
  }

  @override
  void dispose() {
    _petVm!.removeListener(_petVmListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _petVm = Provider.of<MemberPetVm>(context, listen: false);
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
                EditPetProfileTitle(
                  callback: _back,
                  doneCallBack: _done,
                ),
                Expanded(
                    child: EditPetProfileBody(
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

  //完成
  void _done() async {
    if (Pet.petModel.isEmpty) {
      if (mounted) context.pop();
      return;
    }
    if (await _judgmentData()) {
      return;
    }
    if (mounted) SVProgressHUD.show();

    _petVm!.setNickname(_nickname.text, _petVm!.petTarget);
    if (_aboutMe.text.isNotEmpty) {
      _petVm!.setAboutMe(_aboutMe.text, _petVm!.petTarget);
    }
    //上傳頭像
    if (Pet.petModel[_petVm!.petTarget].mugshot.isNotEmpty &&
        !Pet.petModel[_petVm!.petTarget].mugshot
            .contains(Member.memberModel.name)) {
      await _petVm!.updatePetAvatar(_petVm!.petTarget);
    }
    //上傳辨識照片
    if (Pet.petModel[_petVm!.petTarget].facePic.isNotEmpty &&
        !Pet.petModel[_petVm!.petTarget].facePic
            .contains(Member.memberModel.name)) {
      Tuple<bool, String> value =
          await _petVm!.updatePetFacePic(_petVm!.petTarget);
      if (!value.i1!) {
        await _showAlert(value.i2!);
        return;
      }
    }

    await _petVm!.updatePet(_petVm!.petTarget);

    if (mounted) SVProgressHUD.dismiss();

    await _showAlert('修改完成\n待平台審核後，將為您上傳');

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
    Future.delayed(const Duration(milliseconds: 2000),
        () => Navigator.of(context).pop(true));
    return await showCupertinoAlert(
        context: context, content: text, cancel: false, confirmation: false);
  }
}
