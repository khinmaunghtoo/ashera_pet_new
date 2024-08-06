import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/widget/identification_list/body.dart';
import 'package:ashera_pet_new/widget/identification_list/title.dart';
import 'package:ashera_pet_new/widget/system_back.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../model/face_detect.dart';

class IdentificationList extends StatefulWidget {
  final List<FaceDetectResponseModel> data;
  const IdentificationList({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => _IdentificationListState();
}

class _IdentificationListState extends State<IdentificationList> {
  List<FaceDetectResponseModel> get data => widget.data;

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
                IdentificationListTitle(callback: _back),
                Expanded(
                    child: IdentificationListBody(
                  data: data,
                )),
              ],
            ),
          );
        },
      ),
    ));
  }

  //返回
  void _back() {
    context.pop();
  }
}
