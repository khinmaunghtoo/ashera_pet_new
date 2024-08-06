import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/widget/adopt_record/record_data/report_data_body.dart';
import 'package:flutter/material.dart';

import 'data_title.dart';

class ReportData extends StatefulWidget {
  const ReportData({super.key});

  @override
  State<StatefulWidget> createState() => _ReportDataState();
}

class _ReportDataState extends State<ReportData> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.appBackground,
      body: Column(
        children: [
          //title
          DataTitle(),
          //body
          Expanded(child: ReportDataBody())
        ],
      ),
    );
  }
}
