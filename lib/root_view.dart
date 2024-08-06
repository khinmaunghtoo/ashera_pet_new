import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ashera_pet_new/db/app_db.dart';
import 'package:ashera_pet_new/routes/app_router.dart';
import 'package:ashera_pet_new/routes/route_name.dart';
import 'package:ashera_pet_new/utils/api.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/utils/utils.dart';
import 'package:ashera_pet_new/view_model/about_us.dart';
import 'package:ashera_pet_new/view_model/adopt_report_vm.dart';
import 'package:ashera_pet_new/view_model/auth.dart';
import 'package:ashera_pet_new/view_model/blacklist.dart';
import 'package:ashera_pet_new/view_model/bottom_bar.dart';
import 'package:ashera_pet_new/view_model/bottom_drawer.dart';
import 'package:ashera_pet_new/view_model/camera.dart';
import 'package:ashera_pet_new/view_model/chat_msg.dart';
import 'package:ashera_pet_new/view_model/comments_vm.dart';
import 'package:ashera_pet_new/view_model/complaint_record.dart';
import 'package:ashera_pet_new/view_model/follower.dart';
import 'package:ashera_pet_new/view_model/kanban.dart';
import 'package:ashera_pet_new/view_model/member.dart';
import 'package:ashera_pet_new/view_model/member_feedback.dart';
import 'package:ashera_pet_new/view_model/member_pet.dart';
import 'package:ashera_pet_new/view_model/message_controller.dart';
import 'package:ashera_pet_new/view_model/notify.dart';
import 'package:ashera_pet_new/view_model/photos_and_videos.dart';
import 'package:ashera_pet_new/view_model/post.dart';
import 'package:ashera_pet_new/view_model/ranking_classification.dart';
import 'package:ashera_pet_new/view_model/recommend.dart';
import 'package:ashera_pet_new/view_model/recommend_vm.dart';
import 'package:ashera_pet_new/view_model/register.dart';
import 'package:ashera_pet_new/view_model/report_vm.dart';
import 'package:ashera_pet_new/view_model/room_input.dart';
import 'package:ashera_pet_new/view_model/search_record.dart';
import 'package:ashera_pet_new/view_model/search_text.dart';
import 'package:ashera_pet_new/view_model/system_setting.dart';
import 'package:ashera_pet_new/view_model/tab_bar.dart';
import 'package:ashera_pet_new/view_model/video_vm.dart';
import 'package:ashera_pet_new/view_model/ws.dart';
import 'package:ashera_pet_new/widget/app_behavior.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:uni_links/uni_links.dart';

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  State<StatefulWidget> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  MessageControllerVm? _messageControllerVm;
  final List<SingleChildWidget> _providers = [];

  StreamSubscription? _sub;

  Future<SharedPreferences> getSharedPreference() async {
    final SharedPreferences instance = await SharedPreferences.getInstance();
    await instance.reload();
    return instance;
  }

  @override
  void initState() {
    super.initState();

    //本地資料庫 初始化
    AppDB.initDatabase();

    //API 初始化
    Api.initHttp();

    //*? 没有在用了
    // WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);

    // 初始化providers
    _initProviders();

    // SVProgressHUD library, 配置
    _configProgressIndicatorHUD();

    //*  针对iOS， 设置状态栏和导航栏样式
    //  但是，注销后，也没看到什么变化呢？
    // if (defaultTargetPlatform == TargetPlatform.iOS) {
    //   // 设置系统 UI 模式为手动，并显示状态栏和导航栏
    //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
    //       overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    //   // 设置系统 UI 的样式
    //   SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    //       statusBarColor: Colors.black, // 状态栏颜色设置为黑色
    //       systemNavigationBarColor: Colors.black, // 导航栏颜色设置为黑色
    //       systemNavigationBarIconBrightness: Brightness.dark // 导航栏图标亮度设置为暗色
    //       ));
    // }

    //* deep link 初始化
    _uni();
  }

  //* deep link
  void _uni() async {
    // _sub = await _listenLinks();
    // await initUniLinks();
  }

  //* deep link listen
  // Future<StreamSubscription> _listenLinks() async {
  //   return linkStream.listen((String? link) async {
  //     print('DeepLinking Sub: $link');

  //     //* 先保存当前link为 initialLink?
  //     Utils.initialLink = link;

  //     // 从link中提取postId
  //     String postId = Utils.initialLink!.split(':').last;

  //     // 延迟2.5秒，然后跳转到分享页面
  //     await Future.delayed(const Duration(milliseconds: 2500));

  //     //*? 那么确定link是 share post 吗？
  //     // 上面也没有对link进行判断，直接提取postId?
  //     if (mounted) AppRouter.ctx.push(RouteName.sharePost, extra: postId);
  //   }, onError: (Object err) {
  //     print('DeepLinking Sub Error: $err');
  //   });
  // }

  @override
  void dispose() {
    //* dispose link listener
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: _providers,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.config,
        localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
            pageTransitionsTheme: const PageTransitionsTheme(builders: {
              TargetPlatform.android: CupertinoPageTransitionsBuilder(),
              TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
            }),
            brightness: Brightness.dark,
            highlightColor: const Color.fromRGBO(0, 0, 0, 0),
            splashColor: Colors.transparent),
        builder: (context, child) {
          //  針對child(Go Router Object)進行一些操作
          //  鍵盤unfocus的操作，和點擊空白處，鍵盤隱藏的操作
          //  什麼功能，需要在root做這些操作呢？
          //  應該是聊天功能？

          //* 獲取MessageControllerVm
          _messageControllerVm = Provider.of(context, listen: false);

          //* MediaQueryData
          final MediaQueryData media = MediaQuery.of(context);

          //*? Scaffold
          // 沒搞明白，為什麼要這樣包裹？
          child = Scaffold(
            resizeToAvoidBottomInset: false,
            body: Listener(
              onPointerUp: (_) {
                // 如果在房间中, 保持聚焦
                if (_messageControllerVm!.isInRoom) {
                  return;
                }

                // 如果不在房間，則取消聚焦
                FocusScopeNode currentFocus = FocusScope.of(context);
                if (!currentFocus.hasPrimaryFocus) {
                  currentFocus.focusedChild?.unfocus();
                }
              },
              child: MediaQuery(
                // 這裡將media的boldText設置為false
                data: media.copyWith(
                    boldText: false, textScaler: const TextScaler.linear(1)),
                child: ScrollConfiguration(
                    behavior: AppBehavior(),
                    child: GestureDetector(
                        onTap: () {
                          //聚焦要取消
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.focusedChild?.unfocus();
                          }
                          SystemChannels.textInput
                              .invokeMethod('TextInput.hide');
                        },
                        child: child)),
              ),
            ),
          );
          return child;
        },
      ),
    );
  }

  //狀態管理初始化
  void _initProviders() {
    _providers.add(ChangeNotifierProvider(create: (_) => AuthVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => BottomBarVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => BottomDrawerVm()));
    _providers
        .add(ChangeNotifierProvider(create: (_) => RankingClassificationVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => SearchTextVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => SearchRecordVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => TabBarVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => RoomInputVm()));
    _providers
        .add(ChangeNotifierProvider(create: (_) => MessageControllerVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => RegisterVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => MemberVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => MemberPetVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => AboutUsVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => MemberFeedbackVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => WsVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => FollowerVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => ChatMsgVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => PostVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => BlackListVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => NotifyVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => ComplaintRecordVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => CameraVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => RecommendFriendVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => SystemSettingVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => PhotosAndVideosVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => KanBanVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => AdoptReportVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => VideoVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => ReportVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => CommentsVm()));
    _providers.add(ChangeNotifierProvider(create: (_) => RecommendVm()));
  }

  // SVProgressHUD library, 配置
  void _configProgressIndicatorHUD() {
    SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.custom);
    SVProgressHUD.setBackgroundColor(Colors.black54);
    SVProgressHUD.setBackgroundLayerColor(Colors.black54);
    SVProgressHUD.setForegroundColor(AppColor.pinkishPurple);
    SVProgressHUD.setImageViewSize(const Size(50, 50));
    SVProgressHUD.setHapticsEnabled(false);
  }
}

//* deep link
// 这个才是官方的初始化方法
// 为什么上面还要另外自己写一个？
// 上面那个是listen link的
// Future<void> initUniLinks() async {
//   try {
//     Utils.initialLink = await getInitialLink();
//     print('DeepLinking: ${Utils.initialLink}');
//   } on PlatformException {
//     print('DeepLinking Error');
//   }
// }
