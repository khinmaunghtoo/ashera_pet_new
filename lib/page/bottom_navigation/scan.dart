import 'package:ashera_pet_new/widget/scan/body.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_color.dart';
import '../../widget/scan/title.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<StatefulWidget> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.appBackground,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //title
            ScanTitle(
              title: '寵物辨識',
              callback: _back,
            ),
            const Expanded(child: ScanBody()),
          ],
        ));
  }

  void _back() {
    context.pop();
  }
}
