import 'dart:async';

import 'package:ashera_pet_new/model/forgot_password.dart';
import 'package:ashera_pet_new/view_model/auth.dart';
import 'package:ashera_pet_new/widget/button.dart';
import 'package:ashera_pet_new/widget/forget_password/title.dart';
import 'package:ashera_pet_new/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../model/tuple.dart';
import '../utils/app_color.dart';
import '../widget/back_button.dart';
import '../widget/forget_password/sms_button.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<StatefulWidget> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  AuthVm? _authVm;
  final _formKey = GlobalKey<FormState>();
  FocusNode focusNodePhone = FocusNode();
  FocusNode focusNodeVerificationCode = FocusNode();
  FocusNode focusNodePassword = FocusNode();

  final TextEditingController _phone = TextEditingController();
  final TextEditingController _verificationCode = TextEditingController();
  final TextEditingController _password = TextEditingController();
  //是否發送驗證碼
  bool _isSendVerification = false;
  //發送倒數秒數
  Timer? _timer;
  int _countdownTime = 0;

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
    _authVm = Provider.of<AuthVm>(context);
    return Scaffold(
      backgroundColor: AppColor.appBackground,
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Stack(
              fit: StackFit.expand,
              alignment: Alignment.center,
              children: [
                //返回
                Positioned(
                    top: 10 + MediaQuery.of(context).viewPadding.top,
                    left: 10,
                    child: TopBackButton(
                      alignment: Alignment.centerLeft,
                      callback: _back,
                    )),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //title
                    const ForgetPasswordTitle(),
                    //TextField-Phone
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: CombinationTextField(
                        title: '手機號碼',
                        isRequired: true,
                        child: PhoneTextField(
                          focusNode: focusNodePhone,
                          controller: _phone,
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
                          controller: _verificationCode,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: CombinationTextField(
                        title: '新密碼',
                        isRequired: true,
                        child: PasswordTextField(
                          formKey: _formKey,
                          focusNode: focusNodePassword,
                          controller: _password,
                          hint: '請輸入密碼(6-12位英數字)',
                        ),
                      ),
                    ),
                    //送出
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                      child: blueRectangleButton('送出', _send),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  //返回
  void _back() {
    context.pop();
  }

  //送出簡訊
  void _sendSms() async {
    //手機不為空
    if (_phone.text.trim().isNotEmpty) {
      Tuple<bool, String> r = await _authVm!.getForgotPassword(_phone.text);
      if (r.i1!) {
        _reciprocal();
      } else {
        SVProgressHUD.showError(status: '${r.i2}');
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

  //送出
  void _send() async {
    if (_verificationCode.text.trim().isEmpty) {
      SVProgressHUD.showError(status: '請輸入驗證碼');
      return;
    }
    if (_password.text.trim().isEmpty) {
      SVProgressHUD.showError(status: '請輸入新密碼');
      return;
    }
    ForgotPasswordModel dto = ForgotPasswordModel(
        code: _verificationCode.text,
        number: _phone.text,
        password: _password.text);
    Tuple<bool, String> r = await _authVm!.postForgotPassword(dto);
    if (r.i1!) {
      SVProgressHUD.showSuccess(status: '更新完成');
      if (mounted) context.pop();
    } else {
      SVProgressHUD.showSuccess(status: '更新失敗');
    }
  }
}
