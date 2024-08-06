import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:ashera_pet_new/data/auth.dart';
import 'package:ashera_pet_new/data/blacklist.dart';
import 'package:ashera_pet_new/enum/like_type.dart';
import 'package:ashera_pet_new/enum/photo_type.dart';
import 'package:ashera_pet_new/model/post_like.dart';
import 'package:ashera_pet_new/model/post_message_like.dart';
import 'package:ashera_pet_new/routes/app_router.dart';
import 'package:ashera_pet_new/routes/route_name.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../data/member.dart';
import '../model/follower.dart';
import '../model/post.dart';
import '../model/post_background_model.dart';
import '../model/post_card_media.dart';
import '../model/post_message.dart';
import '../model/tuple.dart';
import '../utils/api.dart';
import '../utils/utils.dart';
import '../utils/ws.dart';

class PostVm extends ChangeNotifier {
  //暫存滑動到的位置
  double _pixels = 0.0;

  ScrollController? _homeController;
  //ScrollController? _controller;
  ScrollController? get controller => _homeController;
  GlobalKey<SliverAnimatedListState> get commentKey =>
      GlobalKey<SliverAnimatedListState>();

  GetPageDTO _homeDTO =
      const GetPageDTO(page: 0, size: 5, sortBy: 'created_at');

  FriendDataCntDTO _friendDataCnt = const FriendDataCntDTO(
      memberId: 0, postCnt: 0, myFollowCnt: 0, followMeCnt: 0);
  FriendDataCntDTO get friendDataCnt => _friendDataCnt;

  FriendDataCntDTO _otherFriendDataCnt = const FriendDataCntDTO(
      memberId: 0, postCnt: 0, myFollowCnt: 0, followMeCnt: 0);
  FriendDataCntDTO get otherFriendDataCnt => _otherFriendDataCnt;

  List<PostModel> _postData = [];
  List<PostModel> get postData => _postData;
  //最後
  bool get atLast => _pagePostData != null ? _pagePostData!.last : true;

  List<PostLikeModel> _postDataLike = [];
  List<PostLikeModel> get postDataLike => _postDataLike;
  List<PostMessageModel> _postDataMessage = [];
  List<PostMessageModel> get postDataMessage => _postDataMessage;

  final List<PostMessageLikeModel> _postDataMessageLike = [];
  List<PostMessageLikeModel> get postDataMessageLike => _postDataMessageLike;

  List<PostModel> _mePostData = [];
  List<PostModel> get mePostData => _mePostData;

  PagePostModel? _pagePostData;

  //int? parentId;

  bool _isShowBackTop = false;
  bool get isShowBackTop => _isShowBackTop;

  final List<PostCardMediaModel> _postMediaList = [];
  List<PostCardMediaModel> get postMediaList => _postMediaList;

  /*List<PostBackgroundModel> _postBackgroundLists = [];*/
  List<PostBackgroundModel> get postBackgroundLists =>
      Utils.postBackgroundLists;

  int _postBackgroundId = 1;
  int get postBackgroundId => _postBackgroundId;

  void justRefresh() {
    notifyListeners();
  }

  //取得貼文數
  Future<void> getPostCnt([int? id, bool? isNotify]) async {
    Tuple<bool, String> r = await Api.getFriendData(id);
    if (r.i1!) {
      if (id == null) {
        //_friendDataCnt = FriendDataCntDTO.fromJson(r.i2!);
        _friendDataCnt = await Isolate.run(() => _friendDataCntData(r.i2!));
      } else {
        //_otherFriendDataCnt = FriendDataCntDTO.fromJson(r.i2!);
        _otherFriendDataCnt =
            await Isolate.run(() => _friendDataCntData(r.i2!));
      }
      if (isNotify == null) {
        notifyListeners();
      }
    }
  }

  //新增貼文
  Future<bool?> addNewPost(PostModel dto) async {
    String token = Auth.userLoginResDTO.body.token;
    Tuple<bool, String> r =
        await Isolate.run(() => postNewPost(dto.addPost(), token));
    getPostCnt();
    getMePost();
    findAllByPageDesc();
    _postMediaList.clear();
    return r.i1;
  }

