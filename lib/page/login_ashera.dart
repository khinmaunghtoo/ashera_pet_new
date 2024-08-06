import 'package:ashera_pet_new/model/login.dart';
import 'package:ashera_pet_new/model/register.dart';
import 'package:ashera_pet_new/model/tuple.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/view_model/member_pet.dart';
import 'package:ashera_pet_new/view_model/ws.dart';
import 'package:ashera_pet_new/widget/back_button.dart';
import 'package:ashera_pet_new/widget/login/terms_forget_password.dart';
import 'package:ashera_pet_new/widget/text_field.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../data/pet.dart';
import '../dialog/cupertion_alert.dart';
import '../enum/login_button_state.dart';
import '../enum/register.dart';
import '../routes/route_name.dart';
import '../utils/utils.dart';
import '../view_model/auth.dart';
import '../view_model/member.dart';
import '../widget/login_ashera/title.dart';
import '../widget/multi_state_button/button_state.dart';
import '../widget/multi_state_button/multi_state_button.dart';

// 登入頁面(应该没有在用了)
// 目前使用的是 login_page.dart, LoginPage
class LoginAsheraPage extends StatefulWidget {
  const LoginAsheraPage({super.key});

  @override
  State<StatefulWidget> createState() => _LoginAsheraPageState();
}

class _LoginAsheraPageState extends State<LoginAsheraPage> {
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

  _onLayoutDone(_) {
    if (mounted) {
      _authVm!.setButtonState(LoginButtonState.login);
    }
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
    _petVm = Provider.of<MemberPetVm>(context, listen: false);
    _wsVm = Provider.of<WsVm>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColor.appBackground,
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                    top: 10 + MediaQuery.of(context).padding.top,
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
                    const LoginAsheraTitle(),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _accountWidget(),
                            _passwordWidget(),
                            _agreedTermsWidget(),
                            _loginButtonWidget(constraints)
                          ],
                        ),
                      ),
                    ),
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

  //account
  Widget _accountWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: CombinationTextField(
        title: '帳號',
        isRequired: true,
        child: AccountTextField(
          focusNode: focusNodeAccount,
          controller: _account,
        ),
      ),
    );
  }

  //password
  Widget _passwordWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: CombinationTextField(
        title: '密碼',
        isRequired: true,
        child: PasswordTextField(
          formKey: _formKey,
          focusNode: focusNodePassword,
          hint: '請輸入密碼(6-12位英數字)',
          controller: _password,
        ),
      ),
    );
  }

  //條約
  Widget _agreedTermsWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: TermsAndForgetPassword(
        isAgreedTerms: _isAgreedTerms,
        onChange: _onChange,
        forgetClick: () {},
        termsClick: _termsClick,
        isShowForgetPassword: false,
      ),
    );
  }

  //登入按鈕
  Widget _loginButtonWidget(BoxConstraints constraints) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: _loginButton(constraints.maxHeight, constraints.maxWidth),
    );
  }

  Widget _loginButton(double height, double width) {
    return Consumer<AuthVm>(
      builder: (context, vm, _) {
        return MultiStateButton(
          multiStateButtonController: vm.multiStateButtonController,
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
                onPressed: () => _onTap()),
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

  void _onTap() async {
    if (await _judgmentData()) {
      return;
    }
    if (!_isAgreedTerms) {
      await _showAlert('請先閱讀用戶條款並同意條款內容，勾選後即可登入');
    }
    AddMemberFromAsheraDTO dto =
        AddMemberFromAsheraDTO(name: _account.text, password: _password.text);
    Tuple<bool, String> r = await _authVm!.asheraLogin(dto);
    //成功註冊Pet
    if (r.i1!) {
      _judgmentEntrance(r.i2!);
    } else {
      await _showAlert(Utils.apiErrorMessage(r.i2!));
    }
  }

  //判斷資料
  Future<bool> _judgmentData() async {
    if (_account.text.trim().isEmpty || _password.text.trim().isEmpty) {
      if (_account.text.trim().isEmpty) {
        return await _showAlert('請輸入帳號!');
      } else if (!Utils.phoneVerification(_account.text)) {
        return await _showAlert('手機號碼格式錯誤!');
      } else {
        return await _showAlert('請輸入密碼!');
      }
    } else if (!_formKey.currentState!.validate()) {
      return await _showAlert('密碼長度錯誤');
    }
    return false;
  }

  //判斷登入入口
  void _judgmentEntrance(String value) async {
    RegMemberResDTO dto = RegMemberResDTO.fromJson(value);
    switch (dto.code) {
      case RegMemberResCode.FAIL:
        //綁定失敗
        await _showAlert('綁定失敗！');
        break;
      case RegMemberResCode.LOGIN:
        //直接登入
        _login();
        break;
      case RegMemberResCode.SUCCESS:
        //綁定成功
        await _showAlert('綁定成功！');
        _login();
        break;
    }
  }

  void _login() async {
    LoginCredential dto =
        LoginCredential(name: _account.text, password: _password.text);
    await _authVm!.login(dto);
    _wsVm!.onCreation(dto);
    await _memberVm!.getMemberInforWithUserIDAndPersistent();
    await _petVm!.getPet();
    if (Pet.petModel.isEmpty) {
      if (mounted) context.pushReplacement(RouteName.registerPet);
    } else {
      if (mounted) context.pushReplacement(RouteName.bottomNavigation);
    }
  }

  //條款確認
  ValueChanged<bool?>? _onChange(value) {
    setState(() {
      _isAgreedTerms = value!;
    });
    return null;
  }

  //條約
  void _termsClick() {
    //對話框
  }

  Future<bool> _showAlert(String text) async {
    Future.delayed(const Duration(milliseconds: 1800),
        () => Navigator.of(context).pop(true));
    return await showCupertinoAlert(
        context: context, content: text, cancel: false, confirmation: false);
  }
}
