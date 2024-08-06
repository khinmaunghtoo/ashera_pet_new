import 'package:ashera_pet_new/utils/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../data/system_setting.dart';
import '../model/system_setting.dart';
import '../model/tuple.dart';

class SystemSettingVm extends ChangeNotifier {
  late PackageInfo _packageInfo;

  int _packageVersion = 0;
  int get packageVersion => _packageVersion;

  int _systemVersion = 0;
  int get systemVersion => _systemVersion;

  void packageInfoInit() async {
    _packageInfo = await PackageInfo.fromPlatform();
    _packageVersion = int.parse(_packageInfo.version.replaceAll('.', ''));
  }

  void systemSettingInit() async {
    Tuple<bool, String> r = await Api.getSystemSetting();
    if (r.i1!) {
      SystemSetting.systemSetting = SystemSettingModel.fromJson(r.i2!);
      _systemVersion = int.parse(
          SystemSetting.systemSetting.appVersionNumber.replaceAll('.', ''));
    }
  }

  //判斷是否更新
  bool judgeIsUpdate() {
    if (_packageVersion < _systemVersion) {
      return true;
    }
    return false;
  }
}
