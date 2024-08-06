import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:ashera_pet_new/model/complaint_record.dart';
import 'package:ashera_pet_new/utils/api.dart';
import 'package:flutter/widgets.dart';

import '../data/auth.dart';
import '../model/complaint.dart';
import '../model/tuple.dart';

class ComplaintRecordVm extends ChangeNotifier {
  List<ComplaintModel> _reasonList = [];
  List<ComplaintModel> get reasonList => _reasonList;

  //檢舉列表
  void getComplaint() async {
    String token = Auth.userLoginResDTO.body.token;
    Tuple<bool, String> r = await Isolate.run(() => getApiComplaint(token));
    if (r.i1!) {
      //log('檢舉列表：${r.i2!}');
      List list = json.decode(r.i2!);
      _reasonList = list.map((e) => ComplaintModel.fromMap(e)).toList();
      //list.forEach((v) => log('檢舉列表: ${v.toString()}'));
    }
  }

  //新增檢舉紀錄
  Future<bool> addComplaintRecord(ComplaintRecordModel dto) async {
    log('新增檢舉紀錄：${dto.addRecord()}');
    Tuple<bool, String> r = await Api.postComplaintRecord(dto.addRecord());
    return r.i1!;
  }
}
