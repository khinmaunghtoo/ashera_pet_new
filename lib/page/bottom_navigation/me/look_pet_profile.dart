import 'package:ashera_pet_new/model/member_pet.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/widget/system_back.dart';
import 'package:flutter/material.dart';

import '../../../widget/look_pet_profile/body.dart';
import '../../../widget/look_pet_profile/title.dart';

class LookPetProfilePage extends StatefulWidget {
  final MemberPetModel pet;
  const LookPetProfilePage({super.key, required this.pet});

  @override
  State<StatefulWidget> createState() => _LookPetProfilePageState();
}

class _LookPetProfilePageState extends State<LookPetProfilePage> {
  MemberPetModel get pet => widget.pet;

  @override
  Widget build(BuildContext context) {
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
                LookPetProfileTitle(title: pet.nickname),
                //body
                Expanded(child: LookPetProfileBody(pet: pet)),
              ],
            ),
          );
        },
      ),
    ));
  }
}