  //取得上傳檔案陣列
  Future<String> getPics(List<PostCardMediaModel> postFiles) async {
    List<String> filenameList = [];
    await Future.forEach(postFiles, (element) async {
      String value = await _uploadFile(element.file, element.type) ?? '';
      if (value.isNotEmpty) {
        filenameList.add(value);
      }
    });
    return json.encode(filenameList);
  }

  //貼文總是取最新
  //下拉刷新用
  Future<bool> findAllByPage0Desc() async {
    GetPageDTO dto = const GetPageDTO(page: 0, size: 5, sortBy: 'created_at');
    Tuple<bool, String> r = await Api.postFindAllByPageDesc(dto.toMap());
    if (r.i1!) {
      bool isRefresh = false;
      log('findAllByPage0Desc: ${r.i2}');
      PagePostModel model = PagePostModel.fromJson(r.i2!);
      await Future.forEach(model.content, (element) {
        if (_postData.where((value) => element.id == value.id).isEmpty) {
          _postData.add(element);
          isRefresh = true;
        }
      });
      if (isRefresh) {
        _postData = List.from(
            _postData.toSet().where((element) => element.status == 1));
        _postData
            .sort((first, last) => last.createdAt.compareTo(first.createdAt));
        //貼文按讚
        await Future.forEach(_postData, (element) async {
          List<PostLikeModel>? data = await _getPostLike(element.id);
          if (data != null) {
            _postDataLike.addAll(data);
          }
        });

        //貼文留言
        await Future.forEach(_postData, (element) async {
          List<PostMessageModel>? data = await _getPostMessage(element.id);
          if (data != null) {
            _postDataMessage.addAll(data);
          }
        });

        _postDataLike = List.from(_postDataLike.toSet());

        _postDataMessage = List.from(_postDataMessage.toSet());
        //不然取了顯示不出來
        //await Future.delayed(const Duration(milliseconds: 100));
        notifyListeners();
      }

      /*_postData.forEach((element) async {
        if(element.pics.isNotEmpty){
          log('findAllByPage0Desc 這邊有呼叫嗎？');
          List<String> imageUrl = List<String>.from(json.decode(element.pics));
          if(imageUrl.length <= 1){
            //單張
            String url = imageUrl.first;
            if(Utils.videoFileVerification(url)){
              File file = await Isolate.run(() => _getVideoFile(url, Api.accessToken));
              log('影片儲存成功：${file.path}');
            }
          }
        }
      });*/
    }
    return r.i1!;
  }

  //取得貼文分頁資料 DESC
  Future<void> findAllByPageDesc([GetPageDTO? dto]) async {
    //SVProgressHUD.show();
    Tuple<bool, String> r =
        await Api.postFindAllByPageDesc((dto ?? _homeDTO).toMap());
    if (r.i1!) {
      getPostCnt(null, false);
      log('findAllByPageDesc: ${r.i2}');
      _pagePostData = PagePostModel.fromJson(r.i2!);
      if (_pagePostData == null) {
        return;
      }
      //放貼文 黑名單過濾
      _postData.addAll(List.from(await _filterPosts(_pagePostData!.content)));
      //_postData.addAll(List.from(_pagePostData!.content));
      _postData = List.from(_postData.toSet());
      _postData
          .sort((first, last) => last.createdAt.compareTo(first.createdAt));

      _homeDTO = _homeDTO.copyWith(page: _pagePostData!.pageable.pageNumber);
      //SVProgressHUD.dismiss();
      notifyListeners();

      //貼文按讚
      await Future.forEach(_postData, (element) async {
        List<PostLikeModel>? data = await _getPostLike(element.id);
        if (data != null) {
          _postDataLike.addAll(data);
        }
      });

      //貼文留言
      await Future.forEach(_postData, (element) async {
        List<PostMessageModel>? data = await _getPostMessage(element.id);
        if (data != null) {
          _postDataMessage.addAll(data);
        }
      });

      _postDataLike = List.from(_postDataLike.toSet());

      _postDataMessage = List.from(_postDataMessage.toSet());

      notifyListeners();
    } else {
      log('貼文取得失敗');
      findAllByPageDesc((dto ?? _homeDTO));
      //SVProgressHUD.dismiss();
    }
  }

