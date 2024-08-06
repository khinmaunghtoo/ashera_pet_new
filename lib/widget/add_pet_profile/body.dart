import 'package:flutter/cupertino.dart';

import '../../data/pet.dart';
import '../text_field.dart';

class AddPetProfileBody extends StatefulWidget{
  final BoxConstraints constraints;
  final TextEditingController aboutMe;
  final TextEditingController nickname;
  final TextEditingController animalType;
  final TextEditingController gender;
  final TextEditingController birthday;
  final TextEditingController healthStatus;

  const AddPetProfileBody({
    super.key,
    required this.constraints,
    required this.aboutMe,
    required this.nickname,
    required this.animalType,
    required this.gender,
    required this.birthday,
    required this.healthStatus
  });

  @override
  State<StatefulWidget> createState() => _AddPetProfileBodyState();
}

class _AddPetProfileBodyState extends State<AddPetProfileBody>{

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
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            //關於我
            _aboutMeWidget(),
            //暱稱
            _nicknameWidget(),
            //寵物類型
            _animalTypeWidget(),
            //性別
            _genderWidget(),
            //生日
            _birthdayWidget(),
            //狀態
            _healthStatusWidget()
          ],
        ),
      ),
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
          index: Pet.petModel.length - 1,
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
          index: Pet.petModel.length - 1,
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
          index: Pet.petModel.length - 1,
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

}