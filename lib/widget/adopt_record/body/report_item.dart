import 'package:ashera_pet_new/routes/route_name.dart';
import 'package:ashera_pet_new/utils/api.dart';
import 'package:ashera_pet_new/utils/utils.dart';
import 'package:ashera_pet_new/view_model/adopt_report_vm.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../enum/adopt_status.dart';
import '../../../model/add_adopt_record_dto.dart';
import '../../../model/member.dart';
import '../../../model/tuple.dart';
import '../../../utils/app_color.dart';

class ReportItem extends StatefulWidget {
  final AdoptRecordModel model;
  const ReportItem({super.key, required this.model});

  @override
  State<StatefulWidget> createState() => _ReportItemState();
}

class _ReportItemState extends State<ReportItem> {
  AdoptRecordModel get model => widget.model;

  late Future<MemberModel> _member;

  Future<MemberModel> _getMember() async {
    Tuple<bool, String> r = await Api.getMemberData(model.targetMemberId);
    return MemberModel.fromJson(r.i2!);
  }

  @override
  void initState() {
    super.initState();
    _member = _getMember();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _member,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Consumer<AdoptReportVm>(
              builder: (context, vm, _) {
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    vm.setNowRecordId(model.id);
                    context.push(RouteName.adoptRecordData);
                  },
                  child: Container(
                    height: 70,
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                        color: AppColor.textFieldUnSelect,
                        borderRadius: BorderRadius.circular(10)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.mail,
                          size: 30,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        //你檢舉了 memberName
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _name(snapshot.data!.nickname),
                            _status(model.status)
                          ],
                        ),
                        Expanded(child: Container()),
                        //日期 2024.3.13
                        Container(
                          alignment: Alignment.center,
                          child: Text(
                            Utils.adoptReportDate(model.updatedAt),
                            style: const TextStyle(
                                color: AppColor.loveContentDateColor,
                                fontSize: 16),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          default:
            return _loadingWidget();
        }
      },
    );
  }

  Widget _loadingWidget() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: const CircularProgressIndicator(),
    );
  }

  Widget _name(String name) {
    return Text.rich(TextSpan(
        text: '你檢舉了',
        style: const TextStyle(color: Colors.white, fontSize: 18),
        children: [
          TextSpan(
            text: name,
            style: const TextStyle(
                color: Colors.white,
                decoration: TextDecoration.underline,
                fontSize: 18),
          )
        ]));
  }

  Widget _status(ComplaintRecordStatus status) {
    return Text.rich(
      TextSpan(
          text: '(',
          style: TextStyle(color: status.color, fontSize: 18),
          children: [
            TextSpan(
              text: status.zh,
              style: TextStyle(color: status.color, fontSize: 18),
            ),
            TextSpan(
              text: ')',
              style: TextStyle(color: status.color, fontSize: 18),
            ),
          ]),
    );
  }
}