  //取得單筆貼文資料
  Future<void> getSinglePostById(int postId) async {
    if (_postData.where((element) => element.id == postId).isEmpty) {
      _resultSinglePost(postId);
    } else {
      int index = _postData.indexWhere((element) => element.id == postId);
      _postData.removeAt(index);

      List<PostLikeModel> postLikes =
          _postDataLike.where((element) => element.postId == postId).toList();
      Future.forEach(postLikes, (element) => _postDataLike.remove(element));
      List<PostMessageModel> postMessages = _postDataMessage
          .where((element) => element.postId == postId)
          .toList();
      Future.forEach(
          postMessages, (element) => _postDataMessage.remove(element));

      _resultSinglePost(postId);
    }
  }

  void _resultSinglePost(int postId) async {
    String token = Auth.userLoginResDTO.body.token;
    Tuple<bool, String> r = await Isolate.run(() => getPostById(postId, token));
    //Tuple<bool, String> r = await Api.getPostById(postId);
    if (r.i1!) {
      PostModel post = PostModel.fromJson(r.i2!);
      if (post.status == 1) {
        _postData.add(post);
        _postData
            .sort((first, last) => last.createdAt.compareTo(first.createdAt));

        List<PostLikeModel>? like = await _getPostLike(postId);
        if (like != null) {
          _postDataLike.addAll(List.from(like.toSet()));
        }
        List<PostMessageModel>? message = await _getPostMessage(postId);
        if (message != null) {
          _postDataMessage.addAll(List.from(message.toSet()));
        }
        notifyListeners();
      }
    }
  }

  //檔案上傳
  Future<String?> _uploadFile(File? file, AssetType type) async {
    if (file != null) {
      Tuple<bool, String> r = await Api.uploadFile(Member.memberModel.name,
          file.path, PhotoType.values.byName(type.name));
      if (r.i1!) {
        log('uploadFile:${r.i2}');
        return r.i2;
      }
      return null;
    }
    return null;
  }

  //取得自己的貼文
  void getMePost() async {
    Tuple<bool, String> r = await Api.getPostByMemberId();
    if (r.i1!) {
      log('自己的貼文:${r.i2}');
      _mePostData = await Isolate.run(() => _getMePost(r.i2!));
      _mePostData
          .sort((first, last) => last.createdAt.compareTo(first.createdAt));
      notifyListeners();
    }
  }

  //修改文章內容
  void setPostBody(PostModel dto) async {
    getSinglePostById(dto.id);
    //自己文章的部分
    int index = _mePostData.indexWhere((element) => element.id == dto.id);
    _mePostData.removeAt(index);
    _mePostData.insert(index, dto);
    log('替換內容內部：${_mePostData.firstWhere((element) => element.id == element.id).body}');
    notifyListeners();
  }

  //取得貼文按讚
  Future<List<PostLikeModel>?> _getPostLike(int postId) async {
    Tuple<bool, String> r = await Api.getPostLikeByPostId(postId);
    if (r.i1!) {
      List list = json.decode(r.i2!);
      return list.map((e) => PostLikeModel.fromMap(e)).toList();
    }
    return null;
  }

  //按讚
  void addPostLike(PostModel data) async {
    PostLikeModel dto = PostLikeModel(
      likeType: LikeType.LOVE.index,
      memberId: Member.memberModel.id,
      postMemberId: data.memberId,
      postId: data.id,
      member: Member.memberModel,
    );
    log('按讚：${dto.toMap()}');
    Ws.stompClient
        .send(destination: Ws.addPostLike, body: json.encode(dto.toMap()));
  }

