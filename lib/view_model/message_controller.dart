import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:ashera_pet_new/data/auth.dart';
import 'package:ashera_pet_new/db/app_db.dart';
import 'package:ashera_pet_new/enum/chat_type.dart';
import 'package:ashera_pet_new/enum/member_status.dart';
import 'package:ashera_pet_new/utils/shared_preference.dart';
import 'package:collection/collection.dart';
import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/model/member.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../data/last_msg.dart';
import '../data/pet.dart';
import '../enum/message_type.dart';
import '../enum/photo_type.dart';
import '../model/chat_room_member.dart';
import '../model/member_pet.dart';
import '../model/message.dart';
import '../model/tuple.dart';
import '../utils/api.dart';
import '../utils/utils.dart';
import '../utils/ws.dart';
import 'package:uuid/uuid.dart';

class MessageControllerVm with ChangeNotifier {
  List<MessageModel> _data = [];
  List<MessageModel> _sqliteData = [];
  List<MemberPetModel> _petLists = [];
  List<MemberPetModel> get petLists => _petLists;
  Map<String, List<MessageModel>> grouped = {};
  final DateFormat format = DateFormat("MM/dd");

  //顯示寵物資料
  bool _isShowPetData = true;
  bool get isShowPetData => _isShowPetData;

  bool _isInit = true;

  int _offset = 0;
  int get offset => _offset;

  int _copyOffset = 0;

  int _totalPages = 0;
  int _page = 0;

  late PageMessageModel pageMessageModel;

  MessageModel? lastMsg;

  late ScrollController _controller;
  late ItemScrollController _itemScrollController;

  late int _chatRoomId;
  int get chatRoomId => _chatRoomId;

  late ChatType chatType;
  late int _petId;
  MemberAndMsgLast? _userData;

  bool _isInRoom = false;
  bool get isInRoom => _isInRoom;

  MemberModel _getTargetMember(MessageModel model) {
    if (model.fromMemberId == Member.memberModel.id) {
      return MemberModel.fromMap(model.targetMemberView!.toMap());
    } else {
      return MemberModel.fromMap(model.fromMemberView!.toMap());
    }
  }

  Future<MemberModel> _getOnlineTargetMember(int id) async {
    Tuple<bool, String> r = await Api.getMemberData(id);
    return MemberModel.fromJson(r.i2!);
  }

  //判斷是否有建立過房間
  Future<void> _determineIfARoomHasBeenBuilt(MemberAndMsgLast userData) async {
    chatType = userData.chatType;
    _userData = userData;
    _chatRoomId = 0;
    _petId = 0;
    if (userData.chatType == ChatType.GENERAL) {
      List<Map<String, dynamic>> chatRoom = await AppDB.getTableData(
          AppDB.messageRoomTable,
          'memberId = ? AND chatType = ?',
          ['${userData.member.id}', ChatType.GENERAL.name]);
      if (chatRoom.isNotEmpty) {
        log('內容：${chatRoom.first}');
        ChatRoomMemberModel model = ChatRoomMemberModel.fromMap(chatRoom.first);
        _chatRoomId = model.chatRoomId;
      } else {
        if (LastMsg.chatRoomMembers
            .where((element) =>
                element.memberId == userData.member.id &&
                element.chatType == ChatType.GENERAL)
            .isNotEmpty) {
          log('有建立聊天室');
          log('chatRoomId: ${LastMsg.chatRoomMembers.firstWhere((element) => element.memberId == userData.member.id && element.chatType == ChatType.GENERAL).chatRoomId}');
          _chatRoomId = LastMsg.chatRoomMembers
              .firstWhere((element) =>
                  element.memberId == userData.member.id &&
                  element.chatType == ChatType.GENERAL)
              .chatRoomId;
        } else {
          //未建立
          //先建立房間
          log('未建立聊天室');
          _createdChatRoom(userData);
        }
      }
    } else if (userData.chatType == ChatType.PET) {
      if (userData.chatRoomId != null) {
        _chatRoomId = userData.chatRoomId!;
        _petId = userData.pet!.id;
      } else {
        List<Map<String, dynamic>> chatRoom = await AppDB.getTableData(
            AppDB.messageRoomTable,
            'memberId = ? AND memberPetId = ? AND chatType = ?', [
          '${userData.member.id}',
          '${userData.pet!.id}',
          ChatType.PET.name
        ]);
        if (chatRoom.isNotEmpty) {
          log('內容：${chatRoom.first}');
          ChatRoomMemberModel model =
              ChatRoomMemberModel.fromMap(chatRoom.first);
          _chatRoomId = model.chatRoomId;
          _petId = model.memberPetId;
        } else {
          //是否建立寵物關聯
          if (LastMsg.chatRoomMembers
              .where((element) =>
                  element.memberId == userData.member.id &&
                  element.memberPetId ==
                      (userData.pet == null
                          ? userData.msg!.memberPetId
                          : userData.pet!.id) &&
                  element.chatType == ChatType.PET)
              .isNotEmpty) {
            log('有建立聊天室');
            _chatRoomId = LastMsg.chatRoomMembers
                .firstWhere((element) =>
                    element.memberId == userData.member.id &&
                    element.memberPetId ==
                        (userData.pet == null
                            ? userData.msg!.memberPetId
                            : userData.pet!.id) &&
                    element.chatType == ChatType.PET)
                .chatRoomId;
            _petId = LastMsg.chatRoomMembers
                .firstWhere((element) =>
                    element.memberId == userData.member.id &&
                    element.chatRoomId == _chatRoomId &&
                    element.chatType == ChatType.PET)
                .memberPetId;

            log('_chatRoomId $_chatRoomId');
          } else {
            log('未建立聊天室 pet');
            if (userData.pet != null) {
              _petId = userData.pet!.id;
              _createdChatRoom(userData);
            }
          }
        }
      }
    }
  }

