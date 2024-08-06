import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/widget/adopt_record/record_data/data_title.dart';
import 'package:ashera_pet_new/widget/adopt_record/record_data/reported_data_body.dart';
import 'package:flutter/material.dart';

class ReportedData extends StatefulWidget {
  const ReportedData({super.key});

  @override
  State<StatefulWidget> createState() => _ReportedDataState();
}

class _ReportedDataState extends State<ReportedData> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.appBackground,
      body: Column(
        children: [
          //title
          DataTitle(),
          //body
          Expanded(child: ReportedDataBody()),
        ],
      ),
    );
  }
}
