import 'dart:developer';

import 'package:ashera_pet_new/view_model/adopt_report_vm.dart';
import 'package:ashera_pet_new/widget/adopt_record/body/reported_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Reported extends StatefulWidget {
  const Reported({super.key});

  @override
  State<StatefulWidget> createState() => _ReportedState();
}

class _ReportedState extends State<Reported> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Consumer<AdoptReportVm>(
        builder: (context, vm, _) {
          if (vm.recordTarget.isNotEmpty) {
            log('recordTarget: ${vm.recordTarget.length}');
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                log('${vm.recordTarget[index].toMap()}');
                return ReportedItem(
                  model: vm.recordTarget[index],
                );
              },
              itemCount: vm.recordTarget.length,
            );
          } else {
            return _noData();
          }
        },
      ),
    );
  }

  Widget _noData() {
    return Container(
      alignment: Alignment.center,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.report_outlined,
            color: Colors.white,
            size: 50,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '尚未收到任何檢舉',
            style: TextStyle(fontSize: 20, color: Colors.white),
          )
        ],
      ),
    );
  }
}