  void _createdChatRoom(MemberAndMsgLast userData) {
    ChatRoomModel dto = ChatRoomModel(
        memberId: Member.memberModel.id,
        uuid:
            '${Member.memberModel.id}-${userData.member.id}-${const Uuid().v4()}',
        status: MemberStatus.ACTIVE,
        chatType: userData.chatType,
        memberPetId: userData.pet == null ? 0 : userData.pet!.id);
    Ws.stompClient.send(
        destination: Ws.addChatRoom,
        body: json.encode(dto.createdChatRoomMap()));
  }

  void getCreatedChatRoom(String value) async {
    ChatRoomModel dto = ChatRoomModel.fromJson(value);
    if (chatType == ChatType.GENERAL) {
      _addChatRoomMember(dto, _userData!);
    } else {
      ChatRoomMemberModel dtoMe = ChatRoomMemberModel(
          memberId: Member.memberModel.id,
          chatRoomId: dto.id,
          chatType: dto.chatType);
      await Api.addChatRoomMembers(dtoMe);
      _addChatRoomMemberPet(dto, _userData!);
    }
  }

  void _addChatRoomMember(
      ChatRoomModel model, MemberAndMsgLast userData) async {
    ChatRoomMemberModel dtoOther = ChatRoomMemberModel(
        memberId: userData.member.id,
        chatRoomId: model.id,
        chatType: model.chatType);
    ChatRoomMemberModel dtoMe = ChatRoomMemberModel(
        memberId: Member.memberModel.id,
        chatRoomId: model.id,
        chatType: model.chatType);
    log('addChatRoomMember上傳內容: ${dtoOther.addMember()}');
    //加入關聯會員
    Ws.stompClient.send(
        destination: Ws.addChatRoomMember,
        body: json.encode(dtoMe.addMember()));
    Ws.stompClient.send(
        destination: Ws.addChatRoomMember,
        body: json.encode(dtoOther.addMember()));
  }

  void insertAppDB(String value) async {
    ChatRoomMemberModel model = ChatRoomMemberModel.fromJson(value);
    log('addChatRoomMember: ${model.toMap()}');
    if (model.memberId == _userData!.member.id) {
      await AppDB.insert(AppDB.messageRoomTable, model.addMemberToDB());
      _chatRoomId = model.chatRoomId;
      _determineTheTypeOfRoom(_userData!);
    }
  }

  void _addChatRoomMemberPet(
      ChatRoomModel model, MemberAndMsgLast userData) async {
    ChatRoomMemberModel dto = ChatRoomMemberModel(
        memberId: userData.member.id,
        memberPetId: userData.pet!.id,
        chatRoomId: model.id,
        chatType: model.chatType);
    log('addChatRoomMemberPet上傳內容: ${dto.addMemberAndPet()}');
    //加入關聯會員寵物
    Ws.stompClient.send(
        destination: Ws.addChatRoomMember,
        body: json.encode(dto.addMemberAndPet()));
  }

