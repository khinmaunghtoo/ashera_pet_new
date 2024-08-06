import 'package:stomp_dart_client/stomp_dart_client.dart';

class Ws{
  static const String baseUrl = 'http://ashera-pet.cc:9002/my-websocket';
  //上傳檔案
  static const String webSocketBinary = 'ws://ashera-pet.cc:9002/ws/binary';
  ///接收
  //對方的訊息
  static const String p2pMsg = '/user/queue/p2pMsg';
  //自己的訊息
  static const String p2pMsgResp = '/user/queue/p2pMsgResp';
  //最後聊天訊息
  static const String p2pGetLastChatMsgResp = '/user/queue/p2pGetLastChatMsgResp';
  //聊天記錄
  static const String p2pGetChatMsgResp = '/user/queue/p2pGetChatMsgResp';
  //追蹤我
  static const String p2pFollowMe = '/user/queue/followMe';
  //申請追蹤
  static const String p2pFollowRequest = '/user/queue/p2pFollowRequest';
  //允許或拒絕追蹤
  static const String p2pAcceptFollowRequest = '/user/queue/p2pAcceptFollowRequest';
  //撤回追蹤
  static const String p2pCommonResp = '/user/queue/p2pCommonResp';
  //已讀監聽
  static const String p2pUpdateUnreadChatMsgResp = '/user/queue/p2pUpdateUnreadChatMsgResp';
  //錯誤訊息
  static const String p2pError = '/user/queue/p2pError';
  //新增貼文訊息
  static const String p2pAddPostMessage = '/user/queue/p2pAddPostMessage';
  //新增貼文按讚
  static const String p2pAddPostLike = '/user/queue/p2pAddPostLike';
  //新訊息通知
  static const String p2pNewMessageNotify = '/user/queue/p2pNewMessageNotify';
  //收回訊息
  static const String p2pTakeChatMsgBackResp = '/user/queue/p2pTakeChatMsgBackResp';
  //收到刪除訊息
  static const String p2pDeleteChatRoomResp = '/user/queue/p2pDeleteChatRoomResp';
  //新增檢舉紀錄
  static const String p2pAddAdoptRecordResp = '/user/queue/p2pAddAdoptRecordResp';
  //檢舉紀錄回覆
  static const String p2pUpdateAdoptRecordReplyResp = '/user/queue/p2pUpdateAdoptRecordReplyResp';
  //聊天室
  static const String p2pAddChatRoomResp = '/user/queue/p2pAddChatRoomResp';
  //聊天室會員關聯
  static const String p2pAddChatRoomMemberResp = '/user/queue/p2pAddChatRoomMemberResp';
  //使用 Member ID 獲取和我相同聊天室的會員關聯資料
  static const String p2pGetChatRoomMemberResp = '/user/queue/p2pGetChatRoomMemberResp';
  //會員是否為警示用戶
  static const String p2pWarningMember = '/user/queue/p2pWarningMember';


  ///發送
  //申請追蹤
  static const String addFollowerRequest = '/app/addFollowerRequest';
  //允許或拒絕追蹤
  static const String acceptFollowerRequest = '/app/acceptFollowerRequest';
  //刪除追蹤
  static const String deleteFollowerByMemberIdAndFollowerId = '/app/deleteFollowerByMemberIdAndFollowerId';
  //撤回追蹤
  static const String deleteFollowerRequest = '/app/deleteFollowerRequest';
  //誰想加我
  static const String followerMe = '/app/followerMe';
  //我想加誰
  static const String myFollower = '/app/myFollower';
  //發送訊息
  static const String sendMsg = '/app/p2pMsg';
  //最後一筆聊天訊息
  static const String lastChatMessage = '/app/getLastChatMessage';
  //聊天記錄
  static const String getChatMessagePageDesc = '/app/getChatMessagePageDesc';
  //已讀
  static const String updateChatMessageIsRead = '/app/updateChatMessageIsRead';
  //新增貼文留言
  static const String addPostMessage = '/app/addPostMessage';
  //新增貼文按讚
  static const String addPostLike = '/app/addPostLike';
  //新增領養檢舉
  static const String addAdoptRecord = '/app/addAdoptRecord';
  //回覆領養檢舉
  static const String updateAdoptRecordReply = '/app/updateAdoptRecordReply';
  //刪除聊天室
  static const String deleteChatRoom = '/app/deleteChatRoom';
  //新增聊天室
  static const String addChatRoom = '/app/addChatRoom';
  //新增 聊天室會員關聯
  static const String addChatRoomMember = '/app/addChatRoomMember';
  //使用 Member ID 獲取和我相同聊天室的會員關聯資料
  static const String getChatRoomMemberSameRoomMembers = '/app/getChatRoomMemberSameRoomMembers';
  //新粉絲請求 已讀
  static const String updateFollowerRequestIsReadByFollowerId = '/app/updateFollowerRequestIsReadByFollowerId';
  //會員是否為警示用戶
  static const String isTargetMemberWarning = '/app/isTargetMemberWarning';


  static late StompClient stompClient;

}