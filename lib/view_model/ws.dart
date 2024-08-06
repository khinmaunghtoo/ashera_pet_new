import 'dart:async';
import 'dart:developer';

import 'package:ashera_pet_new/model/login.dart';
import 'package:ashera_pet_new/utils/ws.dart';
import 'package:flutter/cupertino.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';

import '../data/member.dart';
import '../utils/shared_preference.dart';

//* websocket view model
class WsVm with ChangeNotifier {
  Function(StompFrame)? callback;
  dynamic p2pFollowRequestSubscribe,
      p2pFollowMeSubscribe,
      p2pAcceptFollowRequestSubscribe,
      p2pCommonRespSubscribe,
      p2pErrorSubscribe,
      p2pMsgSubscribe,
      p2pMsgRespSubscribe,
      p2pGetLastChatMsgRespSubscribe,
      p2pGetChatMsgRespSubscribe,
      p2pUpdateUnreadChatMsgRespSubscribe,
      p2pAddPostMessageSubscribe,
      p2pAddPostLikeSubscribe,
      p2pNewMessageNotifySubscribe,
      p2pTakeChatMsgBackRespSubscribe,
      p2pDeleteChatRoomRespSubscribe,
      p2pAddAdoptRecordRespSubscribe,
      p2pUpdateAdoptRecordReplyRespSubscribe,
      p2pAddChatRoomRespSubscribe,
      p2pAddChatRoomMemberRespSubscribe,
      p2pGetChatRoomMemberRespSubscribe,
      p2pWarningMemberSubscribe;

  void onCreation(LoginCredential credential) {
    Ws.stompClient = StompClient(
        config: StompConfig.sockJS(
      url: Ws.baseUrl, //您要連接的服務器的網址（必填）
      reconnectDelay: const Duration(
          milliseconds: 5000), //重新連接嘗試之間的持續時間。如果您不想自動重新連接，請設置為 0 ms
      heartbeatOutgoing:
          const Duration(milliseconds: 5000), //傳出心跳消息之間的持續時間。設置為 0 ms 不發送任何心跳
      heartbeatIncoming:
          const Duration(milliseconds: 5000), //傳入心跳消息之間的持續時間。設置為 0 ms 不接收任何心跳
      connectionTimeout: const Duration(milliseconds: 5000), //等待連接嘗試中止的持續時間
      onConnect: onConnect, //當客戶端成功連接到服務器時要調用的函數。
      onDisconnect: onDisconnect, //客戶端預期斷開連接時調用的函數
      onStompError: onStompError, //當 stomp 服務器發送錯誤幀時要調用的函數
      //beforeConnect: beforeConnect, //在建立連接之前將等待的異步函數。
      onWebSocketError: onWebSocketError, //WebSocketError
      stompConnectHeaders: {
        "username": credential.name,
        "password": credential.password
      }, //將在 STOMP 連接幀上使用的可選標頭值
      webSocketConnectHeaders: {
        "username": credential.name,
        "password": credential.password
      }, //連接到底層 WebSocket 時將使用的可選標頭值（Web 中不支持）
      onUnhandledFrame: onUnhandledFrame, //服務器發送無法識別的幀時調用的函數
      onUnhandledMessage: onUnhandledMessage, //當訂閱消息沒有處理程序時要調用的函數
      onUnhandledReceipt: onUnhandledReceipt, //當接收消息沒有註冊觀察者時調用的函數
      onWebSocketDone: onWebSocketDone, //當底層 WebSocket 完成/斷開連接時要調用的函數
      onDebugMessage: onDebugMessage, //為內部消息處理程序生成的調試消息調用的函數
    ));
    _activate();
  }

  void justRefresh() {
    notifyListeners();
  }

  //客戶端預期斷開連接時調用的函數
  void onDisconnect(StompFrame frame) {
    log('onDisconnect: ${frame.body}');
  }

  //當 stomp 服務器發送錯誤幀時要調用的函數
  void onStompError(StompFrame frame) {
    log('onStompError: ${frame.body}');
  }

  //服務器發送無法識別的幀時調用的函數
  void onUnhandledFrame(StompFrame frame) {
    log('onUnhandledFrame: ${frame.body}');
  }

  //當訂閱消息沒有處理程序時要調用的函數
  void onUnhandledMessage(StompFrame frame) {
    log('onUnhandledMessage: ${frame.body}');
  }

  //當接收消息沒有註冊觀察者時調用的函數
  void onUnhandledReceipt(StompFrame frame) {
    log('onUnhandledReceipt: ${frame.body}');
  }

  //當底層 WebSocket 完成/斷開連接時要調用的函數
  void onWebSocketDone() {
    log('onWebSocketDone');
  }

  //為內部消息處理程序生成的調試消息調用的函數
  void onDebugMessage(String value) {
    log('onDebugMessage: $value');
  }

  //當客戶端成功連接到服務器時要調用的函數。
  void onConnect(StompFrame frame) {
    log('onConnect');
    notifyListeners();
    if (callback != null) {
      _setSubscribe();
    } else {
      _reSubscribe();
    }
  }

  //WebSocketError
  void onWebSocketError(dynamic error) {
    log('onWebSocketError ${error.toString()}');
    deactivate();
    Future.delayed(
        const Duration(milliseconds: 2000),
        () async =>
            onCreation(await SharedPreferenceUtil.getLoginCredential()));
  }

  //連接
  void _activate() {
    if (!Ws.stompClient.isActive) {
      log('STOMP 已連線');
      Ws.stompClient.activate();
    }
  }

