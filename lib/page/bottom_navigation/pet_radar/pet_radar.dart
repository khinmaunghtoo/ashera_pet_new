import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/widget/assist_in_pet_hunting/title.dart';
import 'package:flutter/material.dart';

import '../../../widget/assist_in_pet_hunting/body.dart';
import '../../../widget/system_back.dart';

// 寵物雷達
class PetRadarPage extends StatefulWidget {
  const PetRadarPage({super.key});

  @override
  State<StatefulWidget> createState() => _PetRadarPageState();
}

class _PetRadarPageState extends State<PetRadarPage> {
  @override
  Widget build(BuildContext context) {
    return SystemBack(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.appBackground,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              width: constraints.maxWidth,
              child: const Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  PetRadarTitle(),
                  Expanded(
                    child: PetRadarBody(),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
