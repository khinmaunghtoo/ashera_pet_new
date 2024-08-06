import 'dart:convert';
import 'dart:core';
import 'dart:developer';
import 'dart:isolate';

import 'package:ashera_pet_new/data/auth.dart';
import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/enum/adopt_report.dart';
import 'package:ashera_pet_new/enum/ranking_list_type.dart';
import 'package:ashera_pet_new/model/add_adopt_record_dto.dart';
import 'package:ashera_pet_new/model/update_adopt_record_reply.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';

import '../enum/adopt_status.dart';
import '../model/tuple.dart';
import '../utils/api.dart';

class AdoptReportVm with ChangeNotifier {
  final List<AdoptRecordModel> _allAdoptReportRecord = [];
  List<AdoptRecordModel> get recordFrom => _allAdoptReportRecord
      .where((element) =>
          element.fromMemberId == Member.memberModel.id &&
          element.type == RankingListType.MESSAGE)
      .toList();
  List<AdoptRecordModel> get recordTarget => _allAdoptReportRecord
      .where((element) =>
          element.targetMemberId == Member.memberModel.id &&
          (element.status == ComplaintRecordStatus.WAITING_REPLY ||
              (element.status == ComplaintRecordStatus.APPROVAL_OK &&
                  element.passAt.isNotEmpty)) &&
          element.type == RankingListType.MESSAGE)
      .toList();

  PageController? _controller;
  PageController get controller => _controller!;

  AdoptReportType _adoptReportType = AdoptReportType.adoptReport;
  AdoptReportType get adoptReportType => _adoptReportType;

  int _nowRecordId = 0;
  int get nowRecordId => _nowRecordId;
  AdoptRecordModel get nowRecord => _allAdoptReportRecord
      .where((element) => element.id == _nowRecordId)
      .first;

  //取得被檢舉與檢舉紀錄
  void getAdoptReportRecordByFromAndTarget(int id) async {
    //SVProgressHUD.show();
    List<Tuple<bool, String>> r = await Future.wait(
        [_getAdoptReportRecordByFrom(id), _getAdoptReportRecordByTarget(id)]);
    if (r[0].i1! && r[1].i1!) {
      //SVProgressHUD.dismiss();
      log('檢舉：${r[0].i2}');
      log('被檢舉：${r[1].i2}');
      List fromList = json.decode(r[0].i2!);
      List targetList = json.decode(r[1].i2!);
      List<AdoptRecordModel> l1 =
          fromList.map((e) => AdoptRecordModel.fromMap(e)).toList();
      List<AdoptRecordModel> l2 =
          targetList.map((e) => AdoptRecordModel.fromMap(e)).toList();
      await Future.forEach(l1, (element) {
        if (_allAdoptReportRecord
            .where((value) => element.id == value.id)
            .isEmpty) {
          _allAdoptReportRecord.add(element);
        } else {
          int index =
              _allAdoptReportRecord.indexWhere((e) => e.id == element.id);
          _allAdoptReportRecord.removeAt(index);
          _allAdoptReportRecord.add(element);
        }
      });
      await Future.forEach(l2, (element) {
        if (_allAdoptReportRecord
            .where((value) => element.id == value.id)
            .isEmpty) {
          _allAdoptReportRecord.add(element);
        } else {
          int index =
              _allAdoptReportRecord.indexWhere((e) => e.id == element.id);
          _allAdoptReportRecord.removeAt(index);
          _allAdoptReportRecord.add(element);
        }
      });
      _allAdoptReportRecord.sort((f, l) => l.updatedAt.compareTo(f.updatedAt));

      notifyListeners();
    } else {
      if (!r[0].i1!) {
        SVProgressHUD.showError(status: r[0].i2!);
      }
      if (!r[1].i1!) {
        SVProgressHUD.showError(status: r[1].i2!);
      }
    }
  }