  //判斷房間類型
  void _determineTheTypeOfRoom(MemberAndMsgLast userData) async {
    if (userData.chatType == ChatType.GENERAL) {
      //普通
    } else if (userData.chatType == ChatType.PET) {
      //寵物
      if (Pet.allPets.where((element) => element.id == _petId).isNotEmpty) {
        _petLists = List<MemberPetModel>.from(
            [Pet.allPets.firstWhere((element) => element.id == _petId)]);
        notifyListeners();
      }
    }
  }

  void initOtherMemberData(MemberAndMsgLast userData) async {
    //判斷是否有建立過房間
    await _determineIfARoomHasBeenBuilt(userData);
    _determineTheTypeOfRoom(userData);
    _isShowPetData = true;
    _isInit = true;
    Future.delayed(const Duration(milliseconds: 1000), () => _isInit = false);
    log('init ${DateTime.now()}');
    if (userData.msg != null) {
      Member.nowChatMemberModel = _getTargetMember(userData.msg!);
    } else {
      Member.nowChatMemberModel =
          await _getOnlineTargetMember(userData.member.id);
    }

    if (LastMsg.lastMsgList
        .where((element) =>
            element.fromMemberId == userData.member.id ||
            element.targetMemberId == userData.member.id)
        .isNotEmpty) {
      lastMsg = LastMsg.lastMsgList
          .where((element) =>
              element.fromMemberId == userData.member.id ||
              element.targetMemberId == userData.member.id)
          .first;
    }
    log('initDone ${DateTime.now()}');
    msgData();
  }

  //進房讀資料
  void msgData([int? page, int? size]) async {
    if (Member.nowChatMemberModel == null) {
      return;
    }
    log('msgDataInit ${DateTime.now()} $_chatRoomId ${Member.nowChatMemberModel!.name} ${chatType.name}');
    //先找db有沒有
    List<Map<String, dynamic>> record = await AppDB.getTableData(
      AppDB.msgTable,
      '(fromMember = ? OR targetMember = ?) AND chatType = ? AND chatRoomId = ?',
      [
        Member.nowChatMemberModel!.name,
        Member.nowChatMemberModel!.name,
        chatType.name,
        '$_chatRoomId'
      ],
      12,
      'createdAt DESC',
    );
    if (record.isNotEmpty) {
      log('讀取本地資料並確認與最後一筆是否符合');
      //讀取本地資料並確認與最後一筆是否符合
      _sqliteData = _tidyAndSort(record);
      _sqliteData
          .sort((first, last) => first.createdAt.compareTo(last.createdAt));
      if (lastMsg != null) {
        if (_sqliteData.last != lastMsg) {
          //取得最新
          log('取線上最新 ${DateTime.now()}');
          _getOnlineNewMsg(page, size);
        } else {
          log('顯示現有 ${DateTime.now()}');
          readMsg();
          _getOnlineNewMsg();
        }
      }
    } else {
      log('沒有的話就取線上最新 ${DateTime.now()}');
      //沒有的話就取線上最新
      //打stomp確認
      _getOnlineNewMsg(page, size);
    }
  }

  void _getOnlineNewMsg([int? page, int? size]) {
    GetChatMassageDTO dto = GetChatMassageDTO(
        fromMember: Member.memberModel.name,
        targetMember: Member.nowChatMemberModel!.name,
        page: page ?? 0,
        size: size ?? 15,
        sortBy: 'created_at');
    Ws.stompClient
        .send(destination: Ws.getChatMessagePageDesc, body: dto.toJson());
  }

  //收到的最後一筆 判斷是不是屬於現在需要刷新的
  void addJudgmentData(String value) {
    if (value.isNotEmpty && Member.nowChatMemberModel != null) {
      MessageModel data = MessageModel.fromJson(value);
      //判斷
      if (data.targetMember == Member.nowChatMemberModel!.name ||
          data.fromMember == Member.nowChatMemberModel!.name) {
        //是這個聊天室的
        _getOnlineNewMsg(0, 1);
      }
    }
  }

  //整理線上取下來的
  void tidyMessagePage(String value) {
    pageMessageModel = PageMessageModel.fromJson(value);
    //底下要再處理不能直接 接了就丟出來
    log('解析結果：${pageMessageModel.toMap()}');
    _data = List.from(pageMessageModel.content
        .where((element) =>
            element.block == false ||
            (element.fromMemberId == Member.memberModel.id &&
                element.block == true))
        .toList());
    _totalPages = pageMessageModel.totalPages ?? 0;
    _page = pageMessageModel.pageable.pageNumber;
    if (_data.isEmpty) {
      return;
    }
    _saveDB(_data);
  }

