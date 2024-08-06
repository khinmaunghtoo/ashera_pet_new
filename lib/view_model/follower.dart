import 'dart:convert';
import 'dart:developer';

import 'package:ashera_pet_new/model/follower.dart';
import 'package:flutter/widgets.dart';

import '../model/tuple.dart';
import '../utils/api.dart';
import '../utils/ws.dart';

class FollowerVm with ChangeNotifier {
  List<FollowerRequestModel> _myFollowerList = [];
  List<FollowerRequestModel> get myFollowerList => _myFollowerList;

  List<FollowerRequestModel> _followerMeList = [];
  List<FollowerRequestModel> get followerMeList => _followerMeList;

  //整理
  void tidyFollower() async {
    log('整理追蹤與被追蹤');
    List<List<FollowerRequestModel>> r =
        await Future.wait([_getMyFollower(), _getFollowerMe()]);
    _myFollowerList = List.from(r[0].toSet());
    _followerMeList = List.from(r[1].toSet());
    for (var e in _followerMeList) {
      log('_followerMeList: ${e.toMap()}');
    }
    notifyListeners();
  }

  Future<List<FollowerRequestModel>> _getFollowerMe() async {
    List<FollowerRequestModel> rList = [];
    List<Tuple<bool, String>> r =
        await Future.wait([Api.getFollowerMeRequest(), Api.getFollowerMe()]);
    if (r[0].i1!) {
      List list = json.decode(r[0].i2!);
      rList =
          List.from(list.map((e) => FollowerRequestModel.fromMap(e)).toList());
    }
    if (r[1].i1!) {
      List list = json.decode(r[1].i2!);
      log(r[1].i2!);
      rList.addAll(
          List.from(list.map((e) => FollowerRequestModel.fromMap(e)).toList()));
      rList = List.from(rList.toSet());
    }
    return rList;
  }

  Future<List<FollowerRequestModel>> _getMyFollower() async {
    List<FollowerRequestModel> rList = [];
    List<Tuple<bool, String>> r =
        await Future.wait([Api.getMyFollowerRequest(), Api.getMyFollower()]);
    if (r[0].i1!) {
      List list = json.decode(r[0].i2!);
      rList = list.map((e) => FollowerRequestModel.fromMap(e)).toList();
    }
    if (r[1].i1!) {
      List list = json.decode(r[1].i2!);
      rList.addAll(list.map((e) => FollowerRequestModel.fromMap(e)).toList());
      rList = List.from(rList.toSet());
    }
    return rList;
  }

  //我追蹤誰
  void sendMyFollower() {
    if (Ws.stompClient.isActive) {
      Ws.stompClient.send(destination: Ws.myFollower);
    }
  }

  //誰追蹤我
  void sendFollowerMe() {
    if (Ws.stompClient.isActive) {
      Ws.stompClient.send(destination: Ws.followerMe);
    }
  }

  //發送追蹤申請
  void sendFollowerRequest(AddFollowerRequestDTO dto) {
    if (Ws.stompClient.isActive) {
      Ws.stompClient
          .send(destination: Ws.addFollowerRequest, body: dto.toJson());
    }
  }

  //接受或拒絕追蹤
  void sendFollowerRequestAccept(AcceptFollowerRequestDTO dto) {
    if (Ws.stompClient.isActive) {
      Ws.stompClient
          .send(destination: Ws.acceptFollowerRequest, body: dto.toJson());
    }
  }

  //取消/刪除追蹤
  void removeFollower(AddFollowerRequestDTO dto) {
    if (Ws.stompClient.isActive) {
      Ws.stompClient.send(
          destination: Ws.deleteFollowerByMemberIdAndFollowerId,
          body: dto.toJson());
    }
  }

  //撤回追蹤
  void removeFollowerRequest(DeleteFollowerRequestDTO dto) {
    if (Ws.stompClient.isActive) {
      Ws.stompClient
          .send(destination: Ws.deleteFollowerRequest, body: dto.toJson());
    }
  }
}