  //移除讚
  void removePostLike(int postLikeId) async {
    Tuple<bool, String> r = await Api.unPostLike(postLikeId);
    if (r.i1!) {
      if (json.decode(r.i2!)) {
        _postDataLike.removeWhere((element) => element.id == postLikeId);
      }
      if (AppRouter.config.location == RouteName.bottomNavigation) {
        notifyListeners();
      }
    }
  }

  //取得貼文留言
  Future<List<PostMessageModel>?> _getPostMessage(int postId) async {
    Tuple<bool, String> r = await Api.getPostMessageByPostId(postId);
    if (r.i1!) {
      List list = json.decode(r.i2!);
      return list
          .map((e) => PostMessageModel.fromMap(e))
          .where((element) => element.status == 1)
          .toList();
    }
    return null;
  }

  //新增貼文
  /*void addPostMessage(PostModel data, String message) async {
    PostMessageModel dto = PostMessageModel(
        memberId: Member.memberModel.id,
        postId: data.id,
        postMessageId: parentId ?? 0,
        postMemberId: data.memberId,
        message: message,
        member: Member.memberModel,
    );
    log('上傳：${dto.addMessage()}');
    Ws.stompClient.send(destination: Ws.addPostMessage, body: json.encode(dto.addMessage()));
  }*/

  //刪除貼文
  Future<bool> deletePost([int? id]) async {
    if (id != null) {
      Tuple<bool, String> r = await Api.deletePost(id);
      if (r.i1!) {
        //重整自己的貼文
        getMePost();
        //刪除貼文
        _postData.remove(_postData.where((element) => element.id == id).first);
        notifyListeners();
        return true;
      }
      return false;
    }
    return false;
  }

  /*void setParentId(int? id){
    parentId = id;
    notifyListeners();
  }*/

  //進入留言畫面
  /*void getThisPostMessageLike(int postId) async {
    _postDataMessageLike.clear();
    List<PostMessageLikeModel>? data = await _getPostMessageLike(postId);
    if(data != null){
      _postDataMessageLike.addAll(data);
    }
    notifyListeners();
  }*/

  //取得留言按讚
  /*Future<List<PostMessageLikeModel>?> _getPostMessageLike(int postId) async{
    Tuple<bool, String> r = await Api.getPostMessageLikeByPostId(postId);
    if(r.i1!){
      List list = json.decode(r.i2!);
      return list.map((e) => PostMessageLikeModel.fromMap(e)).toList();
    }
    return null;
  }*/

  //留言按讚
  /*void addPostMessageLike(PostMessageModel data) async {
    PostMessageLikeModel dto = PostMessageLikeModel(
        memberId: Member.memberModel.id,
        likeType: LikeType.LOVE,
        postId: data.postId,
        postMessageId: data.id,
        postMemberId: data.memberId
    );
    Tuple<bool, String> r = await Api.postPostMessageLike(dto.addMessageLike());
    if(r.i1!){
      //成功
      List<PostMessageLikeModel>? msgLike = await _getPostMessageLike(data.postId);
      if(msgLike != null){
        _postDataMessageLike.addAll(msgLike);
        _postDataMessageLike = List.from(_postDataMessageLike.toSet());
        notifyListeners();
      }
    }
  }*/

  //移除留言按讚
  void removePostMessageLike(int postMessageLikeId) async {
    Tuple<bool, String> r = await Api.deletePostMessageLike(postMessageLikeId);
    if (r.i1!) {
      if (json.decode(r.i2!)) {
        _postDataMessageLike
            .removeWhere((element) => element.id == postMessageLikeId);
      }
      notifyListeners();
    }
  }

  void setOffset() async {
    _homeDTO = _homeDTO.copyWith(page: _homeDTO.page + 1);
    //SVProgressHUD.show();
    await findAllByPageDesc(_homeDTO);
    //SVProgressHUD.dismiss();
  }

  //過濾貼文
  Future<List<PostModel>> _filterPosts(List<PostModel> list) async {
    if (BlackList.blacklist.isEmpty) {
      return list;
    }
    List<PostModel> newList = [];
    await Future.forEach(list, (element) {
      if (BlackList.blacklist
          .where((black) => black.targetMemberId == element.memberId)
          .isEmpty) {
        newList.add(element);
      }
    });
    return newList.where((element) => element.status == 1).toList();
  }

