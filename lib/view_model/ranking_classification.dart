import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:ashera_pet_new/enum/ranking_classification.dart';
import 'package:ashera_pet_new/model/ranking_follower.dart';
import 'package:ashera_pet_new/model/ranking_like_keep.dart';
import 'package:ashera_pet_new/model/ranking_message.dart';
import 'package:ashera_pet_new/model/ranking_post.dart';
import 'package:ashera_pet_new/utils/api.dart';
import 'package:flutter/cupertino.dart';

import '../data/auth.dart';
import '../model/report_system_setting.dart';
import '../model/tuple.dart';
import '../utils/utils.dart';

//排行
class RankingClassificationVm with ChangeNotifier {
  late PageController _pageController;
  RankingClassificationEnum _classification = RankingClassificationEnum.message;
  RankingClassificationEnum get classification => _classification;

  List<RankingMessageModel> _postCard = [];
  List<RankingMessageModel> get postCard => _postCard;

  List<RankingMessageModel> _messageList = [];
  List<RankingMessageModel> get messageList => _messageList;
  List<RankingFollowerModel> _followerList = [];
  List<RankingFollowerModel> get followerList => _followerList;
  List<RankingPostModel> _postList = [];
  List<RankingPostModel> get postList => _postList;
  List<RankingLikeKeepModel> _likeList = [];
  List<RankingLikeKeepModel> get likeList => _likeList;
  List<RankingLikeKeepModel> _collectionList = [];
  List<RankingLikeKeepModel> get collectionList => _collectionList;

  bool _canUploading = true;

  late ReportSystemSettingModel _systemSettingModel;
  late Duration _listMessageDuration;
  late Duration _listFollowerDuration;
  late Duration _listPostLikeDuration;
  late Duration _listWatchDuration;

  Timer? _messageTimer;
  Timer? _followerTimer;
  Timer? _postTimer;
  Timer? _watchTimer;
  Timer? _likeTimer;
  Timer? _keepTimer;

  void init() async {
    await _settingSystem();
    _postCard = List.from(_messageList);
    notifyListeners();
  }

  void initPageController(PageController controller) {
    _pageController = controller;
  }

  Future<void> _settingSystem() async {
    if (_canUploading) {
      _canUploading = false;
      String token = Auth.userLoginResDTO.body.token;
      Tuple<bool, String> r =
          await Isolate.run(() => getReportSystemSetting(token));
      if (r.i1!) {
        _systemSettingModel = ReportSystemSettingModel.fromJson(r.i2!);
        log('system: ${_systemSettingModel.toMap()}');
        _listMessageDuration = Utils.howLongIsItExpired(
                _systemSettingModel.rankingListMessageLastUpdateAt)
            .abs();
        _listFollowerDuration = Utils.howLongIsItExpired(
                _systemSettingModel.rankingListFollowerLastUpdateAt)
            .abs();
        //_listPostLikeDuration = Utils.howLongIsItExpired(_systemSettingModel.rankingListPostLikeLastUpdateAt).abs();
        //_listWatchDuration = Utils.howLongIsItExpired(_systemSettingModel.rankingListWatchLastUpdateAt).abs();
        await _message();

        await _follower();
        //愛心
        await _like();
        //收藏
        await _collection();

        //await _post();

        //await _watch();
      }
    }
  }

  Future<void> _message() async {
    Tuple<bool, String> r = await Api.getRankingListMessageLikeByUuid(
        _systemSettingModel.rankingListMessageUuid);
    log('message: ${_systemSettingModel.rankingListMessageUuid} ${r.i2}');
    if (r.i1!) {
      List list = json.decode(r.i2 ?? '[]');
      _messageList = list.map((e) => RankingMessageModel.fromMap(e)).toList();
    }
    //log('message 過期時間：${_listMessageDuration.inMinutes}');
    _messageTimer ??= Timer.periodic(_listMessageDuration, (timer) {
      //log('message 過期');
      _clearTimer();
    });
  }

  Future<void> _follower() async {
    Tuple<bool, String> r = await Api.getRankingListFollowerByUuid(
        _systemSettingModel.rankingListFollowerUuid);
    log('follower: ${_systemSettingModel.rankingListFollowerUuid} ${r.i2}');
    if (r.i1!) {
      List list = json.decode(r.i2 ?? '[]');
      _followerList = list.map((e) => RankingFollowerModel.fromMap(e)).toList();
      for (var e in _followerList) {
        log('${e.toMap()}');
      }
    }
    //log('follower 過期時間：${_listFollowerDuration.inMinutes}');
    _followerTimer ??= Timer.periodic(_listFollowerDuration, (timer) {
      //log('follower 過期');
      _clearTimer();
    });
  }

