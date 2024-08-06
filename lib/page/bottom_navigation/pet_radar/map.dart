import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../widget/map/body.dart';
import '../../../widget/map/title.dart';

class MapPage extends StatelessWidget{
  const MapPage({super.key});

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
          Expanded(child: MapBody())
        ],
      ),
    );
  }
}