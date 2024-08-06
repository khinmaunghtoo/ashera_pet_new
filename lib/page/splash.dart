import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/view_model/member.dart';
import 'package:ashera_pet_new/view_model/post.dart';
import 'package:ashera_pet_new/view_model/system_setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../model/tuple.dart';
import '../routes/route_name.dart';
import '../utils/app_image.dart';
import '../utils/shared_preference.dart';
import '../utils/utils.dart';
import '../view_model/auth.dart';
import '../view_model/ws.dart';

//歡迎畫面
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  AuthVm? _authVm;
  MemberVm? _memberVm;
  WsVm? _wsVm;
  PostVm? _postVm;
  SystemSettingVm? _settingVm;

  //*? 这里的逻辑有点问题？
  // 因为 _loginWithCredential 里面已经做了登录相关验证和页面导航
  // 为什么这里还要做?
  _onLayoutDone(_) async {
    // 判斷accessToken是否過期
    // if (!await _accessTokenIsExpired()) {
    //   await _loginWithCredential();
    // } else if (await SharedPreferenceUtil.readAccount() != '') {
    //   await _loginWithCredential();
    // } else {
    //   if (mounted) context.pushReplacement(RouteName.login);
    //   FlutterNativeSplash.remove();
    // }
    await _loginWithCredential();
    //本地版本初始化
    _settingVm!.packageInfoInit();
    //線上版本初始化
    _settingVm!.systemSettingInit();
  }

  //* login with credential
  Future<void> _loginWithCredential() async {
    //* 判斷accessToken是否過期, 如果过期，去登录页面
    if (await _accessTokenIsExpired()) {
      if (mounted) context.pushReplacement(RouteName.login);
      return;
    }

    //* 如果没账号，去登录页面
    if (await SharedPreferenceUtil.readAccount() == '') {
      if (mounted) context.pushReplacement(RouteName.login);
      return;
    }

    //* 登入 with credential
    Tuple<bool, String> loginResult =
        await _authVm!.login(await SharedPreferenceUtil.getLoginCredential());

    //* 登录成功, 跳去bottomNavigation
    if (loginResult.i1!) {
      String time = Utils.sqlDateFormatTest.format(DateTime.now());
      SharedPreferenceUtil.saveBackgroundTime(time);
      _wsVm!.onCreation(await SharedPreferenceUtil.getLoginCredential());
      await _memberVm!.getMemberInforWithUserIDAndPersistent();
      await _postVm!.getAllPostBackground();
      if (mounted) context.pushReplacement(RouteName.bottomNavigation);
      //* 登录失败, 跳去登录页面
    } else {
      if (mounted) context.pushReplacement(RouteName.login);
    }

    //* 移除splash
    FlutterNativeSplash.remove();
  }

  //判斷accessToken是否過期
  Future<bool> _accessTokenIsExpired() async {
    int expiredTime = await SharedPreferenceUtil.readExpiredTime();
    if (expiredTime != 0) {
      return Utils.isExpired(expiredTime);
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
  }

  @override
  Widget build(BuildContext context) {
    _authVm = Provider.of<AuthVm>(context, listen: false);
    _memberVm = Provider.of<MemberVm>(context, listen: false);
    _wsVm = Provider.of<WsVm>(context, listen: false);
    _settingVm = Provider.of<SystemSettingVm>(context, listen: false);
    _postVm = Provider.of<PostVm>(context);
    return Scaffold(
      backgroundColor: AppColor.appBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: const Image(
              image: AssetImage(AppImage.bg),
              fit: BoxFit.fill,
            ),
          );
        },
      ),
    );
  }
}