  void justGetAdoptReportRecordByFrom(int id) async {
    Tuple<bool, String> r = await _getAdoptReportRecordByFrom(id);
    if (r.i1!) {
      List fromList = json.decode(r.i2!);
      List<AdoptRecordModel> list =
          fromList.map((e) => AdoptRecordModel.fromMap(e)).toList();
      for (var element in list) {
        if (_allAdoptReportRecord
            .where((value) => element.id == value.id)
            .isEmpty) {
          _allAdoptReportRecord.add(element);
          _allAdoptReportRecord
              .sort((f, l) => l.updatedAt.compareTo(f.updatedAt));
        } else {
          int index =
              _allAdoptReportRecord.indexWhere((e) => e.id == element.id);
          _allAdoptReportRecord.removeAt(index);
          _allAdoptReportRecord.add(element);
        }
      }
    }
  }

  void justGetAdoptReportRecordByTarget(int id) async {
    Tuple<bool, String> r = await _getAdoptReportRecordByFrom(id);
    if (r.i1!) {
      List targetList = json.decode(r.i2!);
      List<AdoptRecordModel> list =
          targetList.map((e) => AdoptRecordModel.fromMap(e)).toList();
      for (var element in list) {
        if (_allAdoptReportRecord
            .where((value) => element.id == value.id && value.reply.isEmpty)
            .isEmpty) {
          int i = _allAdoptReportRecord
              .indexWhere((value) => element.id == value.id);
          _allAdoptReportRecord.removeAt(i);
          _allAdoptReportRecord.add(element);
          _allAdoptReportRecord
              .sort((f, l) => l.updatedAt.compareTo(f.updatedAt));
        } else {
          int index =
              _allAdoptReportRecord.indexWhere((e) => e.id == element.id);
          _allAdoptReportRecord.removeAt(index);
          _allAdoptReportRecord.add(element);
        }
      }
    }
  }

  //取得會員領養檢舉
  Future<Tuple<bool, String>> _getAdoptReportRecordByFrom(int id) async {
    String token = Auth.userLoginResDTO.body.token;
    return await Isolate.run(() => adoptReportRecordByFromMemberId(id, token));
  }

  //取得會員被領養檢舉
  Future<Tuple<bool, String>> _getAdoptReportRecordByTarget(int id) async {
    String token = Auth.userLoginResDTO.body.token;
    return await Isolate.run(
        () => adoptReportRecordByTargetMemberId(id, token));
  }

  //回覆領養檢舉紀錄
  /*void sendUpdateAdoptRecordReply(UpdateAdoptRecordReplyDTO dto){
    Ws.stompClient.send(destination: Ws.updateAdoptRecordReply, body: dto.toJson());
  }*/

  Future<void> sendUpdateAdoptRecordReply(
      UpdateAdoptRecordReplyDTO dto) async {}

  void initAdoptReportType() {
    _adoptReportType = AdoptReportType.adoptReport;
  }

  void setAdoptReportType(AdoptReportType value) {
    if (_adoptReportType != value) {
      log('檢舉類型：${value.zh}');
      _adoptReportType = value;
      notifyListeners();
      _controller!.jumpToPage(value.index);
    }
  }

  void setPageController(PageController value) {
    _controller = value;
    notifyListeners();
    _controller!.jumpToPage(AdoptReportType.adoptReport.index);
  }

  void setNowRecordId(int id) {
    if (_nowRecordId != id) {
      _nowRecordId = id;
      notifyListeners();
    }
  }

  void clearNowRecordId() {
    _nowRecordId = 0;
  }

  void setReply(UpdateAdoptRecordReplyDTO dto) {
    int index =
        _allAdoptReportRecord.indexWhere((element) => element.id == dto.id);
    _allAdoptReportRecord[index] = _allAdoptReportRecord[index]
        .copyWith(reply: dto.reply, replyPics: dto.replyPics);
    notifyListeners();
  }
}
