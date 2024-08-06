import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/material.dart';

import '../../../../model/member_pet.dart';
import '../../../../widget/other_member_pets/body.dart';
import '../../../../widget/other_member_pets/title.dart';

class OtherMemberPets extends StatefulWidget {
  final List<MemberPetModel> pets;
  const OtherMemberPets({super.key, required this.pets});

  @override
  State<StatefulWidget> createState() => _OtherMemberPetsState();
}

class _OtherMemberPetsState extends State<OtherMemberPets> {
  List<MemberPetModel> get pets => widget.pets;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                const OtherMemberPetsTitle(),
                Expanded(
                    child: OtherMemberPetsBody(
                  pets: pets,
                ))
              ],
            ),
          );
        },
      ),
    );
  }
}
