import 'package:ashera_pet_new/enum/gender.dart';
import 'package:ashera_pet_new/enum/health_status.dart';
import 'package:ashera_pet_new/model/member_pet.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../model/hero_view_params.dart';
import '../../model/member.dart';
import '../../routes/route_name.dart';
import '../../utils/app_color.dart';
import '../time_line/app_widget/avatars.dart';

class LookPetProfileBody extends StatefulWidget {
  final MemberPetModel pet;
  const LookPetProfileBody({super.key, required this.pet});

  @override
  State<StatefulWidget> createState() => _LookPetProfileBodyState();
}

class _LookPetProfileBodyState extends State<LookPetProfileBody> {
  MemberPetModel get pet => widget.pet;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            child: SingleChildScrollView(
          padding: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                //寵物頭像
                GestureDetector(
                  onTap: () => context.push(RouteName.netWorkImageHeroView,
                      extra: HeroViewParamsModel(
                          tag: 'Avatar_${pet.id}',
                          data: pet.mugshot,
                          index: 0)),
                  child: Avatar.huge(user: MemberModel.fromMap(pet.toMap())),
                ),
                //關於我
                _itemBodyMultiLineWidget('關於我', pet.aboutMe),
                //暱稱
                _itemBodyWidget('暱稱', pet.nickname),
                //性別
                _itemBodyWidget('性別', GenderEnum.values[pet.gender].zh),
                //生日
                _itemBodyWidget('生日', pet.birthday),
                //狀態
                _itemBodyWidget('狀態', HealthStatus.values[pet.healthStatus].zh),
              ],
            ),
          ),
        ))
      ],
    );
  }

  Widget _itemBodyWidget(String title, String value) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 50,
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: AppColor.textFieldUnSelect,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    color: AppColor.textFieldUnSelectBorder, width: 1)),
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }

  //多行
  Widget _itemBodyMultiLineWidget(String title, String value) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 10),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: Colors.white),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 120,
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                color: AppColor.textFieldUnSelect,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                    color: AppColor.textFieldUnSelectBorder, width: 1)),
            child: Text(
              value,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}