  //儲存到本地
  void _saveDB(List<MessageModel> list) async {
    log('儲存到本地');
    bool isAddNew = false;
    await Future.forEach(list, (element) async {
      if (_sqliteData.where((db) => db.id == element.id).isEmpty) {
        await AppDB.insert(AppDB.msgTable, element.toDB());
        log('新增：${element.toDB()}');
        isAddNew = true;
      } else {
        //如果是沒已讀才修改
        if (_sqliteData
            .where((db) => db.isRead == 0 && element.id == db.id)
            .isNotEmpty) {
          await AppDB.update(AppDB.msgTable, 'id = ?', ['${element.id}'],
              element.upDateIsRead());
          log('修改');
          isAddNew = false;
        }
      }
    });
    if (isAddNew) {
      _copyOffset = _offset;
      _offset = 0;
    }
    readMsg();
  }

  //整理與排序
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

  //讀取
  void readMsg() async {
    log('讀取和整理');
    List<Map<String, dynamic>> record = await AppDB.getTableData(
        AppDB.msgTable,
        '(fromMember = ? OR targetMember = ?) AND chatType = ? AND chatRoomId = ?',
        [
          Member.nowChatMemberModel!.name,
          Member.nowChatMemberModel!.name,
          chatType.name,
          '$_chatRoomId'
        ],
        12,
        'createdAt DESC',
        _offset);
    if (record.isNotEmpty) {
      List<MessageModel> msgList = _tidyAndSort(record);
      await Future.forEach(msgList, (element) {
        if (_sqliteData.where((db) => db.id == element.id).isEmpty) {
          _sqliteData.add(element);
        } else {
          _sqliteData.removeWhere((db) => db.id == element.id);
          _sqliteData.add(element);
        }
      });
      _sqliteData = List.from(_sqliteData.toSet());
      _sqliteData
          .sort((first, last) => first.createdAt.compareTo(last.createdAt));
      grouped = groupBy<MessageModel, String>(_sqliteData, (messages) {
        String time =
            format.format(Utils.sqlDateFormatTest.parse(messages.createdAt));
        return time;
      });
      notifyListeners();
      _offset = _copyOffset;
      await Future.delayed(const Duration(milliseconds: 500));
      if (_controller.positions.isNotEmpty) {
        if (_controller.offset != _controller.position.maxScrollExtent) {
          _controller.animateTo(_controller.position.maxScrollExtent,
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
        }
      }
      if (_itemScrollController.isAttached) {
        _itemScrollController.scrollTo(
            index: _sqliteData.length,
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease);
      }
    }
  }

  //新增
  void addMsg(MemberModel other, String text, MessageType type) async {
    MessageModel dto = MessageModel(
        fromMember: Member.memberModel.name,
        fromMemberId: Member.memberModel.id,
        targetMember: other.name,
        targetMemberId: other.id,
        content: text,
        type: type,
        chatRoomId: _chatRoomId,
        chatType: chatType,
        memberPetId: _petId);
    if (Ws.stompClient.connected && _chatRoomId != 0) {
      Ws.stompClient
          .send(destination: Ws.sendMsg, body: json.encode(dto.toWs()));
    } else {
      await Future.delayed(const Duration(milliseconds: 1000));
      addMsg(other, text, type);
    }
  }

  //清除otherMember
  void removeOtherMember() {
    Member.nowChatMemberModel = null;
    _offset = 0;
    _copyOffset = 0;
    grouped.clear();
    _sqliteData.clear();
    _petLists.clear();
  }

  void setShowPetData(bool value) {
    if (_isInit) {
      return;
    }
    if (value) {
      if (_isShowPetData) {
        _isShowPetData = false;
        notifyListeners();
        SharedPreferenceUtil.saveRecordTheScrollLastTime(
            DateTime.now().millisecondsSinceEpoch);
        Future.delayed(const Duration(milliseconds: 2000), () async {
          int timestamp =
              await SharedPreferenceUtil.readRecordTheScrollLastTime();
          if (DateTime.now()
                  .difference(DateTime.fromMillisecondsSinceEpoch(timestamp))
                  .inSeconds >
              1.5) {
            //顯示
            _isShowPetData = true;
            notifyListeners();
          }
        });
      }
    }
  }

  //移至最底
  void setScrollController(ScrollController controller) {
    _controller = controller;
  }

  void setItemScrollController(ItemScrollController controller) {
    _itemScrollController = controller;
  }

  Future<void> setOffset() async {
    _offset += 5;
    _copyOffset = _offset;
    List<Map<String, dynamic>> record = await AppDB.getTableData(
        AppDB.msgTable,
        '(fromMember = ? OR targetMember = ?) AND chatType = ? AND chatRoomId = ?',
        [
          Member.nowChatMemberModel!.name,
          Member.nowChatMemberModel!.name,
          chatType.name,
          '$_chatRoomId'
        ],
        5,
        'createdAt DESC',
        _offset);
    if (record.isNotEmpty) {
      //本地有資料
      List<MessageModel> msgList = _tidyAndSort(record);
      msgList.sort((first, last) => first.createdAt.compareTo(last.createdAt));
      if (_sqliteData.first.id <= msgList.first.id) {
        setOffset();
        return;
      }
      _sqliteData.addAll(msgList);
      _sqliteData = List.from(_sqliteData.toSet());
      _sqliteData
          .sort((first, last) => first.createdAt.compareTo(last.createdAt));
      grouped = groupBy<MessageModel, String>(_sqliteData, (messages) {
        String time =
            format.format(Utils.sqlDateFormatTest.parse(messages.createdAt));
        return time;
      });
      notifyListeners();
      //await Future.delayed(const Duration(milliseconds: 200));
      //if(_controller.offset == _controller.position.minScrollExtent){
      //  _controller.animateTo(1.0, duration: const Duration(milliseconds: 500), curve: Curves.ease);
      //}
    } else {
      //本地沒資料
      if (_totalPages != _page) {
        _page = _page + 1;
        _getOnlineNewMsg(_page);
      }
    }
  }

  //上傳圖片或影片
  Future<Tuple<bool, String>> uploadFileToSQL(
      String account, String path, PhotoType type) async {
    return await Api.uploadFile(account, path, type);
  }

  //已讀
  void isRead(MessageModel dto) {
    if (Ws.stompClient.connected) {
      Ws.stompClient.send(
          destination: Ws.updateChatMessageIsRead, body: dto.toStompString());
    }
  }

  void setInRoom(bool value) {
    if (value != _isInRoom) {
      _isInRoom = value;
    }
  }

  void msgDelete(ChatRoomModel dto) async {
    await AppDB.deleteData(
        AppDB.messageRoomTable, 'chatRoomId = ?', ['${dto.id}']);

    LastMsg.chatRoomMembers
        .removeWhere((element) => element.chatRoomId == dto.id);
    await AppDB.deleteData(AppDB.msgTable, 'chatRoomId = ?', ['${dto.id}']);
    notifyListeners();
  }

  void jumpBottom() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (_controller.positions.isNotEmpty) {
      if (_controller.offset != _controller.position.maxScrollExtent) {
        _controller.animateTo(_controller.position.maxScrollExtent,
            duration: const Duration(milliseconds: 500), curve: Curves.ease);
      }
    }
    if (_itemScrollController.isAttached) {
      _itemScrollController.scrollTo(
          index: _sqliteData.length,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease);
    }
  }

