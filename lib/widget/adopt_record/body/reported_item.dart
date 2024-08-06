import 'dart:developer';

import 'package:ashera_pet_new/model/add_adopt_record_dto.dart';
import 'package:ashera_pet_new/utils/api.dart';
import 'package:ashera_pet_new/view_model/adopt_report_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../dialog/alert.dart';
import '../../../enum/adopt_status.dart';
import '../../../model/member.dart';
import '../../../model/tuple.dart';
import '../../../utils/app_color.dart';
import '../../../utils/utils.dart';
import '../../yellow_exclamation_mark_icon.dart';

class ReportedItem extends StatefulWidget {
  final AdoptRecordModel model;
  const ReportedItem({super.key, required this.model});

  @override
  State<StatefulWidget> createState() => _ReportedItemState();
}

class _ReportedItemState extends State<ReportedItem> {
  AdoptRecordModel get model => widget.model;

  late Future<MemberModel> _member;

  Future<MemberModel> _getMember() async {
    Tuple<bool, String> r = await Api.getMemberData(model.fromMemberId);
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
                      log('哪則檢舉：${model.toMap()}');
                      //context.push(RouteName.adoptedRecordData);
                      //被檢舉
                      Alert.showReplyReportAlert(context, model);
                    },
                    child: Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: AppColor.textFieldUnSelect,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const YellowExclamationMarkIcon(),
                          const SizedBox(
                            width: 10,
                          ),
                          //你檢舉了 memberName
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _name(),
                              _status(),
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
        });
  }

  Widget _loadingWidget() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: const CircularProgressIndicator(),
    );
  }

  Widget _name() {
    return const Text.rich(TextSpan(
        text: '你被',
        style: TextStyle(color: Colors.white, fontSize: 18),
        children: [
          TextSpan(
            text: '其他用戶',
            style: TextStyle(
                color: Colors.white,
                /*decoration: TextDecoration.underline,*/
                fontSize: 18),
          ),
          TextSpan(
            text: '檢舉了',
            style: TextStyle(color: Colors.white, fontSize: 18),
          )
        ]));
  }

  Widget _status() {
    return Text(
      _getStatusText(model.status),
      style: TextStyle(color: _getStatusColor(model.status), fontSize: 16),
    );
  }

  String _getStatusText(ComplaintRecordStatus status) {
    switch (status) {
      case ComplaintRecordStatus.APPROVAL_WAIT:
        return '(等待審核)';
      case ComplaintRecordStatus.APPROVAL_OK:
        if (model.pass) {
          return '(申訴失敗)';
        }
        return '(申訴成功)';
      case ComplaintRecordStatus.REJECT:
        return '(申訴成功)';
      case ComplaintRecordStatus.WAITING_REPLY:
        return '(需回覆申訴內容)';
    }
  }

  Color _getStatusColor(ComplaintRecordStatus status) {
    switch (status) {
      case ComplaintRecordStatus.APPROVAL_WAIT:
        return Colors.amber;
      case ComplaintRecordStatus.APPROVAL_OK:
        if (model.pass) {
          return Colors.red;
        }
        return Colors.green;
      case ComplaintRecordStatus.REJECT:
        return Colors.green;
      case ComplaintRecordStatus.WAITING_REPLY:
        return Colors.amber;
    }
  }
}
