import 'dart:convert';
import 'dart:developer';

import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/model/login.dart';
import 'package:ashera_pet_new/model/member_pet.dart';
import 'package:ashera_pet_new/model/register.dart';
import 'package:ashera_pet_new/utils/utils.dart';
import 'package:dio/dio.dart';

import '../dio_http/http_request.dart';
import '../enum/chat_type.dart';
import '../enum/photo_type.dart';
import '../model/chat_room_member.dart';
import '../model/complaint_appeal_record.dart';
import '../model/forgot_password.dart';
import '../model/member_pet_like.dart';
import '../model/pet_classfication_dto.dart';
import '../model/tuple.dart';
import '../model/update_adopt_record_reply.dart';

class Api {
  static late Http httpUtils;

  static String accessToken = '';
  //static String baseUrl = 'https://dev.ashera.cc/ashera-pet-api';
  static String baseUrl = 'https://ashera-pet.cc';
  //api路徑
  static const String apiPath = '/ashera-pet-api';
  //face路徑
  static const String facePath = '/ashera-pet-detect-api';

  //登入
  static const String memberLogin = '$apiPath/auth/memberLogin';
  //獲取驗證碼
  static const String verificationCode = '$apiPath/auth/verificationCode';
  //刷新token
  static const String refreshToken = '$apiPath/auth/refreshToken';
  //註冊
  static const String memberRegister = '$apiPath/auth/memberRegister';
  //註冊從ashera
  static const String memberRegisterFromAshera =
      '$apiPath/auth/memberRegisterFromAshera';
  //刷新Token
  static const String authRefreshToken = '$apiPath/auth/refreshToken';
  //會員my
  static const String memberMy = '$apiPath/api/v1/members/my';
  //會員
  static const String member = '$apiPath/api/v1/members';
  //會員搜尋
  static const String memberSearch =
      '$apiPath/api/v1/members/byNicknameContains';
  //會員寵物
  static const String memberPet = '$apiPath/api/v1/member-pet';
  //會員寵物照片刪除
  static String memberPetDeletePic(int id) =>
      '$apiPath/api/v1/member-pet/$id/deletePic';
  //會員寵物位置
  static const String memberPetLocation =
      '$apiPath/api/v1/member-pet/updateLocation';
  //會員寵物搜尋
  static const String memberPetByNicknameContains =
      '$apiPath/api/v1/member-pet/byNicknameContains';
  //會員反饋
  static const String memberFeedback = '$apiPath/api/v1/member-feedback';
  //好友資料
  static const String friendData = '$apiPath/api/v1/friend-data/memberId';
  //追隨者請求
  static const String followerRequest = '$apiPath/api/v1/follower-request';
  //追隨者
  static const String follower = '$apiPath/api/v1/follower';

  //貼文
  static const String post = '$apiPath/api/v1/post';
  //貼文分享碼
  static String postShareCode(int id) =>
      '$apiPath/api/v1/post/getShareCode/$id';
  //貼文按讚
  static const String postLike = '$apiPath/api/v1/post-like';
  //
  static String unLike(int id) => '$apiPath/api/v1/post-like/unLike/$id';
  //貼文留言
  static const String postMessage = '$apiPath/api/v1/post-message';
  //貼文留言按讚
  static const String postMessageLike = '$apiPath/api/v1/post-message-like';
  //貼文背景
  static const String postBackground = '$apiPath/api/v1/post-background';
  //獲取忘記密碼驗證資料
  static String getForgotPasswordVerificationCode(String phoneNumber) =>
      '$apiPath/auth/forgotPasswordVerificationCode/number/$phoneNumber';
  //會員忘記密碼
  static String postForgotPassword = '$apiPath/auth/forgotPassword';

  //報表系統設定
  static const String reportSystemSetting =
      '$apiPath/api/v1/report-system-setting';

  //按讚排行
  static const String rankingPostLike =
      '$apiPath/api/v1/ranking-list-post-like/uuid';
  //留言排行
  static const String rankingListMessageLike =
      '$apiPath/api/v1/ranking-list-message/uuid';
  //追蹤排行
  static const String rankingListFollower =
      '$apiPath/api/v1/ranking-list-follower/uuid';

  //收藏排行前十
  static const String memberPetLikeByMostKeepTop =
      '$apiPath/api/v1/member-pet-like/byMostKeepTop10';
  //愛心排行前十
  static const String memberPetLikeByMostLikeTop =
      '$apiPath/api/v1/member-pet-like/byMostLikeTop10';

