import 'dart:developer';

import 'package:ashera_pet_new/db/app_db.dart';
import 'package:collection/collection.dart';
import 'package:ashera_pet_new/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../data/member.dart';
import '../enum/message_type.dart';
import '../model/member.dart';
import '../model/message.dart';

class PhotosAndVideosVm with ChangeNotifier {
  final List<MessageModel> _data = [];
  List<MessageModel> _sqliteData = [];
  Map<String, List<MessageModel>> grouped = {};
  List<MessageModel> get allPhotoAndVideo => _sqliteData;
  final DateFormat format = DateFormat("yyyy/MM");

  final int _offset = 0;
  int get offset => _offset;

  final int _copyOffset = 0;

  late PageMessageModel pageMessageModel;

  MemberModel? otherMember;

  late ScrollController _controller;

  void initPhotosAndVideosData(MemberModel member) {
    otherMember = member;
    log('member: ${member.toMap()}');
    photosAndVideoMsgData();
  }

  void disposePhotosAndVideosData() {
    _sqliteData.clear();
    grouped.clear();
  }

  void photosAndVideoMsgData() async {
    log('photosAndVideoMsgData: ${DateTime.now()}');
    //先找db有沒有
    List<List<Map<String, dynamic>>> twoList = await Future.wait([
      AppDB.getTableData(
          AppDB.msgTable,
          'fromMember = ? And type IN (?,?)',
          [otherMember!.name, MessageType.PIC.name, MessageType.VIDEO.name],
          null,
          'createdAt DESC',
          null),
      AppDB.getTableData(
          AppDB.msgTable,
          'targetMember = ? And type IN (?,?)',
          [otherMember!.name, MessageType.PIC.name, MessageType.VIDEO.name],
          null,
          'createdAt DESC',
          null),
    ]);
    List<Map<String, dynamic>> record = List.from(twoList[0])
      ..addAll(twoList[1]);
    if (record.isNotEmpty) {
      log('讀取本地資料');
      _sqliteData = _tidyAndSort(record);
      _sqliteData
          .sort((first, last) => first.createdAt.compareTo(last.createdAt));
      readMsg();
    }
  }

  void readMsg() async {
    grouped = groupBy<MessageModel, String>(_sqliteData, (messages) {
      String time =
          format.format(Utils.sqlDateFormatTest.parse(messages.createdAt));
      return time;
    });
    notifyListeners();
  }

  List<MessageModel> _tidyAndSort(List<Map<String, dynamic>> record) {
    List<MessageModel> data = record
        .map((e) => MessageModel.fromDBMap(e))
        .where((element) =>
            element.block == false ||
            (element.fromMemberId == Member.memberModel.id &&
                element.block == true))
        .toList();
    return data;
  }
}