  void showBackTop(bool value) {
    _isShowBackTop = value;
    notifyListeners();
  }

  void addNewPoseLike(PostLikeModel dto) {
    _postDataLike.add(dto);
    if (AppRouter.config.location == RouteName.bottomNavigation) {
      notifyListeners();
    }
  }

  /*void addNewPostMessage(PostMessageModel dto) async {
    List<PostMessageModel>? list = await _getPostMessage(dto.postId);
    if(list != null){
      _postDataMessage.addAll(list);
    }
    _postDataMessage = List.from(_postDataMessage.toSet());
    notifyListeners();

    if(_controller != null){
      await Future.delayed(const Duration(milliseconds: 500));
      _controller!.animateTo(
          _controller!.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear);
    }
  }*/

  /*void setScrollController(ScrollController? controller){
    _controller = controller;
  }*/

  void setHomeScrollController(ScrollController? controller) {
    _homeController = controller;
  }

  void setPostMediaList(List<AssetEntity> result, [int? sharedPostId]) async {
    //一定要先複製一份 不然原本的會被清掉(目前不知道原因..
    List<AssetEntity> r = List.from(result);

    await Future.forEach(r, (element) async {
      File? file = await element.file;
      Uint8List? thumbnailData = await element.thumbnailData;
      _postMediaList.add(PostCardMediaModel(
          title: element.title,
          typeInt: element.typeInt,
          height: element.height,
          width: element.width,
          duration: element.duration,
          file: file,
          thumbnailData: thumbnailData,
          sharedPostId: sharedPostId ?? 0));
    });
    notifyListeners();
  }

  void setCropPostMediaList(List<File> result) async {
    List<File> r = List.from(result);
    log('result: ${result.first.path} ${r.length}');
    int j = 0;
    for (int i = 0; i < _postMediaList.length; i++) {
      if (_postMediaList[i].typeInt != AssetType.video.index) {
        Uint8List? thumbnailData = await r[j].readAsBytes();
        _postMediaList[i] = _postMediaList[i]
            .copyWith(file: r[j], thumbnailData: thumbnailData);
        j++;
      }
    }
    notifyListeners();
  }

  //關閉
  void closeNewPost() {
    _postMediaList.clear();
  }

  //*? 取得背景 发帖的背景图???
  Future<void> getAllPostBackground() async {
    String token = Auth.userLoginResDTO.body.token;
    Tuple<bool, String> r = await Isolate.run(() => getPostBackground(token));
    if (r.i1!) {
      log('取得背景 ${r.i2}');
      List list = json.decode(r.i2!);
      Utils.postBackgroundLists =
          list.map((e) => PostBackgroundModel.fromMap(e)).toList();
      notifyListeners();
    }
  }

  //取得分享碼
  Future<Tuple<bool, String>> getShareCode(int id) async {
    String token = Auth.userLoginResDTO.body.token;
    Tuple<bool, String> r =
        await Isolate.run(() => getPostShareCode(id, token));
    if (r.i1!) {
      String code = r.i2!.replaceAll('"', '');
      log('取得分享碼 $code');
      return Tuple<bool, String>(true, code);
    } else {
      return Tuple<bool, String>(false, '分享失敗');
    }
  }

  void setPostBackground(int id) {
    _postBackgroundId = id;
    notifyListeners();
  }

  void deleteThumbnailImage(PostCardMediaModel? value) {
    postMediaList.remove(value);
    notifyListeners();
  }

  void setPixels(double value) {
    if (_pixels != value) {
      _pixels = value;
    }
  }

  void jumpToPixels() {
    _homeController?.position.jumpTo(_pixels);
  }
}

FriendDataCntDTO _friendDataCntData(String value) {
  return FriendDataCntDTO.fromJson(value);
}

List<PostModel> _getMePost(String value) {
  List list = json.decode(value);
  return List.from(list
      .map((e) => PostModel.fromMap(e))
      .where((element) => element.status == 1)
      .toList());
}
