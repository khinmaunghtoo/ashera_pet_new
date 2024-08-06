import 'package:ashera_pet_new/dialog/reply_report_alert.dart';
import 'package:ashera_pet_new/dialog/report_alert.dart';
import 'package:flutter/material.dart';

import '../model/add_adopt_record_dto.dart';
import 'complaint_success_alert.dart';

class Alert {
  static void showComplaintSuccessAlert(BuildContext context) {
    showDialog(
        context: context,
        useSafeArea: false,
        builder: (BuildContext context) {
          return const Dialog(
            insetPadding: EdgeInsets.zero,
            surfaceTintColor: Colors.black87,
            backgroundColor: Colors.transparent,
            child: ComplaintSuccessAlert(),
          );
        });
  }

  //聊天室檢舉
  static Future<bool?> showReportAlert(
      BuildContext context, AdoptRecordModel dto) async {
    return await showDialog(
        context: context,
        useSafeArea: false,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            surfaceTintColor: Colors.black87,
            backgroundColor: Colors.transparent,
            child: ReportAlert(
              dto: dto,
            ),
          );
        });
  }

  //聊天室被檢舉回覆
  static void showReplyReportAlert(BuildContext context, AdoptRecordModel dto) {
    showDialog(
        context: context,
        useSafeArea: false,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: EdgeInsets.zero,
            surfaceTintColor: Colors.black87,
            backgroundColor: Colors.transparent,
            child: ReplyReportAlert(dto: dto),
          );
        });
  }
}
