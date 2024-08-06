import 'dart:developer';

import 'package:ashera_pet_new/model/about_us.dart';
import 'package:ashera_pet_new/utils/api.dart';
import 'package:flutter/foundation.dart';

import '../model/tuple.dart';

class AboutUsVm with ChangeNotifier {
  bool _isOpen = true;
  bool get isOpen => _isOpen;

  void setAboutStatus(bool value) {
    log('到底初始化是？$value');
    _isOpen = value;
    notifyListeners();
  }

  AboutUsModel? _aboutUsModel;
  AboutUsModel get aboutUsModel => _aboutUsModel!;
  void setAboutUs() async {
    Tuple<bool, String> r = await Api.getAboutUs();
    if (r.i1!) {
      log('get about us: ${r.i2}');
      _aboutUsModel = AboutUsModel.fromJson(r.i2!);
    }
  }
}