  //重複確認監聽
  void _reSubscribe() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (callback != null) {
      _setSubscribe();
    } else {
      _reSubscribe();
    }
  }

  //斷線
  void deactivate() {
    if (Ws.stompClient.isActive) {
      log('STOMP 已斷線');
      Ws.stompClient.deactivate();
      _setUnsubscribe();
    }
  }

  //傳送訊息
  void sendMessage(String key, String value) {
    if (Ws.stompClient.isActive) {
      Ws.stompClient.send(destination: key, body: value);
    }
  }

  //callback
  void setCallBack(Function(StompFrame) call) {
    callback = call;
  }

  void _setSubscribe() {
    //申請追蹤
    p2pFollowRequestSubscribe = _subscribe(Ws.p2pFollowRequest);
    //追蹤
    p2pFollowMeSubscribe = _subscribe(Ws.p2pFollowMe);
    //允許或拒絕追蹤
    p2pAcceptFollowRequestSubscribe = _subscribe(Ws.p2pAcceptFollowRequest);
    //撤回追蹤
    p2pCommonRespSubscribe = _subscribe(Ws.p2pCommonResp);
    //錯誤訊息
    p2pErrorSubscribe = _subscribe(Ws.p2pError);
    //對方的訊息
    p2pMsgSubscribe = _subscribe(Ws.p2pMsg);
    //自己的訊息
    p2pMsgRespSubscribe = _subscribe(Ws.p2pMsgResp);
    //最後聊天訊息
    p2pGetLastChatMsgRespSubscribe = _subscribe(Ws.p2pGetLastChatMsgResp);
    //聊天記錄
    p2pGetChatMsgRespSubscribe = _subscribe(Ws.p2pGetChatMsgResp);
    //已讀
    p2pUpdateUnreadChatMsgRespSubscribe =
        _subscribe(Ws.p2pUpdateUnreadChatMsgResp);
    //新增貼文訊息
    p2pAddPostMessageSubscribe = _subscribe(Ws.p2pAddPostMessage);
    //新增貼文按讚
    p2pAddPostLikeSubscribe = _subscribe(Ws.p2pAddPostLike);
    //新訊息通知
    p2pNewMessageNotifySubscribe = _subscribe(Ws.p2pNewMessageNotify);
    //收回訊息
    p2pTakeChatMsgBackRespSubscribe = _subscribe(Ws.p2pTakeChatMsgBackResp);
    //刪除聊天室
    p2pDeleteChatRoomRespSubscribe = _subscribe(Ws.p2pDeleteChatRoomResp);
    //新增檢舉紀錄
    p2pAddAdoptRecordRespSubscribe = _subscribe(Ws.p2pAddAdoptRecordResp);
    //檢舉紀錄回覆
    p2pUpdateAdoptRecordReplyRespSubscribe =
        _subscribe(Ws.p2pUpdateAdoptRecordReplyResp);
    //聊天室
    p2pAddChatRoomRespSubscribe = _subscribe(Ws.p2pAddChatRoomResp);
    //聊天室會員關聯
    p2pAddChatRoomMemberRespSubscribe = _subscribe(Ws.p2pAddChatRoomMemberResp);
    //使用 Member ID 獲取和我相同聊天室的會員關聯資料
    p2pGetChatRoomMemberRespSubscribe = _subscribe(Ws.p2pGetChatRoomMemberResp);
    //會員是否為警示用戶
    p2pWarningMemberSubscribe = _subscribe(Ws.p2pWarningMember);

    //最後一筆聊天訊息
    Ws.stompClient
        .send(destination: Ws.lastChatMessage, body: Member.memberModel.name);
    Ws.stompClient.send(
        destination: Ws.getChatRoomMemberSameRoomMembers,
        body: '${Member.memberModel.id}');
  }

  void _setUnsubscribe() {
    p2pFollowRequestSubscribe(unsubscribeHeaders: null);
    p2pFollowMeSubscribe(unsubscribeHeaders: null);
    p2pAcceptFollowRequestSubscribe(unsubscribeHeaders: null);
    p2pCommonRespSubscribe(unsubscribeHeaders: null);
    p2pErrorSubscribe(unsubscribeHeaders: null);
    p2pMsgSubscribe(unsubscribeHeaders: null);
    p2pMsgRespSubscribe(unsubscribeHeaders: null);
    p2pGetLastChatMsgRespSubscribe(unsubscribeHeaders: null);
    p2pGetChatMsgRespSubscribe(unsubscribeHeaders: null);
    p2pUpdateUnreadChatMsgRespSubscribe(unsubscribeHeaders: null);
    p2pAddPostMessageSubscribe(unsubscribeHeaders: null);
    p2pAddPostLikeSubscribe(unsubscribeHeaders: null);
    p2pNewMessageNotifySubscribe(unsubscribeHeaders: null);
    p2pTakeChatMsgBackRespSubscribe(unsubscribeHeaders: null);
    p2pDeleteChatRoomRespSubscribe(unsubscribeHeaders: null);
    p2pAddAdoptRecordRespSubscribe(unsubscribeHeaders: null);
    p2pUpdateAdoptRecordReplyRespSubscribe(unsubscribeHeaders: null);
    p2pAddChatRoomRespSubscribe(unsubscribeHeaders: null);
    p2pAddChatRoomMemberRespSubscribe(unsubscribeHeaders: null);
    p2pGetChatRoomMemberRespSubscribe(unsubscribeHeaders: null);
    p2pWarningMemberSubscribe(unsubscribeHeaders: null);
  }

  _subscribe(String url) {
    return Ws.stompClient.subscribe(destination: url, callback: callback!);
  }
}
