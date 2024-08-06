import 'dart:developer';

import 'package:ashera_pet_new/dialog/cupertion_alert.dart';
import 'package:ashera_pet_new/enum/login_button_state.dart';
import 'package:ashera_pet_new/model/login.dart';
import 'package:ashera_pet_new/view_model/auth.dart';
import 'package:ashera_pet_new/view_model/member.dart';
import 'package:ashera_pet_new/view_model/member_pet.dart';
import 'package:ashera_pet_new/widget/multi_state_button/multi_state_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/pet.dart';
import '../model/tuple.dart';
import '../routes/app_router.dart';
import '../routes/route_name.dart';
import '../utils/app_color.dart';
import '../utils/shared_preference.dart';
import '../utils/utils.dart';
import '../view_model/post.dart';
import '../view_model/ws.dart';
import '../widget/login/go_to_register.dart';
import '../widget/login/or.dart';
import '../widget/login/terms_forget_password.dart';
import '../widget/login/title.dart';
import '../widget/multi_state_button/button_state.dart';
import '../widget/text_field.dart';

//* 当前正在使用的login页面
//* 另外一个登录页面 login ashera page 已经丢弃
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  FocusNode focusNodeAccount = FocusNode();
  FocusNode focusNodePassword = FocusNode();

  final TextEditingController _account = TextEditingController();
  final TextEditingController _password = TextEditingController();

  bool _isAgreedTerms = false;

  AuthVm? _authVm;
  MemberVm? _memberVm;
  MemberPetVm? _petVm;
  WsVm? _wsVm;
  PostVm? _postVm;

  _onLayoutDone(_) {
    log('_onLayoutDone');
    if (mounted) {
      _authVm!.setButtonState(LoginButtonState.login);
    }
  }

  @override
  void initState() {
    super.initState();
    FlutterNativeSplash.remove();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
  }

  @override
  Widget build(BuildContext context) {
    _authVm = Provider.of<AuthVm>(context, listen: false);
    _memberVm = Provider.of<MemberVm>(context, listen: false);
    _petVm = Provider.of<MemberPetVm>(context, listen: false);
    _wsVm = Provider.of<WsVm>(context, listen: false);
    _postVm = Provider.of<PostVm>(context, listen: false);
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
                    const LoginTitle(),
                    Flexible(
                        child: SingleChildScrollView(
                      child: Column(
                        children: [
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
                        ],
                      ),
                    )),
                    //條約 忘記密碼
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 20),
                      child: TermsAndForgetPassword(
                        isAgreedTerms: _isAgreedTerms,
                        onChange: _onChange,
                        forgetClick: _forgetClick,
                        termsClick: _termsClick,
                      ),
                    ),
                    //登入按鈕
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                      child: _loginButton(
                          constraints.maxHeight, constraints.maxWidth),
                    ),
                    //使用ashera帳號登入
                    /*Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: UserAsheraLogin(
                        callback: _userAsheraLogin,
                      ),
                    ),*/
                    //或
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 40),
                      child: const Or(),
                    ),
                    //去註冊
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GoToRegister(
                        callback: _register,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ));
  }

  //條款確認
  ValueChanged<bool?>? _onChange(value) {
    setState(() {
      _isAgreedTerms = value!;
    });
    return null;
  }

  //* 登入成功后跳转
  //*? 为什么在这里读取那么多数据?
  //*? 应该去相应的页面，对相应的数据？
  //*? 没发帖，为什么度背景图？

  void _navigate() async {
    //* 获取所有背景图
    _postVm!.getAllPostBackground();

    //* 获取用户信息
    await _memberVm!.getMemberInforWithUserIDAndPersistent();

    //* 获取宠物信息
    await _petVm!.getPet();

    //* 如果没有宠物？去注册宠物页面
    if (Pet.petModel.isEmpty) {
      if (mounted) context.pushReplacement(RouteName.registerPet);
    } else {
      // 如果有宠物，去bottom navigation
      if (mounted) context.pushReplacement(RouteName.bottomNavigation);
    }
  }

  //使用ashera 帳號登入
  void _userAsheraLogin() {
    context.push(RouteName.loginAshera);
  }

  //去註冊
  void _register() {
    context.pushReplacement(RouteName.register);
  }

  //條約
  void _termsClick() {
    //對話框
  }

  //忘記密碼
  void _forgetClick() {
    context.push(RouteName.forgetPassword);
  }

  Widget _loginButton(double height, double width) {
    return Consumer<AuthVm>(
      builder: (context, authVm, _) {
        return MultiStateButton(
          multiStateButtonController: authVm.multiStateButtonController,
          buttonStates: [
            //登入按鈕
            ButtonState(
                stateName: LoginButtonState.login.name,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    LoginButtonState.login.zh,
                    style: const TextStyle(
                        color: AppColor.textFieldTitle,
                        fontSize: 18,
                        height: 1.1),
                  ),
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: AppColor.button,
                    borderRadius: BorderRadius.circular(15)),
                size: Size(width / 1.18, height / 15.8),
                onPressed: _doLogin),
            //讀取中
            ButtonState(
              stateName: LoginButtonState.loading.name,
              alignment: Alignment.center,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColor.textFieldTitle,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  color: AppColor.button,
                  borderRadius: BorderRadius.circular(15)),
              size: Size(height / 15.8, height / 15.8),
            ),
            //登入成功
            ButtonState(
              stateName: LoginButtonState.success.name,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  LoginButtonState.success.zh,
                  style: const TextStyle(
                      color: AppColor.textFieldTitle,
                      fontSize: 18,
                      height: 1.1),
                ),
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: AppColor.button,
                  borderRadius: BorderRadius.circular(15)),
              size: Size(width / 1.18, height / 15.8),
            )
          ],
        );
      },
    );
  }

  //* login动作
  void _doLogin() async {
    if (await _judgmentData()) {
      return;
    }
    if (!_isAgreedTerms) {
      await _showAlert('請先閱讀用戶條款並同意條款內容，勾選後即可登入');
      return;
    }

    //* credential
    LoginCredential credential =
        LoginCredential(name: _account.text, password: _password.text);

    //* 登入
    Tuple<bool, String> loginResult = await _authVm!.login(credential, true);

    if (loginResult.i1!) {
      String loginDate = Utils.sqlDateFormatTest.format(DateTime.now());
      SharedPreferenceUtil.saveBackgroundTime(loginDate);

      //* ws connect
      _wsVm!.onCreation(credential);

      // navigate
      _navigate();
    } else {
      await _showAlert(Utils.apiErrorMessage(loginResult.i2!));
    }
  }

  //判斷資料
  Future<bool> _judgmentData() async {
    if (_account.text.trim().isEmpty) {
      return await _showAlert('請輸入帳號!');
    } else if (!Utils.phoneVerification(_account.text)) {
      return await _showAlert('手機號碼格式錯誤!');
    } else if (_password.text.trim().isEmpty) {
      return await _showAlert('請輸入密碼!');
    } else if (!_formKey.currentState!.validate()) {
      return await _showAlert('密碼長度錯誤');
    }
    return false;
  }

  Future<bool> _showAlert(String text) async {
    Future.delayed(const Duration(milliseconds: 1800),
        () => Navigator.of(context).pop(true));
    return await showCupertinoAlert(
        context: context, content: text, cancel: false, confirmation: false);
  }
}
