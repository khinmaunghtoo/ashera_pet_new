import 'package:ashera_pet_new/view_model/adopt_report_vm.dart';
import 'package:ashera_pet_new/widget/adopt_record/body/report_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Report extends StatefulWidget {
  const Report({super.key});

  @override
  State<StatefulWidget> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Consumer<AdoptReportVm>(
        builder: (context, vm, _) {
          if (vm.recordFrom.isNotEmpty) {
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return ReportItem(
                  model: vm.recordFrom[index],
                );
              },
              itemCount: vm.recordFrom.length,
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
            '尚未檢舉任何內容',
            style: TextStyle(fontSize: 20, color: Colors.white),
          )
        ],
      ),
    );
  }
}
