import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';

import '../data/auth.dart';
import '../data/member.dart';
import '../enum/like_type.dart';
import '../model/post.dart';
import '../model/post_like.dart';
import '../model/post_message.dart';
import '../model/post_message_like.dart';
import '../model/tuple.dart';
import '../routes/app_router.dart';
import '../routes/route_name.dart';
import '../utils/api.dart';
import '../utils/ws.dart';

class CommentsVm extends ChangeNotifier {
  ScrollController? _controller;
  GlobalKey<SliverAnimatedListState> get commentKey =>
      GlobalKey<SliverAnimatedListState>();

  List<PostModel> _postData = [];
  List<PostModel> get postData => _postData;

  final List<PostLikeModel> _postDataLike = [];
  List<PostLikeModel> postDataLike(int id) =>
      _postDataLike.where((e) => e.postId == id).toList();
  List<PostMessageModel> _postDataMessage = [];
  List<PostMessageModel> get postDataMessage => _postDataMessage;

  final List<PostMessageLikeModel> _postDataMessageLike = [];
  List<PostMessageLikeModel> get postDataMessageLike => _postDataMessageLike;

  int? parentId;

  bool _loading = false;
  bool get loading => _loading;

  void setPostData(List<PostModel> postData) {
    _postData = postData;
  }

  void getThisPostMessageLike(int postId) async {
    /*_postDataMessageLike.clear();
    List<PostMessageLikeModel>? data = await _getPostMessageLike(postId);
    if(data != null){
      _postDataMessageLike.addAll(data);
    }
    notifyListeners();*/
  }

  //新增貼文留言
  void addPostMessage(PostModel data, String message) async {
    PostMessageModel dto = PostMessageModel(
      memberId: Member.memberModel.id,
      postId: data.id,
      postMessageId: parentId ?? 0,
      postMemberId: data.memberId,
      message: message,
      member: Member.memberModel,
    );
    log('上傳：${dto.addMessage()}');
    Ws.stompClient.send(
        destination: Ws.addPostMessage, body: json.encode(dto.addMessage()));
  }

  void setParentId(int? id) {
    parentId = id;
    notifyListeners();
  }

  //取得留言按讚
  Future<List<PostMessageLikeModel>?> _getPostMessageLike(int postId) async {
    Tuple<bool, String> r = await Api.getPostMessageLikeByPostId(postId);
    if (r.i1!) {
      List list = json.decode(r.i2!);
      return list.map((e) => PostMessageLikeModel.fromMap(e)).toList();
    }
    return null;
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
    _loading = true;
    String token = Auth.userLoginResDTO.body.token;
    Tuple<bool, String> r = await Isolate.run(() => getPostById(postId, token));
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
        _loading = false;
        notifyListeners();
      }
    } else {
      _loading = false;
      notifyListeners();
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

  //取得貼文按讚
  Future<List<PostLikeModel>?> _getPostLike(int postId) async {
    Tuple<bool, String> r = await Api.getPostLikeByPostId(postId);
    if (r.i1!) {
      List list = json.decode(r.i2!);
      return list.map((e) => PostLikeModel.fromMap(e)).toList();
    }
    return null;
  }

  void setScrollController(ScrollController? controller) {
    _controller = controller;
  }

  void addNewPostMessage(PostMessageModel dto) async {
    List<PostMessageModel>? list = await _getPostMessage(dto.postId);
    if (list != null) {
      _postDataMessage.addAll(list);
    }
    _postDataMessage = List.from(_postDataMessage.toSet());
    notifyListeners();

    if (_controller != null) {
      await Future.delayed(const Duration(milliseconds: 500));
      _controller!.animateTo(_controller!.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200), curve: Curves.linear);
    }
  }

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
      if (AppRouter.currentLocation == RouteName.comments) {
        notifyListeners();
      }
    }
  }

  void addNewPoseLike(PostLikeModel dto) {
    _postDataLike.add(dto);
    if (AppRouter.currentLocation == RouteName.comments) {
      notifyListeners();
    }
  }
}
