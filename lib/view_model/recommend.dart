import 'dart:convert';
import 'dart:developer';

import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/utils/api.dart';
import 'package:flutter/cupertino.dart';

import '../model/recommend_member.dart';
import '../model/tuple.dart';

class RecommendFriendVm extends ChangeNotifier {
  List<RecommendMemberModel> _recommendList = [];
  List<RecommendMemberModel> get recommendList => _recommendList;

  void getRecommendMember([int? id]) async {
    Tuple<bool, String> r = await Api.getRecommendMember(id);
    if (r.i1!) {
      log('r.i2!${r.i2}');
      List list = json.decode(r.i2!);
      if (list.isNotEmpty) {
        _recommendList = list
            .map((e) => RecommendMemberModel.fromMap(e))
            .where(
                (element) => element.recommendMemberId != Member.memberModel.id)
            .toList();
      }
    }
  }
}
