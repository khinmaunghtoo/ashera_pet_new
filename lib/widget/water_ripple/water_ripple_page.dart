import 'package:ashera_pet_new/model/member.dart';
import 'package:ashera_pet_new/widget/time_line/app_widget/avatars.dart';
import 'package:ashera_pet_new/widget/water_ripple/water_ripple.dart';
import 'package:flutter/material.dart';

import '../../data/pet.dart';
import '../../utils/app_color.dart';

class WaterRipplePage extends StatefulWidget {
  const WaterRipplePage({super.key});

  @override
  State<StatefulWidget> createState() => _WaterRipplePageState();
}

class _WaterRipplePageState extends State<WaterRipplePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColor.appBackground,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '搜尋附近寵物中...',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          const SizedBox(
            height: 20,
          ),
          Stack(
            alignment: Alignment.center,
            fit: StackFit.loose,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width,
                child: WaterRipple(
                  count: 5,
                  color: Colors.grey[700]!,
                ),
              ),
              if (Pet.petModel.isNotEmpty)
                Avatar.big(
                    user: MemberModel.fromMap(Pet.petModel.first.toMap())),
              if (Pet.petModel.isEmpty)
                const Avatar.big(
                    user: MemberModel(
                  id: 0,
                  name: '',
                  nickname: '',
                  birthday: '',
                  aboutMe: '',
                  age: 0,
                  cellphone: '',
                  gender: 1,
                  mugshot: '',
                )),
            ],
          )
        ],
      ),
    );
  }
}