  //黑名單
  static const String memberBlacklist = '$apiPath/api/v1/member-blacklist';

  //通知
  static const String messageNotify = '$apiPath/api/v1/message-notify';

  //檢舉
  static const String complaint = '$apiPath/api/v1/complaint';
  //檢舉紀錄
  static const String complaintRecord = '$apiPath/api/v1/complaint-record';

  //辨識紀錄
  static const String facesDetectHistory =
      '$apiPath/api/v1/faces-detect-history';

  //推薦好友
  static const String recommendMember = '$apiPath/api/v1/recommend-member';

  //檔案上傳
  static const String fileUpload = '$apiPath/file/upload';
  //取得檔案
  static const String filePath = '$apiPath/upload/';
  //公開
  static const String publicPath = '$apiPath/public/';
  //關於
  static const String aboutUs = '$apiPath/api/v1/about-us/1';

  //寵物辨識
  static const String detect = '$apiPath/api/v1/animal-detect';

  //寵物貼文收藏
  static String petPostKeepByMemberId(int id) =>
      '$apiPath/api/v1/pet-post-keep/byMemberId/$id';
  //新增寵物貼文收藏
  static const String petPostKeep = '$apiPath/api/v1/pet-post-keep';
  //寵物貼文按讚
  static String petPostLikeByPetPostId(int id) =>
      '$apiPath/api/v1/pet-post-like/byPetPostId/$id';
  //新增寵物貼文按讚
  static const String petPostLike = '$apiPath/api/v1/pet-post-like';

  //驗證辨識貓狗
  static const String petClassfication = '$facePath/pet-classfication';
  //系統設定
  static const String systemSetting = '$apiPath/api/v1/system-setting/1';

  //寵物按讚byMemberPetIdAndILike
  static String countByMemberPetAndILike(int id) =>
      '$apiPath/api/v1/member-pet-like/countByMemberPetIdAndIlike/$id';
  //寵物按讚
  static const String memberPetLike = '$apiPath/api/v1/member-pet-like';
  //寵物按讚byMemberId
  static String memberPetLikeByMemberId(int id) =>
      '$apiPath/api/v1/member-pet-like/byMemberId/$id';
  //寵物按讚byMemberIdNot
  static String memberPetLikeByMemberIdNot(int id) =>
      '$apiPath/api/v1/member-pet-like/byMemberIdNot/$id';

  //新增聊天室
  static const String chatRoom = '$apiPath/api/v1/chat-room';

  //新增聊天室會員關聯
  static const String chatRoomMembers = '$apiPath/api/v1/chat-room-members';

  //使用memberId和聊天類型獲取聊天室
  static String chatRoomByMemberIdAndChatType(int memberId, ChatType type) =>
      '$apiPath/api/v1/chat-room/memberId/$memberId/chatType/${type.name}';

  //使用memberId和聊天類型獲取會員關聯
  static String chatRoomMembersByMemberIdAndChatType(
          int memberId, ChatType type) =>
      '$apiPath/api/v1/chat-room-members/memberId/$memberId/chatType/${type.name}';

  //使用memberId獲取會員關聯
  static String chatRoomMembersByMemberId(int memberId) =>
      '$apiPath/api/v1/chat-room-members/memberId/$memberId';

  //使用memberId取聊天室內所有人
  static String sameRoomMembersByMemberId(int memberId) =>
      '$apiPath/api/v1/chat-room-members/sameRoomMembers/memberId/$memberId';

  //清除會員訊息通知狀態
  static String clearMessageNotifyStatus(int memberId) =>
      '$apiPath/api/v1/members/clearMessageNotifyStatus/$memberId';

  //被領養檢舉
  static String adoptReportByTargetMemberId(int targetMemberId) =>
      '$apiPath/api/v1/complaint-record/byTargetMemberId/$targetMemberId';
  //領養檢舉
  static String adoptReportByFromMemberId(int fromMemberId) =>
      '$apiPath/api/v1/complaint-record/byFromMemberId/$fromMemberId';
  //回覆
  static const String complaintRecordUpdateReply =
      '$apiPath/api/v1/complaint-record/updateReply';
  //上訴
  static const String complaintAppealRecord =
      '$apiPath/api/v1/complaint-appeal-record';
  //完整分享url
  static String shareUrl(String shareCode) =>
      '$baseUrl/app/#/single-post/$shareCode';

