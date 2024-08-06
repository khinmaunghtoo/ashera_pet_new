import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:ashera_pet_new/data/last_msg.dart';
import 'package:ashera_pet_new/data/pet.dart';
import 'package:ashera_pet_new/db/app_db.dart';
import 'package:ashera_pet_new/dialog/cupertion_alert.dart';
import 'package:ashera_pet_new/enum/bottom_bar.dart';
import 'package:ashera_pet_new/model/add_adopt_record_dto.dart';
import 'package:ashera_pet_new/model/chat_room_member.dart';
import 'package:ashera_pet_new/model/face_detect.dart';
import 'package:ashera_pet_new/model/member.dart';
import 'package:ashera_pet_new/model/message.dart';
import 'package:ashera_pet_new/model/post_like.dart';
import 'package:ashera_pet_new/model/target_member_warning_dto.dart';
import 'package:ashera_pet_new/page/bottom_navigation/pet_radar/pet_radar.dart';
import 'package:ashera_pet_new/page/bottom_navigation/chat.dart';
import 'package:ashera_pet_new/page/bottom_navigation/chat/room.dart';
import 'package:ashera_pet_new/page/bottom_navigation/home.dart';
import 'package:ashera_pet_new/page/bottom_navigation/me.dart';
import 'package:ashera_pet_new/page/bottom_navigation/ranking.dart';
import 'package:ashera_pet_new/routes/route_name.dart';
import 'package:ashera_pet_new/utils/firebase_message.dart';
import 'package:ashera_pet_new/utils/geolocator_service.dart';
import 'package:ashera_pet_new/view_model/about_us.dart';
import 'package:ashera_pet_new/view_model/blacklist.dart';
import 'package:ashera_pet_new/view_model/bottom_bar.dart';
import 'package:ashera_pet_new/view_model/comments_vm.dart';
import 'package:ashera_pet_new/view_model/follower.dart';
import 'package:ashera_pet_new/view_model/member_pet.dart';
import 'package:ashera_pet_new/view_model/message_controller.dart';
import 'package:ashera_pet_new/view_model/notify.dart';
import 'package:ashera_pet_new/view_model/system_setting.dart';
import 'package:ashera_pet_new/widget/app_lifecycle_wrapper.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stomp_dart_client/stomp_dart_client.dart';
import 'package:url_launcher/url_launcher.dart';

import '../data/member.dart';
import '../data/system_setting.dart';
import '../dialog/alert.dart';
import '../enum/chat_type.dart';
import '../enum/event_type.dart';
import '../model/event_model.dart';
import '../model/member_pet.dart';
import '../model/member_view.dart';
import '../model/post_message.dart';
import '../model/tuple.dart';
import '../model/update_adopt_record_reply.dart';
import '../routes/app_router.dart';
import '../utils/app_color.dart';
import '../utils/app_image.dart';
import '../utils/shared_preference.dart';
import '../utils/utils.dart';
import '../utils/ws.dart';
import '../view_model/adopt_report_vm.dart';
import '../view_model/auth.dart';
import '../view_model/chat_msg.dart';
import '../view_model/complaint_record.dart';
import '../view_model/kanban.dart';
import '../view_model/member.dart';
import '../view_model/post.dart';
import '../view_model/ranking_classification.dart';
import '../view_model/recommend_vm.dart';
import '../view_model/search_record.dart';
import '../view_model/ws.dart';
import '../widget/bottom_drawer/drawer.dart';
import '../widget/bottom_navigation/bottom_tabs.dart';
import '../widget/bottom_navigation/custom_shapes/custom_shapes.dart';

