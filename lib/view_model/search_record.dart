import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:ashera_pet_new/db/app_db.dart';
import 'package:ashera_pet_new/enum/member_status.dart';
import 'package:ashera_pet_new/model/member_pet.dart';
import 'package:flutter/widgets.dart';

import '../model/member_view.dart';

class SearchRecordVm with ChangeNotifier {
  List<MemberPetModel> _searchRecordList = [];
  List<MemberPetModel> get searchRecordList => _searchRecordList;

  //取得搜尋紀錄
  void getSearchRecordList() async {
    List<Map<String, dynamic>> data =
        await AppDB.getAllTableData(AppDB.searchTable);
    _searchRecordList = await Isolate.run(() => _readAllTableData(data));
    notifyListeners();
  }

  //新增搜尋紀錄
  void addSearchRecord(MemberPetModel data) async {
    if (_searchRecordList.where((element) => element == data).isNotEmpty) {
      return;
    }
    log('addSearchRecord: ${data.nickname} ${data.member!.toMap()}');
    await AppDB.insert(AppDB.searchTable, data.addToDB());
    getSearchRecordList();
  }

  //刪除單筆搜尋紀錄
  void removeSearchRecord(MemberPetModel data) async {
    log('removeSearchRecord: ${data.nickname}');
    await AppDB.deleteData(AppDB.searchTable, 'id = ?', [data.id]);
    getSearchRecordList();
  }
}

List<MemberPetModel> _readAllTableData(List<Map<String, dynamic>> data) {
  return List.generate(
      data.length,
      (index) => MemberPetModel(
          id: data[index]['id'],
          memberId: data[index]['memberId'],
          nickname: data[index]['nickname'],
          mugshot: data[index]['mugshot'],
          aboutMe: data[index]['aboutMe'],
          age: data[index]['age'],
          birthday: data[index]['birthday'],
          animalType: data[index]['animalType'],
          gender: data[index]['gender'],
          healthStatus: data[index]['healthStatus'],
          status: MemberStatus.values[data[index]['status']],
          member: MemberView.fromJson(json.decode(data[index]['member']))));
}