  static void initHttp() {
    httpUtils = Http();
    httpUtils.init(baseUrl: baseUrl);
  }

  //會員搜尋
  /*static Future<Tuple<bool, String>> getMemberByNicknameContains(Map<String, dynamic> dto) async {
    try{
      dynamic value = await httpUtils.post(
        memberSearch,
        data: dto,
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}
        ),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioError catch(e){
      return Tuple<bool, String>(false, e.message);
    }
  }*/

  //寵物搜尋
  /*static Future<Tuple<bool, String>> getPetByNicknameContains(Map<String, dynamic> dto) async {
    try{
      dynamic value = await httpUtils.post(
        memberPetByNicknameContains,
        data: dto,
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}
        ),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioError catch (e){
      return Tuple<bool, String>(false, e.message);
    }
  }*/

  //追蹤我的請求
  static Future<Tuple<bool, String>> getFollowerMeRequest([int? id]) async {
    try {
      dynamic value = await httpUtils.get(
        '$followerRequest/followerMe/${id ?? Member.memberModel.id}',
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //我追蹤的請求
  static Future<Tuple<bool, String>> getMyFollowerRequest([int? id]) async {
    try {
      dynamic value = await httpUtils.get(
        '$followerRequest/myFollower/${id ?? Member.memberModel.id}',
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //我追蹤的
  static Future<Tuple<bool, String>> getMyFollower([int? id]) async {
    try {
      dynamic value = await httpUtils.get(
        '$follower/myFollower/${id ?? Member.memberModel.id}',
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //追蹤我的
  static Future<Tuple<bool, String>> getFollowerMe([int? id]) async {
    try {
      dynamic value = await httpUtils.get(
        '$follower/followerMe/${id ?? Member.memberModel.id}',
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //好友資料
  static Future<Tuple<bool, String>> getFriendData([int? id]) async {
    try {
      dynamic value = await httpUtils.get(
        '$friendData/${id ?? Member.memberModel.id}',
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //系統設定
  static Future<Tuple<bool, String>> getSystemSetting() async {
    try {
      dynamic value = await httpUtils.get(
        systemSetting,
        options: Options(
          contentType: 'application/json',
          //headers: {"authorization": "Bearer $accessToken"}
        ),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  /*//新增貼文
  static Future<Tuple<bool, String>> postNewPost(
      Map<String, dynamic> dto) async {
    try {
      dynamic value = await httpUtils.post(
        post,
        data: dto,
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioError catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }*/

  //刪除貼文
  static Future<Tuple<bool, String>> deletePost(int id) async {
    try {
      dynamic value = await httpUtils.delete(
        '$post/$id',
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //編輯貼文
  static Future<Tuple<bool, String>> editPost(Map<String, dynamic> dto) async {
    try {
      dynamic value = await httpUtils.put(
        post,
        data: dto,
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //取得貼文分頁資料Desc
  static Future<Tuple<bool, String>> postFindAllByPageDesc(
      Map<String, dynamic> dto) async {
    try {
      dynamic value = await httpUtils.post(
        '$post/findAllByPageDesc',
        data: dto,
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  static Future<Tuple<bool, String>> postFindAllByPageAsc(
      Map<String, dynamic> dto) async {
    try {
      dynamic value = await httpUtils.post(
        '$post/findAllByPageAsc',
        data: dto,
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  /*//取得貼文byId
  static Future<Tuple<bool, String>> getPostById(int postId) async {
    try {
      dynamic value = await httpUtils.get(
        '$post/$postId',
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioError catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }*/

  //取得貼文byMemberId
  static Future<Tuple<bool, String>> getPostByMemberId([int? id]) async {
    try {
      dynamic value = await httpUtils.get(
        '$post/byMemberId/${id ?? Member.memberModel.id}',
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //貼文點贊
  static Future<Tuple<bool, String>> postPostLike(
      Map<String, dynamic> dto) async {
    try {
      dynamic value = await httpUtils.post(
        postLike,
        data: dto,
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      log('貼文點贊');
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //刪除貼文點贊
  static Future<Tuple<bool, String>> deletePostLike(int id) async {
    try {
      dynamic value = await httpUtils.delete(
        '$postLike/$id',
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      log('刪除貼文點贊');
      return Tuple<bool, String>(true, '$value');
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //取消貼文按讚資料
  static Future<Tuple<bool, String>> unPostLike(int id) async {
    try {
      dynamic value = await httpUtils.post(
        unLike(id),
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, '$value');
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //取得貼文按讚byPostId
  static Future<Tuple<bool, String>> getPostLikeByPostId(int postId) async {
    try {
      dynamic value = await httpUtils.get(
        '$postLike/byPostId/$postId',
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //新增貼文留言
  static Future<Tuple<bool, String>> postPostMessage(
      Map<String, dynamic> dto) async {
    try {
      dynamic value = await httpUtils.post(
        postMessage,
        data: dto,
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //取得貼文留言byPostId
  static Future<Tuple<bool, String>> getPostMessageByPostId(int postId) async {
    try {
      dynamic value = await httpUtils.get(
        '$postMessage/byPostId/$postId',
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //新增貼文留言按讚
  static Future<Tuple<bool, String>> postPostMessageLike(
      Map<String, dynamic> dto) async {
    try {
      dynamic value = await httpUtils.post(
        postMessageLike,
        data: dto,
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //刪除貼文留言按讚
  static Future<Tuple<bool, String>> deletePostMessageLike(int id) async {
    try {
      dynamic value = await httpUtils.delete(
        '$postMessageLike/$id',
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //取得貼文留言按讚byPostId
  static Future<Tuple<bool, String>> getPostMessageLikeByPostId(
      int postId) async {
    try {
      dynamic value = await httpUtils.get(
        '$postMessageLike/findByPostId/$postId',
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //取得黑名單byFromMemberId
  static Future<Tuple<bool, String>> getBlackList() async {
    try {
      dynamic value = await httpUtils.get(
        '$memberBlacklist/byFromMemberId/${Member.memberModel.id}',
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //新增黑名單
  static Future<Tuple<bool, String>> postBlackList(
      Map<String, dynamic> dto) async {
    try {
      dynamic value = await httpUtils.post(
        memberBlacklist,
        data: dto,
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //刪除黑名單
  static Future<Tuple<bool, String>> deleteBlackList(int id) async {
    try {
      dynamic value = await httpUtils.delete(
        '$memberBlacklist/$id',
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //取得通知ByTargetMemberId
  static Future<Tuple<bool, String>> getMessageNotifyByTargetMemberId() async {
    try {
      dynamic value = await httpUtils.get(
        '$messageNotify/byTargetMemberId/${Member.memberModel.id}',
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //取得通知(分頁)ByTargetMemberId
  static Future<Tuple<bool, String>> postMessageNotifyByTargetMemberIdPageDesc(
      Map<String, dynamic> dto) async {
    try {
      dynamic value = await httpUtils.post(
        '$messageNotify/byTargetMemberIdPageDesc',
        data: dto,
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //註冊從ashera
  static Future<Tuple<bool, String>> postRegisterFromAsher(
      AddMemberFromAsheraDTO dto) async {
    try {
      dynamic value = await httpUtils.post(memberRegisterFromAshera,
          options: Options(contentType: 'application/json'), data: dto.toMap());
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //註冊
  static Future<Tuple<bool, String>> postRegister(AddRegisterDTO dto) async {
    try {
      dynamic value = await httpUtils.post(memberRegister,
          options: Options(contentType: 'application/json'), data: dto.toMap());
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //驗證碼確認
  static Future<Tuple<bool, String>> getVerificationCode(String number) async {
    try {
      dynamic value = await httpUtils.get('$verificationCode/number/$number',
          options: Options(contentType: 'application/json'));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //登入
  static Future<Tuple<bool, String>> postLogin(
      LoginCredential credential) async {
    try {
      dynamic value = await httpUtils.post(memberLogin,
          options: Options(contentType: 'application/json'),
          data: credential.toMap());
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //忘記密碼
  static Future<Tuple<bool, String>> forgotPassword(
      ForgotPasswordModel dto) async {
    try {
      dynamic value = await httpUtils.post(postForgotPassword,
          options: Options(contentType: 'application/json'), data: dto.toMap());
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //忘記密碼驗證碼取得
  static Future<Tuple<bool, String>> forgotPasswordVerificationCode(
      String phoneNumber) async {
    try {
      dynamic value = await httpUtils.get(
          getForgotPasswordVerificationCode(phoneNumber),
          options: Options(contentType: 'application/json'));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //會員資料
  static Future<Tuple<bool, String>> getMemberData(int id) async {
    try {
      dynamic value = await httpUtils.get('$memberMy/id/$id',
          options: Options(
              contentType: 'application/json',
              headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //更新會員資料
  static Future<Tuple<bool, String>> putMemberData(int id) async {
    try {
      dynamic value = await httpUtils.put('$memberMy/$id',
          data: Member.memberModel.updateMap(),
          options: Options(
              contentType: 'application/json',
              headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //更新會員密碼
  static Future<Tuple<bool, String>> putPassword(
      int id, Map<String, dynamic> dto) async {
    try {
      dynamic value = await httpUtils.put('$memberMy/$id/password',
          data: dto,
          options: Options(
              contentType: 'application/json',
              headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //註銷會員
  static Future<Tuple<bool, String>> deleteMember() async {
    try {
      dynamic value = await httpUtils.delete('$member/${Member.memberModel.id}',
          options: Options(
              contentType: 'application/json',
              headers: {"authorization": accessToken}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //新增會員寵物
  static Future<Tuple<bool, String>> postMemberPet(
      Map<String, dynamic> dto) async {
    try {
      dynamic value = await httpUtils.post(memberPet,
          data: dto,
          options: Options(
              contentType: 'application/json',
              headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //刪除會員寵物
  static Future<Tuple<bool, String>> deleteMemberPet(int id) async {
    log('要刪除的寵物ID: $id');
    try {
      dynamic value = await httpUtils.delete('$memberPet/$id',
          options: Options(
              contentType: 'application/json',
              headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //取得會員寵物ByMemberId
  static Future<Tuple<bool, String>> getPetByMemberId([int? id]) async {
    try {
      dynamic value = await httpUtils.get(
          '$memberPet/memberId/${id ?? Member.memberModel.id}',
          options: Options(
              contentType: 'application/json',
              headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //取得會員寵物
  static Future<Tuple<bool, String>> getPet([int? id]) async {
    try {
      dynamic value = await httpUtils.get('$memberPet/$id',
          options: Options(
              contentType: 'application/json',
              headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //更新會員寵物
  static Future<Tuple<bool, String>> putPetByMemberId(
      Map<String, dynamic> dto) async {
    try {
      dynamic value = await httpUtils.put(memberPet,
          data: dto,
          options: Options(
              contentType: 'application/json',
              headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //刷新Token
  static Future<Tuple<bool, String>> getRefreshToken() async {
    try {
      dynamic value = await httpUtils.get(refreshToken,
          options: Options(headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //上傳推播Token
  static Future<Tuple<bool, String>> putToken(Map<String, dynamic> dto) async {
    try {
      dynamic value = await httpUtils.put(
          '$memberMy/${Member.memberModel.id}/fcmToken',
          data: dto,
          options: Options(headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //檔案上傳
  static Future<Tuple<bool, String>> uploadFile(
      String account, String path, PhotoType type,
      [MemberPetModel? petModel]) async {
    Map<String, dynamic> file =
        await Utils.getFileName(account, path, type, petModel);
    log('fileName: ${file['fileName']}');
    FormData data = FormData.fromMap({
      "file":
          await MultipartFile.fromFile(file['path'], filename: file['fileName'])
              .catchError((e) {})
    });

    try {
      await httpUtils.upload(fileUpload,
          data: data,
          options: Options(
              contentType: 'application/json',
              headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, file['fileName']);
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //新增會員反應
  static Future<Tuple<bool, String>> postMemberFeedback(
      Map<String, dynamic> dto) async {
    try {
      dynamic value = await httpUtils.post(memberFeedback,
          data: dto,
          options: Options(headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  /*//檢舉列表取得
  static Future<Tuple<bool, String>> getComplaint() async {
    try {
      dynamic value = await httpUtils.get(complaint,
          options: Options(headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioError catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }*/

  //新增檢舉紀錄
  static Future<Tuple<bool, String>> postComplaintRecord(
      Map<String, dynamic> dto) async {
    try {
      dynamic value = await httpUtils.post(complaintRecord,
          data: dto,
          options: Options(headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //關於
  static Future<Tuple<bool, String>> getAboutUs() async {
    try {
      dynamic value = await httpUtils.get(aboutUs,
          options: Options(headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //uuid取得按讚排行
  static Future<Tuple<bool, String>> getRankingPostLikeByUuid(
      String uuid) async {
    try {
      dynamic value = await httpUtils.get('$rankingPostLike/$uuid',
          options: Options(headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //uuid取得留言排行
  static Future<Tuple<bool, String>> getRankingListMessageLikeByUuid(
      String uuid) async {
    try {
      dynamic value = await httpUtils.get('$rankingListMessageLike/$uuid',
          options: Options(headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //uuid取得追蹤排行
  static Future<Tuple<bool, String>> getRankingListFollowerByUuid(
      String uuid) async {
    try {
      dynamic value = await httpUtils.get('$rankingListFollower/$uuid',
          options: Options(headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //寵物收藏前十
  static Future<Tuple<bool, String>> getMemberPetLikeByMostKeepTop() async {
    try {
      dynamic value = await httpUtils.get(memberPetLikeByMostKeepTop,
          options: Options(headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //寵物愛心前十
  static Future<Tuple<bool, String>> getMemberPetLikeByMostLikeTop() async {
    try {
      dynamic value = await httpUtils.get(memberPetLikeByMostLikeTop,
          options: Options(headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  /*//報表系統設定
  static Future<Tuple<bool, String>> getReportSystemSetting() async {
    try {
      dynamic value = await httpUtils.get('$reportSystemSetting/1',
          options: Options(headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioError catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }*/

  //辨識紀錄byFromMemberId <- 後面也許會刪掉
  static Future<Tuple<bool, String>> getFacesDetectHistoryByFromMemberId(
      [int? id]) async {
    try {
      dynamic value = await httpUtils.get(
          '$facesDetectHistory/byFromMemberId/${id ?? Member.memberModel.id}',
          options: Options(headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //辨識紀錄byTargetMemberId <- 後面也許會刪掉
  static Future<Tuple<bool, String>> getFacesDetectHistoryByTargetMemberId(
      [int? id]) async {
    try {
      dynamic value = await httpUtils.get(
          '$facesDetectHistory/byTargetMemberId/${id ?? Member.memberModel.id}',
          options: Options(headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //推薦好友byMemberId
  static Future<Tuple<bool, String>> getRecommendMember([int? id]) async {
    try {
      dynamic value = await httpUtils.get(
          '$recommendMember/memberId/${id ?? Member.memberModel.id}',
          options: Options(headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //寵物辨識上傳
  static Future<Tuple<bool, String>> postDetect(
      Map<String, dynamic> dto) async {
    try {
      dynamic value = await httpUtils.post(detect,
          data: dto,
          options: Options(
            contentType: 'application/json',
            /*headers: {"authorization": "Bearer $accessToken"}*/
          ));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //驗證辨識貓狗
  static Future<Tuple<bool, String>> postPetClassfication(
      PetClassficationReqDTO dto) async {
    try {
      dynamic value = await httpUtils.post(petClassfication,
          data: dto.toMap(),
          options: Options(
              contentType: 'application/json',
              headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  /*//取得讚數byMemberPetIdAndILike
  static Future<Tuple<bool, String>> getCountByMemberPetIdAndILike(
      int memberPetId) async {
    try {
      dynamic value = await httpUtils.get(
        Api.countByMemberPetAndILike(memberPetId),
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioError catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }*/

  /*//更新寵物按讚
  static Future<Tuple<bool, String>> putMemberPetLike(MemberPetLikeModel dto) async {
    try{
      dynamic value = await httpUtils.put(
        Api.memberPetLike,
        data: dto.toPut(),
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioError catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }*/

  //取得貼文byId
  static Future<Tuple<bool, String>> getPostByIdNotIso(int postId) async {
    try {
      dynamic value = await httpUtils.get(
        '${Api.post}/$postId',
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $accessToken"}),
      );
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //新增聊天室關聯會員
  static Future<Tuple<bool, String>> addChatRoomMembers(
      ChatRoomMemberModel dto) async {
    try {
      dynamic value = await httpUtils.post(Api.chatRoomMembers,
          data: dto.addMember(),
          options: Options(
              contentType: 'application/json',
              headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }

  //新增聊天室關聯會員寵物
  static Future<Tuple<bool, String>> addChatRoomMembersPet(
      ChatRoomMemberModel dto) async {
    try {
      dynamic value = await httpUtils.post(Api.chatRoomMembers,
          data: dto.addMemberAndPet(),
          options: Options(
              contentType: 'application/json',
              headers: {"authorization": "Bearer $accessToken"}));
      return Tuple<bool, String>(true, json.encode(value));
    } on DioException catch (e) {
      return Tuple<bool, String>(false, e.message);
    }
  }
}

Future<Tuple<bool, String>> getMemberByNicknameContains(
    Map<String, dynamic> dto, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  try {
    dynamic value = await httpUtils.post(
      Api.memberSearch,
      data: dto,
      options: Options(
          contentType: 'application/json',
          headers: {"authorization": "Bearer $token"}),
    );
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

Future<Tuple<bool, String>> getPetByNicknameContains(
    Map<String, dynamic> dto, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  try {
    dynamic value = await httpUtils.post(
      Api.memberPetByNicknameContains,
      data: dto,
      options: Options(
          contentType: 'application/json',
          headers: {"authorization": "Bearer $token"}),
    );
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//新增貼文
Future<Tuple<bool, String>> postNewPost(
    Map<String, dynamic> dto, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  try {
    dynamic value = await httpUtils.post(
      Api.post,
      data: dto,
      options: Options(
          contentType: 'application/json',
          headers: {"authorization": "Bearer $token"}),
    );
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//報表系統設定
Future<Tuple<bool, String>> getReportSystemSetting(String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  try {
    dynamic value = await httpUtils.get('${Api.reportSystemSetting}/1',
        options: Options(headers: {"authorization": "Bearer $token"}));
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//取得全部寵物
Future<Tuple<bool, String>> getAllMemberPet(String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  try {
    dynamic value = await httpUtils.get(Api.memberPet,
        options: Options(headers: {"authorization": "Bearer $token"}));
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//檢舉列表取得
Future<Tuple<bool, String>> getApiComplaint(String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  try {
    dynamic value = await httpUtils.get(Api.complaint,
        options: Options(headers: {"authorization": "Bearer $token"}));
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//取得貼文byId
Future<Tuple<bool, String>> getPostById(int postId, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  try {
    dynamic value = await httpUtils.get(
      '${Api.post}/$postId',
      options: Options(
          contentType: 'application/json',
          headers: {"authorization": "Bearer $token"}),
    );
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//更新寵物按讚
Future<Tuple<bool, String>> putMemberPetLike(
    MemberPetLikeModel dto, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  log('帶了什麼：${dto.toPut()}');
  try {
    dynamic value = await httpUtils.put(
      Api.memberPetLike,
      data: dto.toPut(),
      options: Options(
          contentType: 'application/json',
          headers: {"authorization": "Bearer $token"}),
    );
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//取得寵物按讚byMemberId
Future<Tuple<bool, String>> getMemberPetLikeByMemberId(
    int id, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  try {
    dynamic value = await httpUtils.get(
      Api.memberPetLikeByMemberId(id),
      options: Options(
          contentType: 'application/json',
          headers: {"authorization": "Bearer $token"}),
    );
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//取得哪些人點了我讚byMemberIdNot
Future<Tuple<bool, String>> getMemberPetLikeByMemberIdNot(
    int id, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  try {
    dynamic value = await httpUtils.get(
      Api.memberPetLikeByMemberIdNot(id),
      options: Options(
          contentType: 'application/json',
          headers: {"authorization": "Bearer $token"}),
    );
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//取得讚數byMemberPetIdAndILike
Future<Tuple<bool, String>> getCountByMemberPetIdAndILike(
    int memberPetId, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  try {
    dynamic value = await httpUtils.get(
      Api.countByMemberPetAndILike(memberPetId),
      options: Options(
          contentType: 'application/json',
          headers: {"authorization": "Bearer $token"}),
    );
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//檔案上傳隔離
Future<Tuple<bool, String>> uploadFileIso(
    String account, String path, MemberPetModel pet, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  Map<String, dynamic> file =
      await Utils.getFileName(account, path, PhotoType.more, pet);
  FormData data = FormData.fromMap({
    "file":
        await MultipartFile.fromFile(file['path'], filename: file['fileName'])
            .catchError((e) {})
  });
  try {
    await httpUtils.upload(Api.fileUpload,
        data: data,
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $token"}));
    return Tuple<bool, String>(true, file['fileName']);
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//刪除會員寵物照片
Future<Tuple<bool, String>> deletePetPicIso(
    int id, String fileName, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  try {
    dynamic value = await httpUtils.post(Api.memberPetDeletePic(id),
        data: {'filename': fileName},
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $token"}));
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//更新會員寵物位置
Future<Tuple<bool, String>> uploadPetLocation(
    MemberPetLocationDTO dto, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  try {
    dynamic value = await httpUtils.post(Api.memberPetLocation,
        data: dto.toMap(),
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $token"}));
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//使用memberId和聊天類型獲取聊天室
Future<Tuple<bool, String>> getChatRoomByMemberIdAndChatType(
    ChatRoomMemberDTO dto, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  log('Url: ${Api.chatRoomByMemberIdAndChatType(dto.memberId, dto.chatType)}');
  try {
    dynamic value = await httpUtils.get(
        Api.chatRoomByMemberIdAndChatType(dto.memberId, dto.chatType),
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $token"}));
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//使用memberId和聊天類型獲取會員關聯
Future<Tuple<bool, String>> getChatRoomMembersByMemberIdAndChatType(
    ChatRoomMemberDTO dto, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  log('Url: ${Api.chatRoomMembersByMemberIdAndChatType(dto.memberId, dto.chatType)}');
  try {
    dynamic value = await httpUtils.get(
        Api.chatRoomMembersByMemberIdAndChatType(dto.memberId, dto.chatType),
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $token"}));
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//使用memberId獲取會員關聯
Future<Tuple<bool, String>> getChatRoomMembersByMemberId(
    ChatRoomMemberDTO dto, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  try {
    dynamic value = await httpUtils.get(
        Api.chatRoomMembersByMemberId(dto.memberId),
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $token"}));
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//使用memberId取聊天室內所有人
Future<Tuple<bool, String>> getSameRoomMembersByMemberId(
    ChatRoomMemberDTO dto, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  try {
    dynamic value = await httpUtils.get(
        Api.sameRoomMembersByMemberId(dto.memberId),
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $token"}));
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//建立聊天室
Future<Tuple<bool, String>> createdChatRoom(
    ChatRoomModel dto, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  try {
    dynamic value = await httpUtils.post(Api.chatRoom,
        data: dto.createdChatRoomMap(),
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $token"}));
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//清除會員訊息通知狀態
Future<Tuple<bool, String>> clearMessageNotifyStatus(
    int id, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  try {
    dynamic value = await httpUtils.post(Api.clearMessageNotifyStatus(id),
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $token"}));
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//被領養檢舉紀錄
Future<Tuple<bool, String>> adoptReportRecordByTargetMemberId(
    int id, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  try {
    dynamic value = await httpUtils.get(Api.adoptReportByTargetMemberId(id),
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $token"}));
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//領養檢舉紀錄
Future<Tuple<bool, String>> adoptReportRecordByFromMemberId(
    int id, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  try {
    dynamic value = await httpUtils.get(Api.adoptReportByFromMemberId(id),
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $token"}));
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//純文字貼文背景
Future<Tuple<bool, String>> getPostBackground(String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  try {
    dynamic value = await httpUtils.get(Api.postBackground,
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $token"}));
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//複製連結
Future<Tuple<bool, String>> getPostShareCode(int id, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  try {
    dynamic value = await httpUtils.get(Api.postShareCode(id),
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $token"}));
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

Future<Tuple<bool, String>> putComplaintRecord(
    UpdateAdoptRecordReplyDTO dto, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  try {
    dynamic value = await httpUtils.put(Api.complaintRecordUpdateReply,
        data: dto.toMap(),
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $token"}));
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

Future<Tuple<bool, String>> postComplaintAppealRecord(
    ComplaintAppealRecordModel dto, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  log('上傳資料：${dto.addMap()}');
  try {
    dynamic value = await httpUtils.post(Api.complaintAppealRecord,
        data: dto.addMap(),
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $token"}));
    return Tuple<bool, String>(true, json.encode(value));
  } on DioException catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}

//新增聊天室關聯會員
/*
Future<Tuple<bool, String>> addChatRoomMembers(ChatRoomMemberModel dto, String token) async {
  Http httpUtils = Http();
  httpUtils.init(baseUrl: Api.baseUrl);
  try{
    dynamic value = await httpUtils.post(
      Api.chatRoomMembers,
      data: dto.addMember(),
        options: Options(
            contentType: 'application/json',
            headers: {"authorization": "Bearer $token"})
    );
    return Tuple<bool, String>(true, json.encode(value));
  } on DioError catch (e) {
    return Tuple<bool, String>(false, e.message);
  }
}*/
