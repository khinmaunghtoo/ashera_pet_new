import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/enum/member_status.dart';
import 'package:ashera_pet_new/model/member.dart';
import 'package:ashera_pet_new/view_model/member_pet.dart';
import 'package:ashera_pet_new/widget/edit_pet_profile/photo_for_identification.dart';
import 'package:ashera_pet_new/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/pet.dart';
import '../../dialog/cupertion_alert.dart';
import '../../model/member_pet.dart';
import '../../routes/route_name.dart';
import '../../utils/app_color.dart';
import '../../utils/app_image.dart';
import '../button.dart';
import '../register_pet/avatar.dart';
import '../time_line/app_widget/avatars.dart';

class EditPetProfileBody extends StatefulWidget {
  final BoxConstraints constraints;
  final TextEditingController aboutMe;
  final TextEditingController nickname;
  final TextEditingController animalType;
  final TextEditingController gender;
  final TextEditingController birthday;
  final TextEditingController healthStatus;

  const EditPetProfileBody(
      {super.key,
      required this.constraints,
      required this.aboutMe,
      required this.nickname,
      required this.animalType,
      required this.gender,
      required this.birthday,
      required this.healthStatus});

  @override
  State<StatefulWidget> createState() => _EditPetProfileBodyState();
}

class _EditPetProfileBodyState extends State<EditPetProfileBody> {
  BoxConstraints get constraints => widget.constraints;

  TextEditingController get _aboutMe => widget.aboutMe;
  TextEditingController get _nickname => widget.nickname;
  TextEditingController get _animalType => widget.animalType;
  TextEditingController get _gender => widget.gender;
  TextEditingController get _birthday => widget.birthday;
  TextEditingController get _healthStatus => widget.healthStatus;

