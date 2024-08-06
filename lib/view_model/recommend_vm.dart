import 'dart:developer';
import 'dart:math' as math;

import 'package:ashera_pet_new/utils/api.dart';
import 'package:flutter/material.dart';

import '../model/post.dart';
import '../model/tuple.dart';

class RecommendVm extends ChangeNotifier {
  List<PostModel> _postData = [];
  List<PostModel> get postData => _postData;

  String _sortBy = 'created_at';

  GetPageDTO dto = const GetPageDTO(
    page: 0,
    size: 5,
    sortBy: 'created_at',
  );

  //取貼文
  Future<bool> findAllByPage() async {
    dto = dto.copyWith(page: 0, sortBy: _sortBy);

    Tuple<bool, String> r = await Api.postFindAllByPageDesc(dto.toMap());
    if (r.i1!) {
      bool isRefresh = false;
      log('findAllByPage: ${r.i2}');
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
        notifyListeners();
      }
    }
    return r.i1!;
  }

  Future<bool> loadMore() async {
    int page = dto.page;
    dto = dto.copyWith(page: page += 1);
    log('page: ${dto.page}');
    Tuple<bool, String> r = await Api.postFindAllByPageDesc(dto.toMap());
    if (r.i1!) {
      bool isRefresh = false;
      log('findAllByPage: ${r.i2}');
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
        //_postData.sort((first, last) => last.createdAt.compareTo(first.createdAt));
        notifyListeners();
      }
    }
    return r.i1!;
  }

  void setSortBy() {
    _postData.clear();
    _sortBy = getSortBy();
    log('使用什麼條件：$_sortBy');
    findAllByPage();
  }

  String getSortBy() {
    int i = math.Random().nextInt(5);
    switch (i) {
      case 0:
        return 'id';
      case 1:
        return 'body';
      case 2:
        return 'member_id';
      case 3:
        return 'pics';
      case 4:
        return 'created_at';
      default:
        return 'updated_at';
    }
  }
}
