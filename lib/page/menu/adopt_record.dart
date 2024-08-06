import 'package:ashera_pet_new/widget/adopt_record/title.dart';
import 'package:flutter/material.dart';

import '../../utils/app_color.dart';
import '../../widget/adopt_record/body.dart';

class AdoptRecordPage extends StatefulWidget {
  const AdoptRecordPage({super.key});

  @override
  State<StatefulWidget> createState() => _AdoptRecordPageState();
}

class _AdoptRecordPageState extends State<AdoptRecordPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.appBackground,
      body: Column(
        children: [
          //title
          AdoptRecordTitle(),
          //body
          Expanded(child: AdoptRecordBody())
        ],
      ),
    );
  }
}