  FocusNode focusNodeAbout = FocusNode();
  FocusNode focusNodeNickname = FocusNode();
  FocusNode focusNodeAnimalType = FocusNode();
  FocusNode focusNodeGender = FocusNode();
  FocusNode focusNodeBirthday = FocusNode();
  FocusNode focusNodeHealthStatus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //寵物選擇
        Container(
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: _petSelection(),
        ),
        Expanded(
            child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Consumer<MemberPetVm>(
            builder: (context, vm, _) {
              if (vm.petTotal == 0) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height - 150,
                  child: const Center(
                    child: Text(
                      '請先點左上角＋添加寵物',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                );
              } else {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      //寵物頭像與辨識用照片
                      _rowAvatar(),
                      //地圖按鈕
                      _moreButton(),
                      //關於我
                      _aboutMeWidget(),
                      //暱稱
                      _nicknameWidget(),
                      //寵物類型
                      //_animalTypeWidget(),
                      //性別
                      _genderWidget(),
                      //生日
                      _birthdayWidget(),
                      //狀態
                      _healthStatusWidget()
                    ],
                  ),
                );
              }
            },
          ),
        )),
      ],
    );
  }

  //寵物選擇
  Widget _petSelection() {
    return Consumer<MemberPetVm>(
      builder: (context, vm, _) {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          itemCount: vm.petTotal + 1,
          itemBuilder: (context, index) {
            if (index < vm.petTotal) {
              //log('index $index');
              return _petAvatar(Pet.petModel[index], index);
            }
            return _addPet();
          },
        );
      },
    );
  }

  //寵物頭像
  Widget _petAvatar(MemberPetModel data, int index) {
    return Consumer<MemberPetVm>(
      builder: (context, vm, _) {
        return Stack(
          fit: StackFit.loose,
          alignment: Alignment.center,
          children: [
            //頭像
            GestureDetector(
              onTap: () {
                MemberPetModel nowPet = Pet.petModel[vm.petTarget];
                if (nowPet.mugshot.isNotEmpty || nowPet.facePic.isNotEmpty) {
                  if (nowPet.mugshot.contains('files') ||
                      nowPet.mugshot.contains('data') ||
                      nowPet.mugshot.contains('storage') ||
                      nowPet.mugshot.contains('mobile') ||
                      nowPet.facePic.contains('files') ||
                      nowPet.facePic.contains('data') ||
                      nowPet.facePic.contains('storage') ||
                      nowPet.facePic.contains('mobile')) {
                    if (mounted) _showAlert('請先點擊完成儲存變更');
                    return;
                  } else {
                    vm.setTarget(index);
                  }
                } else {
                  vm.setTarget(index);
                }
              },
              child: Container(
                height: 80,
                width: 80,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: AppColor.button,
                        width: index == vm.petTarget ? 3 : 0)),
                child: Avatar.medium(user: MemberModel.fromMap(data.toMap())),
              ),
            ),
            //Ｘ
            if (Pet.petModel.isNotEmpty)
              Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () async {
                      //詢問框
                      bool? r = await showCupertinoAlert(
                          context: context,
                          title: '刪除寵物',
                          content: '確定要刪除此寵物嗎？',
                          cancel: true,
                          confirmation: true);
                      if (r) {
                        //刪除
                        vm.deletePet(index);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 1, vertical: 1),
                      decoration: BoxDecoration(
                          color: Colors.grey[400], shape: BoxShape.circle),
                      alignment: Alignment.center,
                      child: const Icon(
                        Icons.clear,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ))
          ],
        );
      },
    );
  }

  Widget _addPet() {
    return GestureDetector(
      onTap: () {
        Pet.petModel.add(MemberPetModel(
            id: 0,
            memberId: Member.memberModel.id,
            mugshot: '',
            nickname: '',
            aboutMe: '',
            age: 0,
            birthday: '',
            animalType: 0,
            gender: 0,
            healthStatus: 0,
            member: null,
            status: MemberStatus.ACTIVE));
        context.push(RouteName.addPetProfile);
      },
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 3),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2)),
        alignment: Alignment.center,
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }

  //寵物頭像與辨識用照片
  Widget _rowAvatar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_avatar(), _photoForIdentification()],
    );
  }

  //寵物頭像
  Widget _avatar() {
    return Consumer<MemberPetVm>(
      builder: (context, vm, _) {
        return Container(
          height: constraints.maxWidth / 2.5,
          width: constraints.maxWidth / 2.8,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: RegisterPetAvatar(
            index: vm.petTarget,
          ),
        );
      },
    );
  }

  //辨識用照片
  Widget _photoForIdentification() {
    return Consumer<MemberPetVm>(
      builder: (context, vm, _) {
        return Container(
            height: constraints.maxWidth / 2.5,
            width: constraints.maxWidth / 2.8,
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: PhotoForIdentification(
              index: vm.petTarget,
            ));
      },
    );
  }

  //關於我
  Widget _aboutMeWidget() {
    return CombinationTextField(
        title: '關於我',
        isRequired: false,
        child: AboutUserTextField(
          controller: _aboutMe,
          focusNode: focusNodeAbout,
        ));
  }

  //暱稱
  Widget _nicknameWidget() {
    return CombinationTextField(
        title: '暱稱',
        isRequired: false,
        child: NicknameTextField(
          focusNode: focusNodeNickname,
          controller: _nickname,
        ));
  }

  //寵物類型
  Widget _animalTypeWidget() {
    return CombinationTextField(
        title: '寵物類型',
        isRequired: false,
        subheading: '選擇後無法更改',
        child: AnimalTypeTextField(
          controller: _animalType,
          focusNode: focusNodeAnimalType,
        ));
  }

  //性別
  Widget _genderWidget() {
    return CombinationTextField(
        title: '性別',
        isRequired: false,
        child: PetGenderTextField(
          focusNode: focusNodeGender,
          controller: _gender,
        ));
  }

  //生日
  Widget _birthdayWidget() {
    return CombinationTextField(
        title: '生日',
        isRequired: false,
        child: PetBirthdayTextField(
          focusNode: focusNodeBirthday,
          controller: _birthday,
        ));
  }

  //狀態
  Widget _healthStatusWidget() {
    return CombinationTextField(
        title: '狀態',
        isRequired: false,
        child: HealthStatusTextField(
          focusNode: focusNodeHealthStatus,
          controller: _healthStatus,
        ));
  }

  Future<bool> _showAlert(String text) async {
    Future.delayed(const Duration(milliseconds: 1800),
        () => Navigator.of(context).pop(true));
    return await showCupertinoAlert(
        context: context, content: text, cancel: false, confirmation: false);
  }

  //地圖
  Widget _moreButton() {
    return SizedBox(
      width: 50,
      child: CircleButton(
        iconData: AppImage.iconMap,
        callback: () => context.push(RouteName.editPetMap),
      ),
    );
  }
}
