import 'package:ashera_pet_new/root_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ashera_pet_new/utils/firebase_message.dart';

void main() async {
  //* 啟動畫面
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  //* Initial Firease Stuffs
  // const options = FirebaseOptions(
  //     apiKey: 'AIzaSyBQPT2EjWyQ31wruxjuwyIxEI4Uh0ouCMQ',
  //     appId: '1:955930102663:android:ed161a2e1a5d260306e122',
  //     messagingSenderId: '955930102663',
  //     projectId: 'ashera-pet',
  //     storageBucket: 'ashera-pet.appspot.com');
  // await Firebase.initializeApp(options: options);
  await Firebase.initializeApp();
  await FirebaseMessage.firebaseInit();

  //* Set portrait orientation
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const RootView());
  });

  //*? 回調函數, 當設備media內容發生變化時, 會調用此函數，會即時更新。
  //  有必要在這裡register嗎？
  //  應該在選擇圖片的時候頁面？
  // AssetPicker.registerObserve();

  //*? 應該不用吧？ Enables logging with the photo_manager.
  // PhotoManager.setLog(true);
}
