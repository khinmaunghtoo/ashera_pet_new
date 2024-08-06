import 'package:flutter/cupertino.dart';

import '../register_member/avatar.dart';
import '../text_field.dart';

class EditUserProfileBody extends StatefulWidget {
  final BoxConstraints constraints;
  final TextEditingController aboutMe;
  final TextEditingController nickname;
  final TextEditingController gender;
  final TextEditingController birthday;

  const EditUserProfileBody(
      {super.key,
      required this.constraints,
      required this.aboutMe,
      required this.nickname,
      required this.gender,
      required this.birthday});

  @override
  State<StatefulWidget> createState() => _EditUserProfileBodyState();
}

class _EditUserProfileBodyState extends State<EditUserProfileBody> {
  BoxConstraints get constraints => widget.constraints;

  FocusNode focusNodeAbout = FocusNode();
  FocusNode focusNodeNickname = FocusNode();
  FocusNode focusNodeGender = FocusNode();
  FocusNode focusNodeBirthday = FocusNode();

  TextEditingController get _aboutMe => widget.aboutMe;
  TextEditingController get _nickname => widget.nickname;
  TextEditingController get _gender => widget.gender;
  TextEditingController get _birthday => widget.birthday;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            //asher主人
            _avatar(),
            //暱稱
            CombinationTextField(
              title: '暱稱',
              isRequired: false,
              child: NicknameTextField(
                focusNode: focusNodeNickname,
                controller: _nickname,
              ),
            ),
            //性別
            CombinationTextField(
                title: '性別',
                isRequired: false,
                child: GenderTextField(
                  focusNode: focusNodeGender,
                  controller: _gender,
                )),
            //生日
            CombinationTextField(
              title: '生日',
              isRequired: false,
              child: BirthdayTextField(
                focusNode: focusNodeBirthday,
                controller: _birthday,
              ),
            ),
            CombinationTextField(
                title: '關於我',
                isRequired: false,
                child: AboutUserTextField(
                  controller: _aboutMe,
                  focusNode: focusNodeAbout,
                ))
          ],
        ),
      ),
    );
  }

  //主人
  Widget _avatar() {
    return Container(
      height: constraints.maxWidth / 2.8,
      width: constraints.maxWidth / 2.8,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: const RegisterMemberAvatar(),
    );
  }
}
