import 'dart:convert';
import 'dart:developer';

import 'package:ashera_pet_new/data/last_msg.dart';
import 'package:ashera_pet_new/data/pet.dart';
import 'package:ashera_pet_new/model/chat_room_member.dart';
import 'package:flutter/cupertino.dart';

import '../data/member.dart';
import '../enum/chat_type.dart';
import '../model/message.dart';
import '../utils/ws.dart';
import 'package:collection/collection.dart';

//聊天房間選擇那頁
class ChatMsgVm with ChangeNotifier {
  //當前聊天類型
  ChatType _type = ChatType.GENERAL;
  ChatType get type => _type;

  List<MessageModel> get lastMsgList =>
      LastMsg.lastMsgList.where((element) => element.chatType == type).toList();
  Map<int, List<MessageModel>> _petLastMsgList = {};
  Map<int, List<MessageModel>> get petLastMsgList => _petLastMsgList;

  List<MessageModel> _saveLastMsgList = [];

  //取得最後一則聊天訊息
  void lastChatMsgResp() {
    Ws.stompClient
        .send(destination: Ws.lastChatMessage, body: Member.memberModel.name);
    Ws.stompClient.send(
        destination: Ws.getChatRoomMemberSameRoomMembers,
        body: '${Member.memberModel.id}');
  }

  //整理最後一則訊息
  void tidyLastMsg(String value) async {
    List list = json.decode(value);
    //log('整理最後一則訊息 $value');
    List<MessageModel> rList = list
        .map((e) => MessageModel.fromMap(e))
        .where((element) =>
            element.block == false ||
            (element.fromMemberId == Member.memberModel.id &&
                element.block == true))
        .toList();
    rList.sort((first, last) => first.updatedAt.compareTo(last.updatedAt));
    await Future.forEach(rList, (element) {
      String otherMember = Member.memberModel.name == element.fromMember
          ? element.targetMember
          : element.fromMember;
      if (element.chatType == ChatType.GENERAL) {
        _general(otherMember, element);
      } else {
        _pet(otherMember, element);
      }
    });
    LastMsg.lastMsgList
        .sort((first, last) => last.updatedAt.compareTo(first.updatedAt));
    //notifyListeners();

    //_groupByPet();
  }

  void _general(String otherMember, MessageModel element) {
    //log('到底在幹嘛？${element.toMap()}');
    if (LastMsg.lastMsgList
        .where((element) =>
            (element.fromMember == otherMember ||
                element.targetMember == otherMember) &&
            element.chatType == ChatType.GENERAL)
        .isEmpty) {
      LastMsg.lastMsgList.add(element);
      //log('直接新增：${element.toMap()}');
      //_tidyShowRoom();
    } else {
      LastMsg.lastMsgList.remove(LastMsg.lastMsgList
          .where((element) =>
              (element.fromMember == otherMember ||
                  element.targetMember == otherMember) &&
              element.chatType == ChatType.GENERAL)
          .first);
      LastMsg.lastMsgList.add(element);
      //log('刪除後新增：${element.toMap()}');
      //_tidyShowRoom();
    }
  }

  void _pet(String otherMember, MessageModel element) {
    if (LastMsg.lastMsgList
        .where((element) =>
            (element.fromMember == otherMember ||
                element.targetMember == otherMember) &&
            element.chatType == ChatType.PET &&
            element.memberPetId == element.memberPetId)
        .isEmpty) {
      LastMsg.lastMsgList.add(element);
      //_tidyShowRoom();
    } else {
      LastMsg.lastMsgList.remove(LastMsg.lastMsgList
          .where((element) =>
              (element.fromMember == otherMember ||
                  element.targetMember == otherMember) &&
              element.chatType == ChatType.PET &&
              element.memberPetId == element.memberPetId)
          .first);
      LastMsg.lastMsgList.add(element);
      //_tidyShowRoom();
    }
  }

  void setType(ChatType newType) {
    _type = newType;
    notifyListeners();
  }

