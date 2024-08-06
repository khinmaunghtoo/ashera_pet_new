import 'dart:async';
import 'dart:developer';

import 'package:ashera_pet_new/dialog/cupertion_alert.dart';
import 'package:ashera_pet_new/enum/register.dart';
import 'package:ashera_pet_new/model/login.dart';
import 'package:ashera_pet_new/view_model/auth.dart';
import 'package:ashera_pet_new/widget/button.dart';
import 'package:ashera_pet_new/widget/forget_password/sms_button.dart';
import 'package:ashera_pet_new/widget/register/title.dart';
import 'package:ashera_pet_new/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../model/register.dart';
import '../model/tuple.dart';
import '../routes/app_router.dart';
import '../routes/route_name.dart';
import '../utils/app_color.dart';
import '../utils/utils.dart';
import '../view_model/member.dart';
import '../view_model/register.dart';
import '../view_model/ws.dart';
import '../widget/register/go_to_login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterVm? _registerVm;
  AuthVm? _authVm;
  MemberVm? _memberVm;
  WsVm? _wsVm;

  final _formKey = GlobalKey<FormState>();

  FocusNode focusNodeNickname = FocusNode();
  FocusNode focusNodeAccount = FocusNode();
  FocusNode focusNodePassword = FocusNode();
  FocusNode focusNodeCheckPassword = FocusNode();
  FocusNode focusNodeVerificationCode = FocusNode();

  final TextEditingController _nickname = TextEditingController();
  final TextEditingController _account = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _checkPassword = TextEditingController();
  final TextEditingController _verificationCoed = TextEditingController();

  //是否發送驗證碼
  bool _isSendVerification = false;
  //發送倒數秒數
  Timer? _timer;
  int _countdownTime = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _registerVm = Provider.of<RegisterVm>(context, listen: false);
    _authVm = Provider.of<AuthVm>(context, listen: false);
    _memberVm = Provider.of<MemberVm>(context, listen: false);
    _wsVm = Provider.of<WsVm>(context, listen: false);
    return WillPopScope(
        onWillPop: () => AppRouter.pop(),
        child: Scaffold(
          backgroundColor: AppColor.appBackground,
          resizeToAvoidBottomInset: false,
          body: LayoutBuilder(
            builder: (context, constraints) {
              return SizedBox(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //title
                    const RegisterTitle(),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            //TextField-Nickname
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              child: CombinationTextField(
                                title: '暱稱',
                                isRequired: true,
                                child: NicknameTextField(
                                  focusNode: focusNodeNickname,
                                  controller: _nickname,
                                ),
                              ),
                            ),
                            //TextField-Account
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              child: CombinationTextField(
                                title: '帳號',
                                isRequired: true,
                                child: AccountTextField(
                                  focusNode: focusNodeAccount,
                                  controller: _account,
                                ),
                              ),
                            ),
                            //TextField-Password
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              child: CombinationTextField(
                                title: '密碼',
                                isRequired: true,
                                child: PasswordTextField(
                                    formKey: _formKey,
                                    focusNode: focusNodePassword,
                                    hint: '請輸入密碼(6-12位英數字)',
                                    controller: _password),
                              ),
                            ),
                            //TextField-CheckPassword
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              child: CombinationTextField(
                                title: '密碼確認',
                                isRequired: true,
                                child: CheckPasswordTextField(
                                  focusNode: focusNodeCheckPassword,
                                  controller: _checkPassword,
                                ),
                              ),
                            ),
                            //TextField-VerificationCode
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 20),
                              child: CombinationButtonTextField(
                                title: '驗證碼',
                                isRequired: true,
                                button: SendSmsButton(
                                  text: _isSendVerification
                                      ? '$_countdownTime s'
                                      : '發送驗證碼',
                                  callback: _sendSms,
                                ),
                                child: VerificationCodeTextField(
                                  focusNode: focusNodeVerificationCode,
                                  controller: _verificationCoed,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 60,
                            )
                          ],
                        ),
                      ),
                    ),
                    //下一步按鈕
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                      child: Selector<RegisterVm, bool>(
                        selector: (context, vm) =>
                            vm.buttonState != RegisterButtonState.loading,
                        shouldRebuild: (pre, next) => pre != next,
                        builder: (context, state, _) {
                          return blueRectangleButton(
                              '註冊', state ? _nextPage : null);
                        },
                      ),
                    ),
                    //去登入
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GoToLogin(
                        callback: _login,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ));
  }

  //送出簡訊
  void _sendSms() async {
    //手機不為空
    if (_account.text.trim().isNotEmpty) {
      //沒在倒數
      if (_countdownTime == 0 && !_isSendVerification) {
        bool? r = await _registerVm!.verificationCode(_account.text);
        //發送成功
        if (r != null) {
          if (r) {
            //進入倒數
            _reciprocal();
          }
        }
      }
    }
  }

  void _reciprocal() {
    if (_countdownTime == 0 && !_isSendVerification) {
      _countdownTime = 60;
      _isSendVerification = true;
      setState(() {});
      _startCountdownTimer();
    }
  }

  void _startCountdownTimer() {
    _timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) {
      if (mounted) {
        setState(() {
          if (_countdownTime < 1) {
            _timer!.cancel();
            _timer = null;
            _isSendVerification = false;
          } else {
            _countdownTime--;
          }
        });
      }
    });
  }

  //下一步
  void _nextPage() async {
    if (_registerVm!.buttonState == RegisterButtonState.loading) {
      return;
    }
    if (await _judgmentData()) {
      return;
    }

    if (mounted) SVProgressHUD.show();

    AddRegisterDTO dto = AddRegisterDTO(
        name: _account.text,
        nickname: _nickname.text,
        password: _password.text,
        cellphone: _account.text,
        verificationCode: _verificationCoed.text);
    Tuple<bool, String> r = await _registerVm!.register(dto);
    //Tuple<bool, String> r = Tuple<bool, String>(true, '');
    if (r.i1!) {
      //註冊成功 -> 登入
      login();
    } else {
      //註冊失敗
      if (mounted) SVProgressHUD.dismiss();
      await _showAlert(r.i2!);
    }
  }

  //登入
  void login() async {
    LoginCredential dto =
        LoginCredential(name: _account.text, password: _password.text);
    Tuple<bool, String> r = await _authVm!.login(dto);
    _wsVm!.onCreation(dto);
    if (r.i1!) {
      //登入成功
      await _memberVm!.getMemberInforWithUserIDAndPersistent();
      if (mounted) SVProgressHUD.dismiss();
      if (mounted) context.pushReplacement(RouteName.registerMember);
    } else {
      //登入失敗
      if (mounted) SVProgressHUD.dismiss();
      await _showAlert('登入失敗');
    }
  }

  //註冊驗證
  Future<bool> _judgmentData() async {
    if (textFieldJudgment(_nickname) ||
        textFieldJudgment(_account) ||
        textFieldJudgment(_password) ||
        textFieldJudgment(_checkPassword) ||
        textFieldJudgment(_verificationCoed)) {
      if (textFieldJudgment(_nickname)) {
        return await _showAlert('請輸入暱稱！');
      } else if (textFieldJudgment(_account)) {
        return await _showAlert('請輸入帳號(手機號碼)！');
      } else if (textFieldJudgment(_password)) {
        return await _showAlert('請輸入密碼！');
      } else if (textFieldJudgment(_checkPassword)) {
        return await _showAlert('請確認兩次密碼是否相同！');
      } else if (textFieldJudgment(_verificationCoed)) {
        return await _showAlert('請輸入驗證碼！');
      }
    } else if (!Utils.phoneVerification(_account.text)) {
      log('手機號碼格式錯誤');
      return await _showAlert('手機號碼格式錯誤');
    } else if (!_formKey.currentState!.validate()) {
      log('密碼長度錯誤');
      return await _showAlert('密碼長度錯誤');
    } else if (_password.text != _checkPassword.text) {
      log('請確認兩次密碼是否相同');
      return await _showAlert('請確認兩次密碼是否相同！');
    }
    return false;
  }

  bool textFieldJudgment(TextEditingController controller) {
    if (controller.text.trim().isEmpty) {
      return true;
    }
    return false;
  }

  //登入
  void _login() {
    context.pushReplacement(RouteName.login);
  }

  //錯誤提示對話框
  Future<bool> _showAlert(String text) async {
    Future.delayed(const Duration(milliseconds: 1800),
        () => Navigator.of(context).pop(true));
    return await showCupertinoAlert(
        context: context, content: text, cancel: false, confirmation: false);
  }
}