//* 底部導航頁
class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<StatefulWidget> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage>
    with WidgetsBindingObserver {
  BottomBarVm? _barVm;
  SearchRecordVm? _recordVm;
  MessageControllerVm? _controllerVm;
  NotifyVm? _notifyVm;
  ChatMsgVm? _chatMsgVm;
  final PageController _pageController = PageController();
  AuthVm? _authVm;
  MemberPetVm? _memberPetVm;
  MemberVm? _memberVm;
  Timer? _refreshTokenTimer;
  AboutUsVm? _aboutUsVm;
  WsVm? _wsVm;
  FollowerVm? _followerVm;
  PostVm? _postVm;
  CommentsVm? _commentsVm;
  RankingClassificationVm? _rankingClassificationVm;
  BlackListVm? _blackListVm;
  ComplaintRecordVm? _complaintRecordVm;
  StreamSubscription? _notificationStream;
  StreamSubscription? _locationStream;
  SystemSettingVm? _settingVm;
  KanBanVm? _kanBanVm;
  AdoptReportVm? _adoptReportVm;
  MessageControllerVm? _messageControllerVm;
  RecommendVm? _recommendVm;
  //重取次數
  int _refetchTimes = 0;

  //* tab view 的 children widget
  final List<Widget> _pages = [
    const HomePage(),
    const ChatPage(),
    const PetRadarPage(),
    const PostRankingPage(),
    const SettingsPage()
  ];

  void _getData() async {
    _kanBanVm!.getAllPet();
    _messageControllerVm!.getAllChatRoomMembersToDB();

    //黑名單
    _blackListVm!.getBlackList();

    //貼文
    _postVm!.findAllByPageDesc();
    _postVm!.getMePost();
    //搜尋推薦
    //_recommendVm!.findAllByPage();

    _followerVm!.tidyFollower();

    if (Pet.petModel.isEmpty) {
      _memberPetVm!.getPet();
    }

    Future.delayed(const Duration(milliseconds: 3000), () {
      TargetMemberWarningDto dto = TargetMemberWarningDto(
          targetMemberId: Member.memberModel.id, warning: false);
      //取自己是否是警示用戶
      Ws.stompClient.send(
          destination: Ws.isTargetMemberWarning,
          body: '${Member.memberModel.id}');

      //排行
      _rankingClassificationVm!.init();

      //檢舉
      _complaintRecordVm!.getComplaint();
      _adoptReportVm!
          .getAdoptReportRecordByFromAndTarget(Member.memberModel.id);

      //不重要
      _aboutUsVm!.setAboutUs();
    });
  }

  void _setFirebase() {
    //關閉前台提示 只需要有提示音
    openOrCloseFirebaseMessaging(false);
  }

  void _setWs() async {
    //監聽開始
    log('監聽開始');
    _wsVm!.addListener(_wsConnectListener);
    //_wsVm!.justRefresh();
  }

  _onLayoutDone(_) async {
    _setWs();
    _barVm!.setPageController(_pageController);
    _getData();

    _recordVm!.getSearchRecordList();

    _tokenExpiredTime();

    //分享連結
    if (Utils.initialLink != null) {
      _showSharePost();
    }
    //推播點擊監聽
    _notificationEventBus();
    //位置更新
    _locationEventBus();
    //判斷是否要更新
    _isUpDataApp();
    //
    _testFirebase();

    //位置權限
    if (await GeolocatorService.handlePermission()) {
      GeolocatorService.startDetectingPosition();
    }
    _setFirebase();
  }

  //是否更新APP
  void _isUpDataApp() async {
    if (_settingVm!.judgeIsUpdate()) {
      bool r = await showCupertinoAlert(
          context: context,
          title: '有新版本',
          content: 'APP有新版本！請前往更新',
          cancel: false,
          confirmation: true);
      if (r) {
        jumpToUpDate(defaultTargetPlatform == TargetPlatform.android
            ? SystemSetting.systemSetting.playStoreAppUrl
            : SystemSetting.systemSetting.appleStoreAppUrl);
      }
    }
  }

  //打開商店畫面
  void jumpToUpDate(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
      );
    } else {
      throw 'Could not launch appStoreLink';
    }
  }

  //位置更新
  void _locationEventBus() {
    _locationStream =
        Utils.locationBus.on<Map<String, dynamic>>().listen((event) {
      _kanBanVm!.setLocation(event);
      _memberPetVm!.setLocation(event);
    });
  }

  //推播點擊監聽
  void _notificationEventBus() {
    _notificationStream =
        Utils.notificationBus.on<EventModel>().listen((event) async {
      switch (event.title) {
        case EventType.notification:
          if (event.frame!.contains('您被其他用戶檢舉了')) {
            context.push(RouteName.adoptRecord);
          } else if (event.frame!.contains('傳送了交友訊息給您')) {
            await _notifyVm!.getMessageNotifyPage();
            await _memberVm!.updateMessageNotifyStatus();
            if (mounted) context.push(RouteName.notify);
          } else {
            //要先取得所有聊天室
            if (LastMsg.chatRoomMembers.isEmpty) {
              //需先取所有聊天室
              log('何時會有');
            } else {
              //跳至指定聊天室
              log('event: ${event.frame}');
              int index = event.frame!.indexOf('傳送了');
              String name = event.frame!.substring(0, index);
              if (LastMsg.lastMsgList
                  .where((element) =>
                      element.fromMemberView!.nickname == name ||
                      element.targetMemberView!.nickname == name)
                  .isNotEmpty) {
                MessageModel model = LastMsg.lastMsgList
                    .where((element) =>
                        element.fromMemberView!.nickname == name ||
                        element.targetMemberView!.nickname == name)
                    .first;
                MemberAndMsgLast data;
                if (model.chatType == ChatType.GENERAL) {
                  data = MemberAndMsgLast(
                      member: MemberModel.fromMap(_getPet(model).toMap()),
                      msg: model,
                      chatType: model.chatType);
                } else {
                  if (Pet.allPets.isNotEmpty) {
                    data = MemberAndMsgLast(
                        member: MemberModel.fromMap(_getPet(model).toMap()),
                        msg: model,
                        chatType: model.chatType,
                        pet: Pet.allPets
                            .firstWhere((e) => e.id == model.memberPetId),
                        chatRoomId: model.chatRoomId);
                  } else {
                    await Future.delayed(const Duration(milliseconds: 800));
                    _jumpChatRoom(event.frame!.toString());
                    return;
                  }
                }
                if (!_messageControllerVm!.isInRoom) {
                  Future.delayed(const Duration(milliseconds: 800), () async {
                    await context
                        .pushTransparentRoute(RoomPage(userData: data));
                  });
                } else {
                  //如果不同人
                  if (name == Member.nowChatMemberModel!.nickname) {
                    if (context.canPop()) {
                      context.pop();
                    }
                    Future.delayed(const Duration(milliseconds: 800), () async {
                      await context
                          .pushTransparentRoute(RoomPage(userData: data));
                    });
                  }
                }
              }
            }
          }
          break;
      }
    });
  }

  MemberView _getPet(MessageModel msgData) {
    log('msgData: ${msgData.toMap()}');
    if (msgData.targetMemberId == Member.memberModel.id) {
      return msgData.fromMemberView!;
    } else {
      return msgData.targetMemberView!;
    }
  }

  void _wsConnectListener() {
    log('isActive ${Ws.stompClient.isActive}');
    if (Ws.stompClient.isActive && mounted) {
      //設定監聽
      _wsVm!.setCallBack(_stompMonitor);
      //最後一則聊天訊息
      //_chatMsgVm!.lastChatMsgResp();
    } else {}
  }

  //分享的貼文
  void _showSharePost() {
    String postId = Utils.initialLink!.split(':').last;
    log('字串切割: $postId');
    context.push(RouteName.sharePost, extra: postId);
  }

  //token過期時間
  void _tokenExpiredTime() async {
    _refreshTokenTimer ??=
        Timer.periodic(const Duration(minutes: 10), (timer) async {
      log('執行Token刷新');
      if (await _authVm!.refreshToken()) {
        if (_refreshTokenTimer != null) {
          _refreshTokenTimer!.cancel();
          _refreshTokenTimer = null;
          _tokenExpiredTime();
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
    Utils.getAndPutToken();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      //判斷是否要更新
      _isUpDataApp();

      //* 如果token過期, 登录
      if (await _accessTokenIsExpired()) {
        Tuple<bool, String> r = await _authVm!
            .login(await SharedPreferenceUtil.getLoginCredential());
        if (r.i1!) {
          //_wsVm!.deactivate();
          //_wsVm!.onCreation(await SharedPreferenceUtil.readAccountAndPassword());
        }
      }
    }
  }

  @override
  void dispose() {
    _wsVm!.removeListener(_wsConnectListener);
    Ws.stompClient.deactivate();
    if (_refreshTokenTimer != null) {
      _refreshTokenTimer!.cancel();
      _refreshTokenTimer = null;
    }
    _notificationStream?.cancel();
    _locationStream?.cancel();
    GeolocatorService.cancel();
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  //判斷accessToken是否過期
  Future<bool> _accessTokenIsExpired() async {
    int date = await SharedPreferenceUtil.readExpiredTime();
    if (date != 0) {
      return Utils.isExpired(date);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    _barVm = Provider.of<BottomBarVm>(context, listen: false);
    _recordVm = Provider.of<SearchRecordVm>(context, listen: false);
    _controllerVm = Provider.of<MessageControllerVm>(context, listen: false);
    _memberPetVm = Provider.of<MemberPetVm>(context, listen: false);
    _authVm = Provider.of<AuthVm>(context, listen: false);
    _aboutUsVm = Provider.of<AboutUsVm>(context, listen: false);
    _wsVm = Provider.of<WsVm>(context, listen: false);
    _followerVm = Provider.of<FollowerVm>(context, listen: false);
    _chatMsgVm = Provider.of<ChatMsgVm>(context, listen: false);
    _postVm = Provider.of<PostVm>(context, listen: false);
    _rankingClassificationVm =
        Provider.of<RankingClassificationVm>(context, listen: false);
    _blackListVm = Provider.of<BlackListVm>(context, listen: false);
    _complaintRecordVm = Provider.of<ComplaintRecordVm>(context, listen: false);
    _settingVm = Provider.of<SystemSettingVm>(context, listen: false);
    _kanBanVm = Provider.of<KanBanVm>(context, listen: false);
    _memberVm = Provider.of<MemberVm>(context, listen: false);
    _adoptReportVm = Provider.of<AdoptReportVm>(context, listen: false);
    _messageControllerVm =
        Provider.of<MessageControllerVm>(context, listen: false);
    _commentsVm = Provider.of<CommentsVm>(context, listen: false);
    _notifyVm = Provider.of<NotifyVm>(context, listen: false);
    _recommendVm = Provider.of<RecommendVm>(context, listen: false);
    return WillPopScope(onWillPop: () => AppRouter.pop(), child: _body());
  }

  Widget _body() {
    //* wrap AuthVm 和 WsVm (websocket) in to lifecycle
    return AppLifecycleWrapper(
      //*? 這個stack,應該在scaffold的body吧？
      child: Stack(
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppColor.appBackground,
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              //* pages
              children: _pages,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: Container(
              height: 70,
              width: 70,
              decoration: const BoxDecoration(
                  color: Colors.transparent, shape: BoxShape.circle),
              child: Consumer<BottomBarVm>(
                builder: (context, bottomBarProvider, _) {
                  // 中間的, logo標誌的， 浮動按鈕
                  return FloatingActionButton(
                    shape: const CircleBorder(),
                    onPressed: () async {
                      //如果當前bottom bar 不是 看板？
                      if (bottomBarProvider.selectedTab != BottomTab.kanban) {
                        // 取得所有寵物
                        _kanBanVm!.getAllPet();
                        // 取得我喜歡的
                        _kanBanVm!.getMyLike();
                        _kanBanVm!.setShowAnimation(true);
                      }
                      // 設定底部導航欄為 看板, 這樣就會顯示 看板的頁面
                      bottomBarProvider.setBottomBar(BottomTab.kanban);
                    }, //_goAssistInPetHunting(),//_goScan(),
                    backgroundColor: AppColor.button,
                    child: const Image(
                      width: 28,
                      image: AssetImage(AppImage.logoWhite),
                    ),
                  );
                },
              ),
            ),

            //* bottom tabs 底部按鈕欄
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 2,
                ),
              ]),
              child: const BottomAppBar(
                height: 60,
                padding: EdgeInsets.zero,
                clipBehavior: Clip.antiAlias,
                shape: CustomCircularNotchedRectangle(),
                notchMargin: 8.0,
                color: AppColor.textFieldUnSelect,
                // tabs
                child: BottomTabs(),
              ),
            ),
          ),

          //* 這裡是設定頁面，右上角，設置按鈕，彈出的選單
          const MenuDrawer()
        ],
      ),
    );
  }

  //監聽
  void _stompMonitor(StompFrame frame) async {
    switch (frame.headers['destination']) {
      case Ws.p2pFollowMe:
        _followerVm!.tidyFollower();
        break;
      case Ws.p2pFollowRequest:
        _followerVm!.tidyFollower();
        _memberVm!.getMemberInforWithUserIDAndPersistent();
        break;
      case Ws.p2pAcceptFollowRequest:
        _followerVm!.tidyFollower();
        await _notifyVm!.getMessageNotify();
        break;
      case Ws.p2pCommonResp:
        _followerVm!.tidyFollower();
        break;
      case Ws.p2pGetLastChatMsgResp:
        log('p2pGetLastChatMsgResp: ${frame.body}');
        List list = json.decode(frame.body ?? '[]');
        if (list.isEmpty) {
          AppDB.delete(AppDB.messageRoomTable);
        } else {
          _chatMsgVm!.tidyLastMsg(frame.body ?? '[]');
        }
        break;
      case Ws.p2pMsgResp:
        //我傳給對方
        _chatMsgVm!.lastChatMsgResp();
        _controllerVm!.addJudgmentData(frame.body ?? '');
        break;
      case Ws.p2pMsg:
        //對方傳給我
        _chatMsgVm!.lastChatMsgResp();
        _controllerVm!.addJudgmentData(frame.body ?? '');
        break;
      case Ws.p2pGetChatMsgResp:
        //分頁聊天記錄
        _controllerVm!.tidyMessagePage(frame.body ?? '{}');
        break;
      case Ws.p2pUpdateUnreadChatMsgResp:
        _controllerVm!.msgData();
        _chatMsgVm!.lastChatMsgResp();
        break;
      case Ws.p2pAddPostMessage:
        log('p2pAddPostMessage: ${frame.body}');
        PostMessageModel dto = PostMessageModel.fromJson(frame.body!);
        _commentsVm!.addNewPostMessage(dto);
        break;
      case Ws.p2pAddPostLike:
        log('p2pAddPostLike: ${frame.body}');
        PostLikeModel dto = PostLikeModel.fromJson(frame.body!);
        _postVm!.addNewPoseLike(dto);
        _commentsVm!.addNewPoseLike(dto);
        break;
      case Ws.p2pNewMessageNotify:
        log('p2pNewMessageNotify: ${frame.body}');
        updateNotify();
        break;
      case Ws.p2pTakeChatMsgBackResp:
        log('p2pTakeChatMsgBackResp: ${frame.body}');
        break;
      case Ws.p2pDeleteChatRoomResp:
        log('p2pDeleteChatRoomResp: ${frame.body}');
        ChatRoomModel body = ChatRoomModel.fromJson(frame.body!);
        _chatMsgVm!.deleteChatRoom(body);
        _messageControllerVm!.msgDelete(body);
        if (_messageControllerVm!.isInRoom &&
            _messageControllerVm!.chatRoomId == body.id) {
          if (AppRouter.ctx.canPop()) {
            AppRouter.ctx.pop();
          }
        }
        break;
      case Ws.p2pAddAdoptRecordResp:
        log('p2pAddAdoptRecordResp: ${frame.body}');
        AdoptRecordModel dto = AdoptRecordModel.fromJson(frame.body!);
        if (dto.fromMemberId == Member.memberModel.id) {
          Alert.showComplaintSuccessAlert(context);
        }
        _adoptReportVm!.justGetAdoptReportRecordByFrom(Member.memberModel.id);
        break;
      case Ws.p2pUpdateAdoptRecordReplyResp:
        log('p2pUpdateAdoptRecordReplyResp: ${frame.body}');
        UpdateAdoptRecordReplyDTO dto =
            UpdateAdoptRecordReplyDTO.fromJson(frame.body!);
        _adoptReportVm!.setReply(dto);
        break;
      case Ws.p2pAddChatRoomResp:
        log('p2pAddChatRoomResp: ${frame.body}');
        _messageControllerVm!.getCreatedChatRoom(frame.body ?? '');
        break;
      case Ws.p2pAddChatRoomMemberResp:
        log('p2pAddChatRoomMemberResp: ${frame.body}');
        _messageControllerVm!.insertAppDB(frame.body ?? '');
        break;
      case Ws.p2pGetChatRoomMemberResp:
        log('p2pGetChatRoomMemberResp: ${frame.body}');
        _chatMsgVm!.getAllChatRoomMembers(frame.body ?? '[]');
        break;
      case Ws.p2pWarningMember:
        log('p2pWarningMember: ${frame.body}');
        TargetMemberWarningDto dto =
            TargetMemberWarningDto.fromJson(frame.body!);
        _memberVm!.setTargetMemberWarning(dto);
        break;
      case Ws.p2pError:
        log('p2pError: ${frame.body}');
        //'聊天室不存在'

        break;
    }
  }

  void updateNotify() async {
    await _memberVm!.getMemberInforWithUserIDAndPersistent();
  }

  void _goScan() async {
    List<FaceDetectResponseModel>? r = await context.push(RouteName.scan);
    if (r != null) {
      if (r.isNotEmpty) {
        if (mounted) context.push(RouteName.identificationList, extra: r);
      }
    }
  }

  //協尋寵物
  void _goAssistInPetHunting() {
    //context.push(RouteName.assistInPetHunting);
  }

  void _testFirebase() async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      await FlutterLocalNotificationsPlugin()
          .getNotificationAppLaunchDetails()
          .then((details) {
        if (details != null) {
          if (details.didNotificationLaunchApp) {
            _refetchTimes = 0;
            String payload = details.notificationResponse!.payload!;
            SVProgressHUD.show(status: '資料準備中');
            log('這裡面有什麼： $payload');
            _judgeJumpChatRoom(payload);
          }
        }
      });
    }
  }

  //判斷
  void _judgeJumpChatRoom(String payload) async {
    _refetchTimes++;
    if (LastMsg.lastMsgList.isNotEmpty && LastMsg.chatRoomMembers.isNotEmpty) {
      _jumpChatRoom(payload);
    } else {
      await Future.delayed(const Duration(milliseconds: 800));
      if (_refetchTimes < 30) {
        _judgeJumpChatRoom(payload);
      } else {
        SVProgressHUD.dismiss();
      }
    }
  }

  void _jumpChatRoom(String payload) async {
    //跳至指定聊天室
    int index = payload.indexOf('傳送了');
    String name = payload.substring(0, index);
    if (LastMsg.lastMsgList
        .where((element) =>
            element.fromMemberView!.nickname == name ||
            element.targetMemberView!.nickname == name)
        .isNotEmpty) {
      MessageModel model = LastMsg.lastMsgList
          .where((element) =>
              element.fromMemberView!.nickname == name ||
              element.targetMemberView!.nickname == name)
          .first;
      MemberAndMsgLast data;
      if (model.chatType == ChatType.GENERAL) {
        data = MemberAndMsgLast(
            member: MemberModel.fromMap(_getPet(model).toMap()),
            msg: model,
            chatType: model.chatType);
      } else {
        if (Pet.allPets.isNotEmpty) {
          data = MemberAndMsgLast(
              member: MemberModel.fromMap(_getPet(model).toMap()),
              msg: model,
              chatType: model.chatType,
              pet: Pet.allPets.firstWhere((e) => e.id == model.memberPetId),
              chatRoomId: model.chatRoomId);
        } else {
          await Future.delayed(const Duration(milliseconds: 800));
          _jumpChatRoom(payload);
          return;
        }
      }

      if (!_messageControllerVm!.isInRoom) {
        Future.delayed(const Duration(milliseconds: 800), () async {
          SVProgressHUD.dismiss();
          await context.pushTransparentRoute(RoomPage(userData: data));
          //openOrCloseFirebaseMessaging(true);
        });
      }
    }
  }
}
