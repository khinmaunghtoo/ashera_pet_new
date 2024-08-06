import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/model/event_model.dart';
import 'package:ashera_pet_new/utils/shared_preference.dart';
import 'package:ashera_pet_new/utils/utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_android/shared_preferences_android.dart';
import 'package:shared_preferences_ios/shared_preferences_ios.dart';

import '../enum/event_type.dart';
import 'app_sound.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  //* 應該不需要了吧？ main() 已經有 await Firebase.initializeApp() 了
  // await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //         apiKey: 'AIzaSyBQPT2EjWyQ31wruxjuwyIxEI4Uh0ouCMQ',
  //         appId: '1:955930102663:android:ed161a2e1a5d260306e122',
  //         messagingSenderId: '955930102663',
  //         projectId: 'ashera-pet',
  //         storageBucket: 'ashera-pet.appspot.com'));
  if (Platform.isAndroid) SharedPreferencesAndroid.registerWith();
  if (Platform.isIOS) SharedPreferencesIOS.registerWith();
  final sharedPrefs = await SharedPreferences.getInstance();
  sharedPrefs.setString(
      SharedPreferenceUtil.firebase, json.encode(message.toMap()));

  await flutterLocalNotificationsPluginInit();
  await flutterLocalNotificationsPlugin.cancelAll();
  showFlutterNotificationBackground(message);
  log('Handling a background message ${message.messageId}');
}

late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future<void> flutterLocalNotificationsPluginInit() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveLocalNotification,
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveLocalNotification);

  channel = const AndroidNotificationChannel(
      'ahsera_channel', 'ashera_Notifications',
      description: 'Ashera_Pet 推播通知',
      importance: Importance.high,
      sound: RawResourceAndroidNotificationSound('notification'));

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

Future<void> setupFlutterNotifications() async {
  if (isFlutterLocalNotificationsInitialized) {
    return;
  }

  await flutterLocalNotificationsPluginInit();

  if (defaultTargetPlatform == TargetPlatform.iOS ||
      defaultTargetPlatform == TargetPlatform.macOS) {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          sound: true,
          alert: true,
          badge: true,
        );
  } else {
    //android 13
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, badge: true, sound: true);

  isFlutterLocalNotificationsInitialized = true;
}

void openOrCloseFirebaseMessaging(bool value) async {
  /*if(defaultTargetPlatform == TargetPlatform.iOS){
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: value, badge: true, sound: true);
  }*/
}

void onDidReceiveLocalNotification(NotificationResponse response) async {
  // display a dialog with the notification details, tap ok to go to another page
  //log('NotificationResponse: ${response.id} ${response.payload} ${response.notificationResponseType}');
  Utils.notificationBus
      .fire(EventModel(EventType.notification, response.payload));
}

//前景
void showFlutterNotificationForeground(RemoteMessage message) {
  log('showFlutterNotification ${message.toMap()}');
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                icon: '@mipmap/ic_launcher')),
        payload: '${notification.body}');
  }
}

void showFlutterNotificationBackground(RemoteMessage message) {
  log('showFlutterNotificationBackground ${message.toMap()}');
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null && !kIsWeb) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name,
                channelDescription: channel.description,
                icon: '@mipmap/ic_launcher',
                sound:
                    const RawResourceAndroidNotificationSound('notification'))),
        payload: '${notification.body}');
  } else if (notification != null &&
      defaultTargetPlatform == TargetPlatform.iOS) {
    flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
            iOS: DarwinNotificationDetails(sound: 'notification.wav')),
        payload: '${notification.body}');
  }
}

class FirebaseMessage {
  static Future<void> firebaseInit() async {
    //* main() 已經有 await Firebase.initializeApp() 了
    // await Firebase.initializeApp(
    //   options: const FirebaseOptions(
    //       apiKey: 'AIzaSyBQPT2EjWyQ31wruxjuwyIxEI4Uh0ouCMQ',
    //       appId: '1:955930102663:android:ed161a2e1a5d260306e122',
    //       messagingSenderId: '955930102663',
    //       projectId: 'ashera-pet',
    //       storageBucket: 'ashera-pet.appspot.com'
    //   )
    // );
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    if (!kIsWeb) {
      await setupFlutterNotifications();
    }

    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    //前景
    FirebaseMessaging.onMessage.listen((RemoteMessage event) {
      log('onMessage: ${event.toMap()}');
      if (defaultTargetPlatform == TargetPlatform.android) {
        if (Member.nowChatMemberModel == null) {
          //沒有聊天對象一律發送通知
          //showFlutterNotificationForeground(event);
          //播放通知音
          FlutterRingtonePlayer().play(
            fromAsset: AppSound.notification,
          );
        } else {
          //如果有對象
          int index = event.notification!.body!.indexOf('傳送了');
          log('index: $index');
          String name = event.notification!.body!.substring(0, index);
          log('name: $name');
          //對象不是現在聊天對象
          if (Member.nowChatMemberModel!.nickname != name) {
            //showFlutterNotificationForeground(event);
            //播放通知音
            //FlutterRingtonePlayer().play(fromAsset: AppSound.notification,);
          }
        }
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        log('IOS FirebaseMessaging: ${event.toMap()}');
        if (Member.nowChatMemberModel == null) {
          //沒有聊天對象一律發送通知
          //showFlutterNotificationForeground(event);
          //播放通知音
          //FlutterRingtonePlayer().play(fromAsset: AppSound.notification,);
        } else {
          int index = event.notification!.body!.indexOf('傳送了');
          log('index: $index');
          String name = event.notification!.body!.substring(0, index);
          log('name: $name');
          if (Member.nowChatMemberModel!.nickname == name) {
            //FlutterRingtonePlayer().play(fromAsset: AppSound.notification,);
          }
        }
      }
    });
    //點擊開啟
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('A new onMessageOpenedApp event was published! /n ${message.toMap()}');
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        Utils.notificationBus.fire(
            EventModel(EventType.notification, message.notification!.body));
      }
    });
  }

  static void _handleMessage(RemoteMessage message) async {
    if (message.notification!.body!.contains('傳送了')) {
      await Future.delayed(const Duration(milliseconds: 4000));
      Utils.notificationBus
          .fire(EventModel(EventType.notification, message.notification!.body));
    }
  }

  static Future<String?> getToken() async {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      String? token = await FirebaseMessaging.instance.getToken();
      log('FlutterFire Messaging Example: Got APNs token: $token');
      return token;
    } else {
      String? token = await FirebaseMessaging.instance.getToken();
      log('FlutterFire Messaging Example: Got token: $token');
      return token;
    }
  }
}
