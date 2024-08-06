import 'package:ashera_pet_new/model/member_pet.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/material.dart';

import '../../../widget/pet_magazine_content/body.dart';
import '../../../widget/pet_magazine_content/title.dart';
import '../../../widget/system_back.dart';

class PetMagazineContentPage extends StatelessWidget {
  final MemberPetModel pet;
  const PetMagazineContentPage({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return SystemBack(
      child: Scaffold(
        backgroundColor: AppColor.appBackground,
        body: Column(
          children: [
            //title
            PetMagazineContentTitle(
              petId: pet.id,
              petNickname: pet.nickname,
            ),
            //body
            Expanded(
                child: PetMagazineContentBody(
              pet: pet,
            ))
          ],
        ),
      ),
    );
  }
}