  void getAllChatRoomMembersToDB() async {
    String token = Auth.userLoginResDTO.body.token;
    ChatRoomMemberDTO generalDto = ChatRoomMemberDTO(
      memberId: Member.memberModel.id,
      chatType: ChatType.GENERAL,
    );
    ChatRoomMemberDTO petDto = ChatRoomMemberDTO(
      memberId: Member.memberModel.id,
      chatType: ChatType.PET,
    );
    Tuple<bool, String> r1 = await Isolate.run(
        () => getSameRoomMembersByMemberId(generalDto, token));
    Tuple<bool, String> r2 =
        await Isolate.run(() => getSameRoomMembersByMemberId(petDto, token));
    if (r1.i1! && r2.i1!) {
      log('getSameRoomMembersByMemberId: ${r1.i2} ${r2.i2}');
      List list = json.decode(r1.i2!);
      list.addAll(json.decode(r2.i2!));
      List<ChatRoomMemberModel> data =
          list.map((e) => ChatRoomMemberModel.fromMap(e)).toList();
      data.forEach((element) async {
        List<Map<String, dynamic>> chatRoom = await AppDB.getTableData(
            AppDB.messageRoomTable,
            'chatRoomId = ?',
            ['${element.chatRoomId}']);
        if (chatRoom.isEmpty) {
          await AppDB.insert(AppDB.messageRoomTable, element.addMemberToDB());
        }
      });
    }
  }
}
