import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/enum/gender.dart';
import 'package:ashera_pet_new/model/follower.dart';
import 'package:ashera_pet_new/model/member.dart';
import 'package:ashera_pet_new/model/member_pet.dart';
import 'package:ashera_pet_new/widget/button.dart';
import 'package:ashera_pet_new/widget/time_line/app_widget/avatars.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../enum/health_status.dart';
import '../../utils/app_color.dart';
import '../../utils/utils.dart';
import '../../view_model/follower.dart';

class IdentificationResultBody extends StatefulWidget {
  final MemberPetModel data;
  const IdentificationResultBody({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => _IdentificationResultBodyState();
}

class _IdentificationResultBodyState extends State<IdentificationResultBody> {
  MemberPetModel get data => widget.data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //寵物相關
        _petImgAndName(),
        //框(寵物資料與主人)
        _petDataAndOwner(),
        //按鈕
        _buttonRow()
      ],
    );
  }

  //寵物相關
  Widget _petImgAndName() {
    return Column(
      children: [
        //照片
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: Center(
            child: Avatar.huge(user: MemberModel.fromMap(data.toMap())),
          ),
        ),
        //名稱
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          child: Text(
            data.nickname,
            style: const TextStyle(
                color: AppColor.textFieldTitle,
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
        ),
        //UID
        /*Padding(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'ID : ',
                  style: TextStyle(
                    color: AppColor.textFieldTitle,
                    fontSize: 18
                  )
                ),
                TextSpan(
                  text: 'ABC456456',
                    style: TextStyle(
                        color: AppColor.textFieldTitle,
                        fontSize: 18
                    )
                )
              ]
            )
          ),
        )*/

        const SizedBox(
          height: 20,
        )
      ],
    );
  }

  //框(寵物資料與主人)
  Widget _petDataAndOwner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      decoration: BoxDecoration(
          color: AppColor.textFieldUnSelect,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          //關於我
          _aboutPet(),
          //性別
          _gender(),
          //年齡
          _age(),
          //狀態
          _healthStatus(),
          //Ashera主人
          //_asheraOwner()
        ],
      ),
    );
  }

  Widget _aboutPet() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '關於我',
          style: TextStyle(color: AppColor.textFieldTitle, fontSize: 16),
        ),
        Container(
          height: 105,
          alignment: Alignment.center,
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          decoration: BoxDecoration(
              border: Border.all(color: AppColor.textFieldHintText, width: 1),
              borderRadius: BorderRadius.circular(5)),
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            child: Text(
              data.aboutMe,
              style:
                  const TextStyle(fontSize: 15, color: AppColor.textFieldTitle),
            ),
          ),
        )
      ],
    );
  }

  Widget _gender() {
    return Row(
      children: [
        Text.rich(TextSpan(children: [
          const TextSpan(
              text: '性別   ',
              style: TextStyle(
                  color: AppColor.textFieldTitle, fontSize: 16, height: 1.1)),
          TextSpan(
              text: GenderEnum.values[data.gender].petZh,
              style: const TextStyle(
                  color: AppColor.textFieldTitle,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.1))
        ])),
        const SizedBox(
          width: 5,
        ),
        Utils.genderIcon(data.gender)
      ],
    );
  }

  Widget _age() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text.rich(TextSpan(children: [
            const TextSpan(
                text: '年齡   ',
                style: TextStyle(
                    color: AppColor.textFieldTitle, fontSize: 16, height: 1.1)),
            TextSpan(
                text: '${Utils.getPetAge(data.birthday)}',
                style: const TextStyle(
                    color: AppColor.textFieldTitle,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.1))
          ]))
        ],
      ),
    );
  }

  Widget _healthStatus() {
    return Row(
      children: [
        Text.rich(TextSpan(children: [
          const TextSpan(
              text: '狀態   ',
              style: TextStyle(
                  color: AppColor.textFieldTitle, fontSize: 16, height: 1.1)),
          TextSpan(
              text: HealthStatus.values[data.healthStatus].zh,
              style: const TextStyle(
                  color: AppColor.textFieldTitle,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.1))
        ]))
      ],
    );
  }

  Widget _buttonRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
      child: Consumer<FollowerVm>(
        builder: (context, vm, _) {
          if (data.memberId == Member.memberModel.id) {
            return Row(
              children: [
                //Expanded(child: blueRectangleButton('這是自己', (){})),
                //const SizedBox(width: 20,),
                Expanded(child: grayRectangleButton('離開', _doNotTrackOnTap))
              ],
            );
          } else if (vm.myFollowerList
              .where((element) => element.followerId == data.memberId)
              .isNotEmpty) {
            return Row(
              children: [
                Expanded(child: blueRectangleButton('已追蹤對方', () {})),
                const SizedBox(
                  width: 20,
                ),
                Expanded(child: grayRectangleButton('離開', _doNotTrackOnTap))
              ],
            );
          } else {
            return Row(
              children: [
                Expanded(
                    child: blueRectangleButton('追蹤', () => _sendFollower(vm))),
                const SizedBox(
                  width: 20,
                ),
                Expanded(child: grayRectangleButton('離開', _doNotTrackOnTap))
              ],
            );
          }
        },
      ),
    );
  }

  //不追蹤
  void _doNotTrackOnTap() {
    context.pop();
  }

  void _sendFollower(FollowerVm vm) {
    AddFollowerRequestDTO dto = AddFollowerRequestDTO(
        followerId: data.memberId, memberId: Member.memberModel.id);
    vm.sendFollowerRequest(dto);
  }
}
