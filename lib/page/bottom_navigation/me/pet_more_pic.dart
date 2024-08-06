import 'package:ashera_pet_new/widget/pet_more_pic/title.dart';
import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../widget/pet_more_pic/body.dart';
import '../../../widget/system_back.dart';

class PetMorePicPage extends StatelessWidget {
  const PetMorePicPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SystemBack(
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: AppColor.appBackground,
          body: Column(
            children: [
              //title
              PetMorePicTitle(),
              //body
              Expanded(child: PetMorePicBody())
            ],
          )),
    );
  }
}
