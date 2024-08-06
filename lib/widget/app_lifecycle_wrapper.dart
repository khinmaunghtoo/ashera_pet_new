import 'dart:developer';

import 'package:ashera_pet_new/utils/shared_preference.dart';
import 'package:ashera_pet_new/utils/utils.dart';
import 'package:ashera_pet_new/view_model/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../view_model/ws.dart';

//* App生命週期監聽 wrapper
// 但是，只配合2個vm使用
// 1. AuthVm (authentication)
// 2. WsVm (websocket)
class AppLifecycleWrapper extends StatefulWidget {
  final Widget child;
  const AppLifecycleWrapper({super.key, required this.child});
  @override
  State<StatefulWidget> createState() => _AppLifecycleWrapperState();
}

class _AppLifecycleWrapperState extends State<AppLifecycleWrapper>
    with WidgetsBindingObserver {
  Widget get child => widget.child;

  AuthVm? _authVm;
  WsVm? _wsVm;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    log('生命週期：${state.name}');
    switch (state) {
      case AppLifecycleState.hidden:
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        String time = await SharedPreferenceUtil.readBackgroundTime();
        if (time.isNotEmpty) {
          DateTime nowTime = Utils.sqlDateFormatTest
              .parse(Utils.sqlDateFormatTest.format(DateTime.now()));
          DateTime oldTime = Utils.sqlDateFormatTest.parse(time);
          if (nowTime.difference(oldTime).inMinutes > 5) {
            log('重新登入');
            _wsVm!.deactivate();
            String time = Utils.sqlDateFormatTest.format(DateTime.now());
            SharedPreferenceUtil.saveBackgroundTime(time);
            await _authVm!
                .login(await SharedPreferenceUtil.getLoginCredential());
            _wsVm!.onCreation(await SharedPreferenceUtil.getLoginCredential());
          }
        }
        break;
      case AppLifecycleState.paused:
        String time = Utils.sqlDateFormatTest.format(DateTime.now());
        SharedPreferenceUtil.saveBackgroundTime(time);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    _authVm = Provider.of<AuthVm>(context, listen: false);
    _wsVm = Provider.of<WsVm>(context, listen: false);
    return child;
  }
}
