import 'dart:developer';

import 'package:ashera_pet_new/data/auth.dart';
import 'package:ashera_pet_new/enum/login_button_state.dart';
import 'package:ashera_pet_new/model/login.dart';
import 'package:ashera_pet_new/model/register.dart';
import 'package:ashera_pet_new/utils/api.dart';
import 'package:ashera_pet_new/utils/shared_preference.dart';
import 'package:ashera_pet_new/widget/multi_state_button/multi_state_button_controller.dart';
import 'package:flutter/material.dart';

import '../model/forgot_password.dart';
import '../model/tuple.dart';
import '../model/user_login_res.dart';

//* authtication view model
class AuthVm with ChangeNotifier {
  LoginButtonState _buttonState = LoginButtonState.login;
  LoginButtonState get buttonState => _buttonState;

  final MultiStateButtonController _multiStateButtonController =
      MultiStateButtonController();
  MultiStateButtonController get multiStateButtonController =>
      _multiStateButtonController;

  void setButtonState(LoginButtonState state) {
    if (_buttonState != state) {
      _buttonState = state;
      _setMultiState();
    }
  }

  void _setMultiState() {
    _multiStateButtonController.setButtonState = _buttonState.name;
  }

  //* 登入功能
  //* 使用 credential 登入, (账号密码)
  //* 并切持久化 credential, token, id, expire time, use (SharedPreference)

  //* (調用分析)
  //* login page 页面会调用这个方法
  //* login ashera 页面会调用这个方法(但是，这个登录页面好像已经丢弃了)
  //* register 页面会调用这个方法

  //* splash 頁面加載完成後，会调用这个方法
  //* bottom navigation view 每次 resume的时候，如果token过期会调用这个方法

  Future<Tuple<bool, String>> login(LoginCredential credential,
      [bool? isLoginPage]) async {
    if (isLoginPage != null) {
      setButtonState(LoginButtonState.loading);
    }
    //* api 登入
    Tuple<bool, String> loginResult = await Api.postLogin(credential);

    //* 分析登入結果
    print("loginResult.i1, ${loginResult.i1}");
    print("loginResult.i2, ${loginResult.i2}");
    if (loginResult.i2 != null) {
      log('login i2: ${loginResult.i2}');
      if (loginResult.i1!) {
        if (isLoginPage != null) {
          setButtonState(LoginButtonState.success);
        }
        Auth.userLoginResDTO = UserLoginResDTO.fromJson(loginResult.i2!);
        Api.accessToken = Auth.userLoginResDTO.body.token;
        //儲存過期時間＆Token＆ID
        SharedPreferenceUtil.saveAccessToken(Auth.userLoginResDTO.body.token);
        SharedPreferenceUtil.saveExpiredTime(
            Auth.userLoginResDTO.body.expiredTime);
        SharedPreferenceUtil.saveMemberId(Auth.userLoginResDTO.userId);
        //儲存帳號＆密碼
        SharedPreferenceUtil.saveAccount(credential.name);
        SharedPreferenceUtil.savePassword(credential.password);
      } else {
        if (isLoginPage != null) {
          setButtonState(LoginButtonState.login);
        }
      }
    }
    return loginResult;
  }

  //ashera登入
  Future<Tuple<bool, String>> asheraLogin(AddMemberFromAsheraDTO dto) async {
    setButtonState(LoginButtonState.loading);
    Tuple<bool, String> r = await Api.postRegisterFromAsher(dto);
    if (r.i2 != null) {
      log('ashera Login i2: ${r.i2}');
      if (r.i1!) {
        setButtonState(LoginButtonState.success);
      } else {
        setButtonState(LoginButtonState.login);
      }
    }
    return r;
  }

  //* 刷新token
  Future<bool> refreshToken() async {
    log('Token 進入重刷: ${Api.accessToken}');
    Tuple<bool, String> r = await Api.getRefreshToken();
    if (r.i1!) {
      Auth.userLoginResDTO = Auth.userLoginResDTO
          .copyWith(body: GenerateTokenBody.fromJson(r.i2!));
      Api.accessToken = Auth.userLoginResDTO.body.token;
      //儲存過期時間＆Token
      SharedPreferenceUtil.saveAccessToken(Auth.userLoginResDTO.body.token);
      SharedPreferenceUtil.saveExpiredTime(
          Auth.userLoginResDTO.body.expiredTime);
      log('Token: 重刷成功 ${Api.accessToken}');
    }
    return r.i1!;
  }

  //* 找回密码
  Future<Tuple<bool, String>> getForgotPassword(String phoneNumber) async {
    Tuple<bool, String> r =
        await Api.forgotPasswordVerificationCode(phoneNumber);
    if (r.i1!) {
      return Tuple<bool, String>(true, '發送成功');
    }
    return Tuple<bool, String>(false, '發送失敗');
  }

  Future<Tuple<bool, String>> postForgotPassword(
      ForgotPasswordModel dto) async {
    Tuple<bool, String> r = await Api.forgotPassword(dto);
    if (r.i1!) {
      return Tuple<bool, String>(true, r.i2!);
    }
    return Tuple<bool, String>(false, r.i2!);
  }
}
