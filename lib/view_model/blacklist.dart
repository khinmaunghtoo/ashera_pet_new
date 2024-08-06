import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:ashera_pet_new/data/blacklist.dart';
import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/model/blacklist.dart';
import 'package:ashera_pet_new/utils/api.dart';
import 'package:flutter/cupertino.dart';

import '../model/tuple.dart';

class BlackListVm extends ChangeNotifier {
  void getBlackList() async {
    Tuple<bool, String> r = await Api.getBlackList();
    if (r.i1!) {
      log('黑名單：${r.i2}');
      BlackList.blacklist = await Isolate.run(() => _readBlackList(r.i2!));
    }
  }

  void addBlackList(int id) async {
    BlackListModel dto =
        BlackListModel(fromMemberId: Member.memberModel.id, targetMemberId: id);
    Tuple<bool, String> r = await Api.postBlackList(dto.addBlackList());
    if (r.i1!) {
      log('加入黑名單成功： ${r.i2!}');
      BlackListModel dto = BlackListModel.fromJson(r.i2!);
      BlackList.blacklist.add(dto);
      notifyListeners();
    }
  }

  void removeBlackList(int id) async {
    Tuple<bool, String> r = await Api.deleteBlackList(id);
    if (r.i1!) {
      log('刪除黑名單成功：${r.i2!}');
      BlackList.blacklist.removeWhere((element) => element.id == id);
      notifyListeners();
    }
  }
}

List<BlackListModel> _readBlackList(String value) {
  List list = json.decode(value);
  return List<BlackListModel>.from(list.map((e) => BlackListModel.fromMap(e)))
      .toList();
}
