import 'package:flutter/material.dart';

import '../../../utils/app_color.dart';
import '../../../widget/like/body.dart';
import '../../../widget/like/title.dart';
import '../../../widget/system_back.dart';

class LikePage extends StatelessWidget{
  const LikePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SystemBack(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.appBackground,
        body: Column(
          children: [
            //title
            LikeTitle(),
            //body
            Expanded(child: LikeBody())
          ],
        ),
      ),
    );
  }
}