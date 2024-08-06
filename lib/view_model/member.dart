import 'dart:developer';
import 'dart:isolate';

import 'package:ashera_pet_new/data/auth.dart';
import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/model/member.dart';
import 'package:ashera_pet_new/model/tuple.dart';
import 'package:flutter/material.dart';

import '../enum/photo_type.dart';
import '../model/target_member_warning_dto.dart';
import '../utils/api.dart';

//* 會員provider
class MemberVm with ChangeNotifier {
  bool _messageNotifyStatus = false;
  bool get messageNotifyStatus => _messageNotifyStatus;

  int _id = 0;
  int get id => _id;

  final List<TargetMemberWarningDto> _targetMemberWarnings = [];
  List<TargetMemberWarningDto> get targetMemberWarnings =>
      _targetMemberWarnings;

  void setNickname(String value) {
    if (value != Member.memberModel.nickname) {
      Member.memberModel = Member.memberModel.copyWith(nickname: value);
    }
  }

  void setAbout(String value) {
    if (value != Member.memberModel.aboutMe) {
      Member.memberModel = Member.memberModel.copyWith(aboutMe: value);
    }
  }

  //取得會員with user id, 并且本地持久化(static)
  Future<void> getMemberInforWithUserIDAndPersistent() async {
    Tuple<bool, String> r =
        await Api.getMemberData(Auth.userLoginResDTO.userId);
    if (r.i1!) {
      //取得成功
      log('Member i2: ${r.i2!}');
      Member.memberModel = MemberModel.fromJson(r.i2!);
      _messageNotifyStatus = Member.memberModel.messageNotifyStatus;
      _id = Member.memberModel.id;
      notifyListeners();
    } else {
      //取得失敗
      log('Member fail');
    }
  }

  //更新會員資料
  Future<void> updateMember() async {
    Tuple<bool, String> r =
        await Api.putMemberData(Auth.userLoginResDTO.userId);
    if (r.i1!) {
      //更新成功
      log('update Member i2: ${r.i2!}');
      Member.memberModel = MemberModel.fromJson(r.i2!);
      notifyListeners();
    } else {
      //更新失敗
      log('update fail');
    }
  }

  //更新頭像
  Future<void> updateMemberAvatar() async {
    Tuple<bool, String> r = await Api.uploadFile(
        Member.memberModel.name, Member.memberModel.mugshot, PhotoType.mugshot);
    if (r.i1!) {
      //上傳成功
      log('update Avatar i2: ${r.i2!}');
      Member.memberModel = Member.memberModel.copyWith(mugshot: r.i2!);
    } else {
      //更新失敗
      log('update fail');
    }
  }

  //會員通知已讀
  Future<void> updateMessageNotifyStatus() async {
    if (_messageNotifyStatus) {
      String token = Auth.userLoginResDTO.body.token;
      int id = _id;
      Tuple<bool, String> r =
          await Isolate.run(() => clearMessageNotifyStatus(id, token));
      log('updateMessageNotifyStatus: ${r.i2}');
      if (r.i1!) {
        _messageNotifyStatus = false;
        Member.memberModel = Member.memberModel
            .copyWith(messageNotifyStatus: _messageNotifyStatus);
        notifyListeners();
      }
    }
  }

  //更新密碼
  Future<bool> updatePassword(UpdateMemberPasswordWithOldDTO dto) async {
    Tuple<bool, String> r =
        await Api.putPassword(Auth.userLoginResDTO.userId, dto.toMap());
    return r.i1!;
  }

  //刪除帳號
  Future<bool> deleteMember() async {
    Tuple<bool, String> r = await Api.deleteMember();
    return r.i1!;
  }

  void setTargetMemberWarning(TargetMemberWarningDto value) {
    if (_targetMemberWarnings
        .where((e) => e.targetMemberId == value.targetMemberId)
        .isEmpty) {
      //新增
      log('新增TargetMemberWarning');
      _targetMemberWarnings.add(value);
      notifyListeners();
    } else if (_targetMemberWarnings
        .where((e) => e.targetMemberId == value.targetMemberId)
        .isNotEmpty) {
      if (_targetMemberWarnings
          .where((e) =>
              e.targetMemberId == value.targetMemberId &&
              e.warning != value.warning)
          .isNotEmpty) {
        log('修改TargetMemberWarning');
        int index = _targetMemberWarnings
            .indexWhere((e) => e.targetMemberId == value.targetMemberId);
        _targetMemberWarnings.removeAt(index);
        _targetMemberWarnings.add(value);
        notifyListeners();
      }
    }
  }
}
