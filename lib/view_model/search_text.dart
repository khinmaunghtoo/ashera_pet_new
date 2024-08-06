import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:ashera_pet_new/enum/member_status.dart';
import 'package:ashera_pet_new/model/tuple.dart';
import 'package:ashera_pet_new/utils/api.dart';
import 'package:flutter/cupertino.dart';

import '../data/auth.dart';
import '../model/member_pet.dart';
import '../model/member_view.dart';
import '../model/search_contains.dart';
import '../model/search_member.dart';

class SearchTextVm with ChangeNotifier {
  late TextEditingController controller;
  late FocusNode focusNode;
  bool _isHasFocus = false;
  bool get isHasFocus => _isHasFocus;

  bool _isSearchTextEmpty = true;
  bool get isSearchTextEmpty => _isSearchTextEmpty;

  bool get isMasonryGrid => _setMasonryGrid();
  bool get isSearchRecord => _setSearchRecord();
  bool get isSearchData => _setSearchData();

  List<MemberPetModel> _petList = [];
  List<MemberPetModel> get petList => _petList;
  List<SearchMember> _memberList = [];

  void textAddListener(TextEditingController value, FocusNode focus) {
    controller = value;
    focusNode = focus;
    controller.addListener(_listener);
    focusNode.addListener(_focusListener);
  }

  void _focusListener() {
    if (focusNode.hasFocus) {
      _isHasFocus = true;
      notifyListeners();
    } else {
      _isHasFocus = false;
      notifyListeners();
    }
  }

  void _listener() {
    if (controller.text.trim().isNotEmpty) {
      //有值
      _isSearchTextEmpty = false;
      notifyListeners();
      _searchText();
    } else {
      //無值
      _isSearchTextEmpty = true;
      notifyListeners();
    }
  }

  void _searchText() async {
    SearchContainsDTO dto = SearchContainsDTO(qs: controller.text);
    String token = Auth.userLoginResDTO.body.token;
    List<Tuple<bool, String>> r = await Future.wait([
      //Api.getMemberByNicknameContains(dto.toMap()),
      Isolate.run(() => getMemberByNicknameContains(dto.toMap(), token)),
      //Api.getPetByNicknameContains(dto.toMap())
      Isolate.run(() => getPetByNicknameContains(dto.toMap(), token))
    ]);
    if (r[0].i1! && r[1].i1!) {
      log('Search Member: ${r[0].i2}');
      List memberList = json.decode(r[0].i2!);
      _memberList = memberList.map((e) => SearchMember.fromMap(e)).toList();
      //log('Search Pet: ${r[1].i2}');
      List petList = json.decode(r[1].i2!);
      _petList = petList.map((e) => MemberPetModel.fromMap(e)).toList();
      for (var element in _memberList) {
        if (element.memberPet.isEmpty) {
          MemberPetModel pet = MemberPetModel(
              id: 0,
              memberId: element.id,
              mugshot: '',
              nickname: '沒有寵物',
              aboutMe: '',
              age: 0,
              birthday: '',
              animalType: 0,
              gender: 0,
              healthStatus: 0,
              member: MemberView.fromMap(element.toMap()),
              status: MemberStatus.ACTIVE);
          //已經加入的就不再加入
          if (_petList.where((e) => e.memberId == pet.memberId).isEmpty) {
            _petList.add(pet);
          }
        } else {
          MemberPetModel pet = MemberPetModel(
              id: element.memberPet.first.id,
              memberId: element.id,
              mugshot: element.memberPet.first.mugshot,
              nickname: element.memberPet.first.nickname,
              aboutMe: '',
              age: 0,
              birthday: element.memberPet.first.birthday,
              animalType: 0,
              gender: element.memberPet.first.gender,
              healthStatus: 0,
              member: MemberView.fromMap(element.toMap()),
              status: MemberStatus.ACTIVE);
          //已經加入的就不再加入
          if (_petList.where((e) => e.memberId == pet.memberId).isEmpty) {
            _petList.add(pet);
          }
        }
      }
      notifyListeners();
    }
    //會員
    //Tuple<bool, String> r = await Api.getMemberByNicknameContains(dto.toMap());
    //寵物
    //Tuple<bool, String> r = await Api.getPetByNicknameContains(dto.toMap());

    /*if(r.i1!){
      log('Search Pet: ${r.i2}');
      List list = json.decode(r.i2!);
      _petList = list.map((e) => MemberPetModel.fromMap(e)).toList();
      notifyListeners();
    }*/
  }

  void textDispose() {
    _isHasFocus = false;
    _isSearchTextEmpty = true;
    controller.dispose();
  }

  //隨機貼文
  bool _setMasonryGrid() {
    return (!_isHasFocus && _isSearchTextEmpty);
  }

  //最近搜尋紀錄
  bool _setSearchRecord() {
    return (_isHasFocus && _isSearchTextEmpty);
  }

  //顯示搜尋結果
  bool _setSearchData() {
    return (_isHasFocus && !_isSearchTextEmpty) ||
        (!_isHasFocus && !_isSearchTextEmpty);
  }
}
