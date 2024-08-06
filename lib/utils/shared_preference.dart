import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/login.dart';

class SharedPreferenceUtil {
  //accessToken
  static const String accessToken = 'accessToken';
  //refreshTime
  static const String expiredTime = 'expiredTime';
  //memberId
  static const String memberId = 'memberId';
  //account
  static const String account = 'account';
  //password
  static const String password = 'password';
  //send_record
  static String sendRecord(String name) => 'sendRecord$name';
  //firebase
  static const firebase = 'firebase';
  //recordTheScrollLastTime
  static const String recordTheScrollLastTime = 'recordTheScrollLastTime';
  //backgroundTime
  static const String backgroundTime = 'backgroundTime';

  //saveBackgroundTime
  //*? 这里有保存过登录时间
  static void saveBackgroundTime(String value) {
    _saveString(backgroundTime, value);
  }

  //readBackgroundTime
  static Future<String> readBackgroundTime() async {
    return await _readString(backgroundTime);
  }

  //saveAccessToken
  static void saveAccessToken(String value) {
    _saveString(accessToken, value);
  }

  //readAccessToken
  static Future<String> readAccessToken() async {
    return await _readString(accessToken);
  }

  //removeAccessToken
  static void removeAccessToken() {
    _remove(accessToken);
  }

  //saveExpiredTime
  static void saveExpiredTime(int value) {
    _saveInt(expiredTime, value);
  }

  //readExpiredTime
  static Future<int> readExpiredTime() async {
    final expireTime = await _readInt(expiredTime);
    //* read expired time
    print("readExpiredTime: $expireTime");
    return expireTime;
  }

  //removeExpiredTime
  static void removeExpiredTime() {
    _remove(expiredTime);
  }

  //saveMemberId
  static void saveMemberId(int value) {
    _saveInt(memberId, value);
  }

  //readMemberId
  static Future<int> readMemberId() async {
    return await _readInt(memberId);
  }

  //removeMemberId
  static void removeMemberId() {
    _remove(memberId);
  }

  //saveAccount
  static void saveAccount(String value) {
    _saveString(account, value);
  }

  //readAccount
  static Future<String> readAccount() async {
    return await _readString(account);
  }

  //removeAccount
  static void removeAccount() {
    _remove(account);
  }

  //savePassword
  static void savePassword(String value) {
    _saveString(password, value);
  }

  //readPassword
  static Future<String> readPassword() async {
    return await _readString(password);
  }

  //removePassword
  static void removePassword() {
    _remove(password);
  }

  //readAccountAndPassword
  static Future<LoginCredential> getLoginCredential() async {
    return LoginCredential(
        name: await readAccount(), password: await readPassword());
  }

  //removeMember
  static void removeMember() {
    removeAccount();
    removePassword();
    removeAccessToken();
    removeExpiredTime();
    removeMemberId();
  }

  //儲存未發出聊天訊息
  static void saveSendRecord(String name, String value) {
    _saveString(sendRecord(name), value);
  }

  //讀取未發出的聊天訊息
  static Future<String> readSendRecord(String name) async {
    return _readString(sendRecord(name));
  }

  //刪除未發出的聊天訊息
  static void removeSendRecord(String name) {
    _remove(sendRecord(name));
  }

  //儲存推播內容
  static void saveFirebase(String value) {
    _saveString(firebase, value);
  }

  //儲存滾動最後時間
  static void saveRecordTheScrollLastTime(int value) {
    _saveInt(recordTheScrollLastTime, value);
  }

  //讀取滾動最後時間
  static Future<int> readRecordTheScrollLastTime() {
    return _readInt(recordTheScrollLastTime);
  }

  //刪除滾動最後時間
  static void removeRecordTheScrollLastTime() {
    _remove(recordTheScrollLastTime);
  }

  //saveString
  static void _saveString(String key, String value) async {
    log('Save: $key $value');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(key, value);
  }

  //saveInt
  static void _saveInt(String key, int value) async {
    log('Save: $key $value');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(key, value);
  }

  //read String
  static Future<String> _readString(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getString(key) ?? '';
  }

  //read Int
  static Future<int> _readInt(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    return sharedPreferences.getInt(key) ?? 0;
  }

  //remove
  static void _remove(String key) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove(key);
  }
}
