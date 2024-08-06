import 'dart:convert';
import 'dart:developer';

import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/utils/utils.dart';
import 'package:flutter/cupertino.dart';

import '../enum/notify_time_type.dart';
import '../model/notify.dart';
import '../model/tuple.dart';
import '../utils/api.dart';

class NotifyVm extends ChangeNotifier {
  GetMessageNotifyByTargetMemberDTO _dto = GetMessageNotifyByTargetMemberDTO(
      memberId: Member.memberModel.id, page: 0);

  List<NotifyModel> _allNotifyModel = [];

  List<NotifyModel> _thisWeekNotify = [];
  List<NotifyModel> get thisWeekNotify => _thisWeekNotify;

  List<NotifyModel> _thisMonthNotify = [];
  List<NotifyModel> get thisMonthNotify => _thisMonthNotify;

  List<NotifyModel> _earlierNotify = [];
  List<NotifyModel> get earlierNotify => _earlierNotify;

  late PageMessageNotifyModel _data;

  Future<void> getMessageNotify() async {
    Tuple<bool, String> r = await Api.getMessageNotifyByTargetMemberId();
    if (r.i1!) {
      log('通知：${r.i2}');
      List list = json.decode(r.i2!);
      _allNotifyModel = list.map((e) => NotifyModel.fromMap(e)).toList();
      await _tidyMessageNotify();
      notifyListeners();
    }
  }

  //分頁
  Future<void> getMessageNotifyPage() async {
    Tuple<bool, String> r =
        await Api.postMessageNotifyByTargetMemberIdPageDesc(_dto.toMap());
    if (r.i1!) {
      log('分頁通知：${r.i2}');
      _allNotifyModel.clear();
      _thisWeekNotify.clear();
      _thisMonthNotify.clear();
      _earlierNotify.clear();
      _data = PageMessageNotifyModel.fromJson(r.i2!);
      _allNotifyModel.addAll(_data.content);
      _allNotifyModel = List.from(_allNotifyModel.toSet());
      _allNotifyModel
          .sort((first, last) => last.createdAt.compareTo(first.createdAt));
      await _tidyMessageNotify();
    }
  }

  //整理
  Future<void> _tidyMessageNotify() async {
    await Future.forEach(_allNotifyModel, (element) {
      switch (Utils.getNotifyTimeType(element.createdAt)) {
        case NotifyTimeType.thisWeek:
          if (_thisWeekNotify.where((old) => old.id == element.id).isEmpty) {
            _thisWeekNotify = [..._thisWeekNotify.toSet(), element];
            _thisWeekNotify.sort(
                (first, last) => last.createdAt.compareTo(first.createdAt));
          }
          break;
        case NotifyTimeType.thisMonth:
          if (_thisMonthNotify.where((old) => old.id == element.id).isEmpty) {
            _thisMonthNotify = [..._thisMonthNotify.toSet(), element];
            _thisMonthNotify.sort(
                (first, last) => last.createdAt.compareTo(first.createdAt));
          }
          break;
        case NotifyTimeType.earlier:
          if (_earlierNotify.where((old) => old.id == element.id).isEmpty) {
            _earlierNotify = [..._earlierNotify.toSet(), element];
            _earlierNotify.sort(
                (first, last) => last.createdAt.compareTo(first.createdAt));
          }
          break;
      }
    });
  }

  //新增畫面
  void addPage() {
    int page = _dto.page;
    _dto = _dto.copyWith(page: page++);
    getMessageNotifyPage();
  }

  void clearDto() {
    _dto = _dto.copyWith(page: 0);
  }
}
