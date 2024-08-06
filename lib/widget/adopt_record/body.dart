import 'package:ashera_pet_new/enum/adopt_report.dart';
import 'package:ashera_pet_new/view_model/adopt_report_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../data/member.dart';
import '../../utils/app_color.dart';
import 'body/report.dart';
import 'body/reported.dart';

class AdoptRecordBody extends StatefulWidget {
  const AdoptRecordBody({super.key});

  @override
  State<StatefulWidget> createState() => _AdoptRecordBodyState();
}

class _AdoptRecordBodyState extends State<AdoptRecordBody> {
  AdoptReportVm? _adoptReportVm;

  late PageController _controller;

  //檢舉、被檢舉
  final List<Widget> _children = [const Report(), const Reported()];

  _onLayoutDone(_) {
    //領養檢舉
    _adoptReportVm!.initAdoptReportType();
    _adoptReportVm!.getAdoptReportRecordByFromAndTarget(Member.memberModel.id);
    _adoptReportVm!.setPageController(_controller);
  }

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
  }

  @override
  Widget build(BuildContext context) {
    _adoptReportVm = Provider.of(context, listen: false);
    return Column(
      children: [
        //tab_button
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: _tabButton(AdoptReportType.adoptReport)),
              const SizedBox(
                width: 20,
              ),
              Expanded(child: _tabButton(AdoptReportType.adoptReported))
            ],
          ),
        ),
        //pageView
        Expanded(
            child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: _controller,
          children: _children,
        ))
      ],
    );
  }

  Widget _tabButton(AdoptReportType value) {
    return Consumer<AdoptReportVm>(
      builder: (context, vm, _) {
        return GestureDetector(
          onTap: () => vm.setAdoptReportType(value),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            decoration: BoxDecoration(
                color: value != vm.adoptReportType
                    ? AppColor.textFieldUnSelect
                    : AppColor.button,
                borderRadius: BorderRadius.circular(10)),
            child: Text(
              value.zh,
              style: const TextStyle(
                  color: AppColor.textFieldTitle, fontSize: 15, height: 1.1),
            ),
          ),
        );
      },
    );
  }
}
