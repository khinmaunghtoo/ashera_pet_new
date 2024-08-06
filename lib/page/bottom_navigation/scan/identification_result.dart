import 'package:ashera_pet_new/model/member_pet.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/widget/system_back.dart';
import 'package:flutter/material.dart';

import '../../../widget/identification_result/body.dart';
import '../../../widget/identification_result/title.dart';

class IdentificationResult extends StatefulWidget {
  final MemberPetModel data;
  const IdentificationResult({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => _IdentificationResultState();
}

class _IdentificationResultState extends State<IdentificationResult> {
  MemberPetModel get data => widget.data;

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
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //title
                const IdentificationResultTitle(),
                Expanded(child: IdentificationResultBody(data: data))
              ],
            ),
          );
        },
      ),
    ));
  }
}
