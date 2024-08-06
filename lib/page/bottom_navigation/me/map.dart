import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../widget/edit_pet_map/body.dart';
import '../../../widget/map/title.dart';

class EditPetMapPage extends StatelessWidget{
  const EditPetMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.appBackground,
      body: Column(
        children: [
          //title
          MapTitle(),
          //body
          Expanded(child: EditPetMapBody()),
        ],
      ),
    );
  }
}