  //取得所有聊天室
  void getAllChatRoomMembers(String value) async {
    List list = json.decode(value);
    List<ChatRoomMemberModel> data =
        list.map((e) => ChatRoomMemberModel.fromMap(e)).toList();
    _chatRoomOrganization(data);
    /*ChatRoomMemberDTO dto = ChatRoomMemberDTO(
        memberId: Member.memberModel.id, chatType: ChatType.GENERAL);
    Ws.stompClient.send(destination: Ws.getChatRoomMemberSameRoomMembers, body: json.encode(dto.toMap()));*/

    /*String token = Auth.userLoginResDTO.body.token;
    Tuple<bool, String> r = await Isolate.run(() => getSameRoomMembersByMemberId(dto, token));*/

    /*if(r.i1!){
      List list = json.decode(r.i2!);
      List<ChatRoomMemberModel> data = list.map((e) => ChatRoomMemberModel.fromMap(e)).toList();
      _chatRoomOrganization(data);
    }*/
  }

  //聊天室整理
  void _chatRoomOrganization(List<ChatRoomMemberModel> data) async {
    log('聊天室整理');
    List<ChatRoomMemberModel> copyData = List<ChatRoomMemberModel>.from(
            data.where((element) => element.memberId != Member.memberModel.id))
        .toList();
    if (data.isEmpty) {
      LastMsg.chatRoomMembers.addAll(List<ChatRoomMemberModel>.from(copyData));
      _tidyShowRoom();
    } else {
      await Future.forEach(copyData, (element) {
        if (!LastMsg.chatRoomMembers.contains(element)) {
          //新增
          LastMsg.chatRoomMembers.add(element);
        }
      });
      _tidyShowRoom();
    }
  }

  //依照寵物Group
  void _groupByPet() async {
    if (Pet.allPets.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 2000));
      _groupByPet();
    } else {
      List<MessageModel> list = List<MessageModel>.from(LastMsg.lastMsgList
          .where((element) => element.chatType == ChatType.PET)
          .where((element) => element.memberPetId != 0)
          .toList());
      List<MessageModel> canDeleteModels = [];
      await Future.forEach(list, (room) {
        if (Pet.allPets
            .where((element) => element.id == room.memberPetId)
            .isEmpty) {
          log('deleteRoom: ${room.memberPetId}');
          canDeleteModels.add(room);
        }
      });
      await Future.forEach(canDeleteModels, (element) => list.remove(element));
      _petLastMsgList = _groupItemsByPetId(list);
      notifyListeners();
      canDeleteModels.clear();
    }
  }

  Map<int, List<MessageModel>> _groupItemsByPetId(List<MessageModel> items) {
    return groupBy(items, (item) => item.memberPetId);
  }

  //刪除聊天室
  void sendDeleteChatRoom(int chatRoomId) {
    Ws.stompClient.send(destination: Ws.deleteChatRoom, body: '$chatRoomId');
  }

  void deleteChatRoom(ChatRoomModel dto) async {
    if (LastMsg.lastMsgList
        .where((element) => element.chatRoomId == dto.id)
        .isNotEmpty) {
      int index = LastMsg.lastMsgList
          .indexWhere((element) => element.chatRoomId == dto.id);
      LastMsg.lastMsgList.removeAt(index);
      _groupByPet();
      notifyListeners();
    }
  }

  //總整理房外顯示
  void _tidyShowRoom() async {
    //LastMsg.lastMsgList.forEach((f) => log('lastMsg: ${f.toMap()}'));
    //LastMsg.chatRoomMembers.forEach((f) => log('chatRoomMembers: ${f.toMap()}'));

    if (_saveLastMsgList.isNotEmpty) {
      LastMsg.lastMsgList.addAll(List.from(_saveLastMsgList));
    }
    //如果最後一筆訊息不為空
    if (LastMsg.lastMsgList.isNotEmpty) {
      //如果聊天室不為空
      if (LastMsg.chatRoomMembers.isNotEmpty) {
        //比對 有的就留下
        log('比對 有的就留下');
        List<MessageModel> deleteRoom = [];
        await Future.forEach(LastMsg.lastMsgList, (f) {
          if (LastMsg.chatRoomMembers
              .where((e) => e.chatRoomId == f.chatRoomId)
              .isEmpty) {
            log('加入刪除：${f.toMap()}');
            deleteRoom.add(f);
          }
        });
        await Future.forEach(deleteRoom, (f) {
          LastMsg.lastMsgList.remove(f);
        });
        notifyListeners();
        _groupByPet();
      } else {
        //聊天室是空的 直接清空
        _saveLastMsgList = List.from(LastMsg.lastMsgList);
        LastMsg.lastMsgList.clear();
        notifyListeners();
        _groupByPet();
      }
    }
  }
}
