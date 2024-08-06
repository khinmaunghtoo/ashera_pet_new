import 'dart:developer';

import 'package:ashera_pet_new/enum/register.dart';
import 'package:flutter/cupertino.dart';

import '../model/register.dart';
import '../model/tuple.dart';
import '../utils/api.dart';

class RegisterVm with ChangeNotifier {
  RegisterButtonState _buttonState = RegisterButtonState.register;
  RegisterButtonState get buttonState => _buttonState;
  //註冊功能
  Future<Tuple<bool, String>> register(AddRegisterDTO dto) async {
    _buttonState = RegisterButtonState.loading;
    notifyListeners();
    Tuple<bool, String> r = await Api.postRegister(dto);
    if (r.i1!) {
      //註冊成功
      _buttonState = RegisterButtonState.success;
      notifyListeners();
    } else {
      //註冊失敗
      _buttonState = RegisterButtonState.error;
      notifyListeners();
    }
    if (r.i2 != null) {
      log('register i2: ${r.i2}');
    }
    return r;
  }

  //驗證碼
  Future<bool?> verificationCode(String number) async {
    Tuple<bool, String> r = await Api.getVerificationCode(number);
    if (r.i2 != null) {
      log('verification i2: ${r.i2}');
    }
    return r.i1;
  }
}