  //寵物愛心前十
  Future<void> _like() async {
    Tuple<bool, String> r = await Api.getMemberPetLikeByMostLikeTop();
    log('like: ${r.i2}');
    if (r.i1!) {
      List list = json.decode(r.i2 ?? '[]');
      _likeList = list.map((e) => RankingLikeKeepModel.fromMap(e)).toList();
    }
    _likeTimer ??= Timer.periodic(const Duration(minutes: 5), (timer) {
      _clearTimer();
    });
  }

  //寵物收藏前十
  Future<void> _collection() async {
    Tuple<bool, String> r = await Api.getMemberPetLikeByMostKeepTop();
    log('collection: ${r.i2}');
    if (r.i1!) {
      List list = json.decode(r.i2 ?? '[]');
      _collectionList =
          list.map((e) => RankingLikeKeepModel.fromMap(e)).toList();
    }
    _keepTimer ??= Timer.periodic(const Duration(minutes: 5), (timer) {
      _clearTimer();
    });
  }

  Future<void> _post() async {
    Tuple<bool, String> r = await Api.getRankingPostLikeByUuid(
        _systemSettingModel.rankingListPostLikeUuid);
    log('post: ${_systemSettingModel.rankingListPostLikeUuid} ${r.i2}');
    if (r.i1!) {
      List list = json.decode(r.i2 ?? '[]');
      _postList = list.map((e) => RankingPostModel.fromMap(e)).toList();
    }
    //log('post 過期時間：${_listPostLikeDuration.inMinutes}');
    _postTimer ??= Timer.periodic(_listPostLikeDuration, (timer) {
      //log('post 過期');
      _clearTimer();
    });
  }

  Future<void> _watch() async {
    /*_watchTimer ??= Timer.periodic(_listWatchDuration, (timer) {
      _clearTimer();
    });*/
  }

  //全部計時歸0
  void _clearTimer() {
    if (_messageTimer != null) {
      _messageTimer!.cancel();
      _messageTimer = null;
    }
    if (_followerTimer != null) {
      _followerTimer!.cancel();
      _followerTimer = null;
    }
    if (_postTimer != null) {
      _postTimer!.cancel();
      _postTimer = null;
    }
    if (_watchTimer != null) {
      _watchTimer!.cancel();
      _watchTimer = null;
    }
    if (_likeTimer != null) {
      _likeTimer!.cancel();
      _likeTimer = null;
    }
    if (_keepTimer != null) {
      _keepTimer!.cancel();
      _keepTimer = null;
    }
    _canUploading = true;
    _settingSystem();
  }

  void setClassification(RankingClassificationEnum value) {
    if (_classification != value) {
      _classification = value;
      log('更換的項目：${_classification.zh}');
      _pageController.jumpToPage(value.index);
      _setPostList();
    }
  }

  void _setPostList() {
    switch (_classification) {
      case RankingClassificationEnum.message:
        if (_messageList.isNotEmpty) {
          _postCard = List<RankingMessageModel>.from(_messageList);
          notifyListeners();
        } else {
          _postCard = [];
          notifyListeners();
        }
        break;
      case RankingClassificationEnum.fan:
        if (_followerList.isNotEmpty) {
          _postCard = List<RankingMessageModel>.from(_followerList
              .map((e) => RankingMessageModel.fromMap(e.toMap()))
              .toList());
          notifyListeners();
        } else {
          _postCard = [];
          notifyListeners();
        }
        break;
      case RankingClassificationEnum.like:
        if (_likeList.isNotEmpty) {
          _postCard = List<RankingMessageModel>.from(
                  _likeList.map((e) => RankingMessageModel.fromMap(e.toMap())))
              .toList();
          notifyListeners();
        } else {
          _postCard = [];
          notifyListeners();
        }
        break;
      case RankingClassificationEnum.collection:
        if (_collectionList.isNotEmpty) {
          _postCard = List<RankingMessageModel>.from(_collectionList
              .map((e) => RankingMessageModel.fromMap(e.toMap()))).toList();
          notifyListeners();
        } else {
          _postCard = [];
          notifyListeners();
        }
        break;
    }
  }
}
