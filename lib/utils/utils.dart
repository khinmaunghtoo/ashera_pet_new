import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:ashera_pet_new/enum/animal.dart';
import 'package:ashera_pet_new/model/member_pet.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:heic_to_jpg/heic_to_jpg.dart';
import 'package:intl/intl.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

import '../enum/notify_time_type.dart';
import '../enum/photo_type.dart';
import '../model/message.dart';
import '../model/post_background_model.dart';
import 'api.dart';
import 'app_color.dart';
import 'firebase_message.dart';

class Utils {
  static EventBus notificationBus = EventBus();
  static EventBus locationBus = EventBus();

  static String? initialLink;
  static String shareBaseUrl = 'ashera-pet.cc://post/splash#id:';

  static List<PostBackgroundModel> postBackgroundLists = [];

  //AppBar高度
  static const double appBarHeight = 60;

  static final DateFormat sqlDateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ");
  static final DateFormat sqlDateFormatTest = DateFormat("yyyy-MM-dd HH:mm:ss");
  static final DateFormat dateFormatBirthDay = DateFormat("yyyy/MM/dd");
  static final DateFormat dateFormatPetBirthDay = DateFormat("yyyy/MM");
  static final DateFormat dateLoveContentDate = DateFormat("yyyy.MM.dd");
  static final DateFormat dateFormat = DateFormat("yyyy/MM/dd HH:mm");
  static final DateFormat dateTimeFormat = DateFormat("HH:mm");
  static final DateFormat dateDay = DateFormat("MM/dd");

  //TextField BackgroundColor
  static Color getTextFieldFillColor(FocusNode focus) {
    if (focus.hasFocus) {
      return AppColor.textFieldSelect;
    }
    return AppColor.textFieldUnSelect;
  }

  //判斷是否超時
  static bool isExpired(int value) {
    DateTime today = DateTime.now();
    DateTime expiredTime = DateTime.fromMillisecondsSinceEpoch(value * 1000);
    log('判斷是否超時: ${today.isAfter(expiredTime)} $expiredTime');
    return today.isAfter(expiredTime);
  }

  //還有多久過期
  static Duration howLongIsItExpired(int value) {
    DateTime today = DateTime.now();
    DateTime expiredTime = DateTime.fromMillisecondsSinceEpoch(value * 1000);
    return expiredTime.difference(today);
  }

  //生日格式
  static String getBirthday(DateTime date) {
    return dateFormatBirthDay.format(date);
  }

  //寵物生日格式
  static String getPetBirthday(DateTime date) {
    return dateFormatPetBirthDay.format(date);
  }

  //年齡
  static int getAge(String day) {
    int age = 0;
    DateTime d = dateFormatBirthDay.parse(day);
    DateTime date = DateTime.now();
    if (date.isBefore(d)) {
      return 0;
    }
    int yearNow = date.year; //當前年分
    int monthNow = date.month; //當前月份
    int dayOfMonthNow = date.day; //當前日期

    int yearBirth = d.year;
    int monthBirth = d.month;
    int dayOfMonthBirth = d.day;

    age = yearNow - yearBirth; //計算歲數
    if (monthNow <= monthBirth) {
      if (monthNow == monthBirth) {
        if (dayOfMonthNow < dayOfMonthBirth) age--; //當前日期在生日之前 年齡減一
      } else {
        age--; //當前月份在生日之前 年齡減一
      }
    }
    return age;
  }

  //寵物年齡
  static int getPetAge(String day) {
    int age = 0;
    DateTime d = dateFormatPetBirthDay.parse(day);
    DateTime date = DateTime.now();
    if (date.isBefore(d)) {
      return 0;
    }
    int yearNow = date.year; //當前年分
    int monthNow = date.month; //當前月份
    int dayOfMonthNow = date.day; //當前日期

    int yearBirth = d.year;
    int monthBirth = d.month;
    int dayOfMonthBirth = d.day;

    age = yearNow - yearBirth; //計算歲數
    if (monthNow <= monthBirth) {
      if (monthNow == monthBirth) {
        if (dayOfMonthNow < dayOfMonthBirth) age--; //當前日期在生日之前 年齡減一
      } else {
        age--; //當前月份在生日之前 年齡減一
      }
    }
    return age;
  }

  //千分位
  static String getNumber(int number) {
    NumberFormat format = NumberFormat('#,##0', 'zh_TW');
    return format.format(number);
  }

  //人數
  static String getNumberOfPeople(int number) {
    NumberFormat format = NumberFormat.compactCurrency(
        decimalDigits: 0,
        //locale: 'en_IN',
        symbol: '');
    log('數字: $number ${format.format(number)}');
    return format.format(number).toLowerCase();
  }

  //小紅點寬度計算
  static double redDotWidth(String num) {
    if (num.length == 1) {
      return 18.0;
    } else if (num.length == 2) {
      return 25.0;
    } else if (num.length == 3) {
      return 35.0;
    } else {
      return 35.0;
    }
  }

  //性別 男/女 Icon
  static Icon genderIcon(int gender) {
    switch (gender) {
      case 0:
        return const Icon(
          Icons.male,
          size: 20,
          color: AppColor.male,
        );
      case 1:
        return const Icon(
          Icons.female,
          size: 20,
          color: AppColor.female,
        );
      default:
        return const Icon(
          Icons.visibility_off_outlined,
          size: 20,
          color: AppColor.textFieldHintText,
        );
    }
  }

  //手機號碼驗證
  static bool phoneVerification(String phoneNumber) {
    if (phoneNumber.isEmpty) return false;
    return RegExp(r'^09\d{8}$').hasMatch(phoneNumber);
  }

  //是否是影片
  static bool videoFileVerification(String url) {
    if (url.isEmpty) return false;
    return RegExp(
            r'.*\.(mkv|webm|flv|vob|ogg|ogv|drc|gifv|mng|avi|mov|qt|wmv|yuv|rm|rmvb|asf|amv|mp4|m4v|.mp|.m?v|svi|3gp|f4v|MOV|MP4)$')
        .hasMatch(url);
  }

  //是否是圖片
  static bool imageFileVerification(String url) {
    if (url.isEmpty) return false;
    return RegExp(r'.*\.(jpg|jpeg|png|gif)$').hasMatch(url);
  }

  //是否是今天
  static bool isToday(String time) {
    String nowTime = dateFormat.format(DateTime.now());
    return nowTime.compareTo(time) == 0;
  }

  //File
  static String getFilePath(String filename) {
    return '${Api.baseUrl}${Api.filePath}$filename';
  }

  static String getPublicPath(String filename) {
    return '${Api.baseUrl}${Api.publicPath}$filename';
  }

  //回推多久前
  static String getPostTime(String value) {
    DateTime nowTime = DateTime.now();
    DateTime postTime = DateTime.parse(value);
    Duration duration = nowTime.difference(postTime);
    int year = (duration.inDays / 365).floor();
    int month = (duration.inDays / 30).floor();
    int week = (duration.inDays / 7).floor();
    int days = duration.inDays;
    int hours = duration.inHours;
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds;
    if (year < 1) {
      if (month < 1) {
        if (week < 1) {
          if (days == 0) {
            if (hours == 0) {
              if (minutes == 0) {
                if (seconds < 0) {
                  return '0 秒前';
                }
                return '$seconds 秒前';
              }
              return '$minutes 分鐘前';
            }
            return '$hours 小時前';
          }
          return '$days 天前';
        }
        return '$week 週前';
      }
      return '$month 月前';
    }
    return '$year 年前';
  }

  //分類
  static NotifyTimeType getNotifyTimeType(String value) {
    DateTime nowTime = DateTime.now();
    DateTime notifyTime = DateTime.parse(value);
    //判斷是不是同一年
    if (nowTime.year == notifyTime.year) {
      //判斷是不是同一個月
      if (nowTime.month == notifyTime.month) {
        //是同一個月，判斷是否是同一週
        //log('是同一個月，判斷是否是同一週: notifyTime ${notifyTime.day }, weekStart ${weekStart(nowTime).day}, weekEnd ${weekEnd(nowTime).day}');
        if (notifyTime.day >= weekStart(nowTime).day &&
            notifyTime.day <= weekEnd(nowTime).day) {
          return NotifyTimeType.thisWeek;
        }
        return NotifyTimeType.thisMonth;
      }
      return NotifyTimeType.earlier;
    }
    return NotifyTimeType.earlier;
  }

  //本週一
  static DateTime weekStart(DateTime now) {
    return DateTime(now.year, now.month, now.day - now.weekday + 1);
  }

  //本週日
  static DateTime weekEnd(DateTime now) {
    return DateTime(now.year, now.month, now.day - now.weekday + 7);
  }

  static String sqlTimeToHHAndMM(String value) {
    DateTime sqlTime;
    if (value.contains('T')) {
      sqlTime = sqlDateFormat.parse(value);
    } else {
      sqlTime = sqlDateFormatTest.parse(value);
    }

    if (isToday(value)) {
      return dateDay.format(sqlTime);
    }
    return dateTimeFormat.format(sqlTime.toLocal());
  }

  //取檔案名稱
  static Future<Map<String, dynamic>> getFileName(
      String account, String path, PhotoType type,
      [MemberPetModel? petModel]) async {
    return {
      'fileName':
          '${account}_${type.name}.${path.substring(path.lastIndexOf(".") + 1, path.length)}',
      'path': path
    };
    //* 這個heic to jpg的套件版本有問題，安卓那邊無法build，先不用
    // switch (type) {
    //   case PhotoType.tmp:
    //     if (path.contains('.heic')) {
    //       return {
    //         'fileName': '${account}_${type.name}.jpg',
    //         'path': (await HeicToJpg.convert(path).catchError((e) {}))!
    //       };
    //     } else {
    //       return {
    //         'fileName':
    //             '${account}_${type.name}.${path.substring(path.lastIndexOf(".") + 1, path.length)}',
    //         'path': path
    //       };
    //     }
    //   case PhotoType.mugshot:
    //     if (path.contains('.heic')) {
    //       return {
    //         'fileName': '${account}_${type.name}.jpg',
    //         'path': (await HeicToJpg.convert(path).catchError((e) {}))!
    //       };
    //     } else {
    //       return {
    //         'fileName':
    //             '${account}_${type.name}.${path.substring(path.lastIndexOf(".") + 1, path.length)}',
    //         'path': path
    //       };
    //     }
    //   case PhotoType.more:
    //     if (path.contains('.heic')) {
    //       return {
    //         'fileName':
    //             '${account}_${type.name}_${petModel!.id}_${DateTime.timestamp().millisecond}.jpg',
    //         'path': (await HeicToJpg.convert(path).catchError((e) {}))!
    //       };
    //     } else {
    //       return {
    //         'fileName':
    //             '${account}_${type.name}_${petModel!.id}_${DateTime.timestamp().millisecond}.${path.substring(path.lastIndexOf(".") + 1, path.length)}',
    //         'path': path
    //       };
    //     }
    //   case PhotoType.pet:
    //     if (petModel!.animalType == AnimalType.dog.index) {
    //       if (path.contains('.heic')) {
    //         return {
    //           'fileName': '${account}_${petModel.id}_dog_mugshot.jpg',
    //           'path': (await HeicToJpg.convert(path).catchError((e) {}))!
    //         };
    //       } else {
    //         return {
    //           'fileName':
    //               '${account}_${petModel.id}_dog_mugshot.${path.substring(path.lastIndexOf(".") + 1, path.length)}',
    //           'path': path
    //         };
    //       }
    //     } else {
    //       if (path.contains('.heic')) {
    //         return {
    //           'fileName': '${account}_${petModel.id}_cat_mugshot.jpg',
    //           'path': (await HeicToJpg.convert(path).catchError((e) {}))!
    //         };
    //       } else {
    //         return {
    //           'fileName':
    //               '${account}_${petModel.id}_cat_mugshot.${path.substring(path.lastIndexOf(".") + 1, path.length)}',
    //           'path': path
    //         };
    //       }
    //     }
    //   case PhotoType.face:
    //     if (petModel!.animalType == AnimalType.dog.index) {
    //       if (path.contains('.heic')) {
    //         return {
    //           'fileName': '${account}_${petModel.id}_dog_face.jpg',
    //           'path': (await HeicToJpg.convert(path).catchError((e) {}))!
    //         };
    //       } else {
    //         return {
    //           'fileName':
    //               '${account}_${petModel.id}_dog_face.${path.substring(path.lastIndexOf(".") + 1, path.length)}',
    //           'path': path
    //         };
    //       }
    //     } else {
    //       if (path.contains('.heic')) {
    //         return {
    //           'fileName': '${account}_${petModel.id}_cat_face.jpg',
    //           'path': (await HeicToJpg.convert(path).catchError((e) {}))!
    //         };
    //       } else {
    //         return {
    //           'fileName':
    //               '${account}_${petModel.id}_cat_face.${path.substring(path.lastIndexOf(".") + 1, path.length)}',
    //           'path': path
    //         };
    //       }
    //     }
    //   case PhotoType.interactive:
    //     return {
    //       'fileName':
    //           '${account}_${type.name}.${path.substring(path.lastIndexOf(".") + 1, path.length)}',
    //       'path': path
    //     };
    //   case PhotoType.complaint:
    //     return {
    //       'fileName':
    //           '${account}_${type.name}.${path.substring(path.lastIndexOf(".") + 1, path.length)}',
    //       'path': path
    //     };
    //   case PhotoType.image:
    //     if (path.contains('.heic')) {
    //       return {
    //         'fileName':
    //             '${account}_${path.substring(path.lastIndexOf("/") + 1, path.length)}',
    //         'path': (await HeicToJpg.convert(path).catchError((e) {}))!
    //       };
    //     } else {
    //       return {
    //         'fileName':
    //             '${account}_${path.substring(path.lastIndexOf("/") + 1, path.length)}',
    //         'path': path
    //       };
    //     }
    //   case PhotoType.video:
    //     return {
    //       'fileName':
    //           '${account}_${path.substring(path.lastIndexOf("/") + 1, path.length)}',
    //       'path': path
    //     };
    //   case PhotoType.report:
    //     if (path.contains('.heic')) {
    //       return {
    //         'fileName':
    //             '${account}_report_${path.substring(path.lastIndexOf("/") + 1, path.length)}',
    //         'path': (await HeicToJpg.convert(path).catchError((e) {}))!
    //       };
    //     } else {
    //       return {
    //         'fileName':
    //             '${account}_report_${path.substring(path.lastIndexOf("/") + 1, path.length)}',
    //         'path': path
    //       };
    //     }
    // }
  }

  static String apiErrorMessage(String value) {
    return value.substring(value.lastIndexOf(',') + 1, value.length);
  }

  static bool topIsMe(List<MessageModel> messages, MessageModel value) {
    if (value.isMine) {
      return false;
    } else {
      int index = messages.lastIndexOf(value);
      if (index == 0 && !value.isMine) {
        return true;
      }
      if (messages.length > 1) {
        if (messages[index - 1].isMine) {
          return true;
        }
      }
    }
    return false;
  }

  //上傳Token
  static void getAndPutToken() async {
    String? token = await FirebaseMessage.getToken();
    if (token != null) {
      Map<String, dynamic> dto = {'fcmToken': token};
      await Api.putToken(dto);
    }
  }

  static void clearAndPutToken() async {
    Map<String, dynamic> dto = {'fcmToken': ''};
    await Api.putToken(dto);
  }

  static Future<File> cropImage(XFile file, Size size) async {
    final slika = img.decodeJpg(await file.readAsBytes())!;
    var cropSize = math.min(slika.width, slika.height) - 360;
    int offsetX = (slika.width - cropSize) ~/ 2.5;
    int offsetY = (slika.height - cropSize) ~/ 8;
    final picture = img.copyCrop(img.Image.from(slika),
        x: offsetX, y: offsetY, width: cropSize, height: cropSize);
    return await File(file.path).writeAsBytes(img.encodePng(picture));
  }

  //分享
  static void sharePost(int id, String content) {
    Share.share('點我開啟貼文：$shareBaseUrl$id', subject: '內文：$content ');
  }

  //日期
  static String loveContentDate(int timestamp) {
    return dateLoveContentDate
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp * 1000));
  }

  static String adoptReportDate(String dateTime) {
    return dateLoveContentDate.format(DateTime.parse(dateTime));
  }

  static Future<BitmapDescriptor> buildMarkerIcon(
      String imagePath,
      String token,
      Size size,
      Color color,
      bool isMultiple,
      int? number) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    final Radius radius = Radius.circular(size.width / 2);

    final Paint tagPaint = Paint()..color = Colors.blue;
    const double tagWidth = 40.0;

    final Paint shadowPaint = Paint()
      ..color = color; /*Colors.blue.withAlpha(100);*/
    const double shadowWidth = 10.0;

    final Paint borderPaint = Paint()..color = color;
    const double borderWidth = 3.0;

    //數量
    final Paint numberPaint = Paint()
      ..color = color
      ..strokeCap = StrokeCap.round;

    const double imageOffset = shadowWidth + borderWidth;

    // Add shadow circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0.0, 0.0, size.width, size.height),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        shadowPaint);

    // Add border circle
    canvas.drawRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(shadowWidth, shadowWidth,
              size.width - (shadowWidth * 2), size.height - (shadowWidth * 2)),
          topLeft: radius,
          topRight: radius,
          bottomLeft: radius,
          bottomRight: radius,
        ),
        borderPaint);

    // Add tag circle
    /*canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
            size.width - tagWidth,
            0.0,
            tagWidth,
            tagWidth
        ),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      tagPaint);*/

    //add Number text
    if (isMultiple) {
      canvas.drawRect(const Rect.fromLTRB(0, 0, 70, 70), numberPaint);
    }

    // Add tag text
    if (isMultiple) {
      final ui.ParagraphBuilder paragraphBuilder = ui.ParagraphBuilder(
        ui.ParagraphStyle(textDirection: ui.TextDirection.ltr),
      )
        ..pushStyle(ui.TextStyle(color: Colors.black, fontSize: 20))
        ..addText('$number');
      final ui.Paragraph paragraph = paragraphBuilder.build()
        ..layout(const ui.ParagraphConstraints(width: 35));
      canvas.drawParagraph(paragraph, const Offset(5, 10));
    }

    // Oval for the image
    Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
        size.width - (imageOffset * 2), size.height - (imageOffset * 2));

    // Add path for oval image
    canvas.clipPath(Path()..addOval(oval));

    // Add image
    ui.Image image = await getImageFromPath(
        imagePath, token); // Alternatively use your own method to get the image
    paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.cover);

    // Convert canvas to image
    final ui.Image markerAsImage = await pictureRecorder
        .endRecording()
        .toImage(size.width.toInt(), size.height.toInt());

    // Convert image to bytes
    final ByteData? byteData =
        await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List uint8List = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(uint8List);
  }

  static Future<ui.Image> getImageFromPath(
      String imagePath, String token) async {
    http.Response response = await http.get(Uri.parse(getFilePath(imagePath)),
        headers: {"authorization": "Bearer $token"});
    Uint8List originalUnit8List = response.bodyBytes;

    final Completer<ui.Image> completer = Completer();

    ui.decodeImageFromList(originalUnit8List, (ui.Image result) {
      return completer.complete(result);
    });

    return completer.future;
  }

  static Future<File> getVideoFile(String netUrl, String token) async {
    final directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/$netUrl');
    if (!file.existsSync()) {
      file.create(recursive: true);
      http.Response response = await http.get(Uri.parse(getFilePath(netUrl)),
          headers: {"authorization": "Bearer $token"});
      Uint8List uint8list = response.bodyBytes;
      file.writeAsBytesSync(uint8list);
      return file;
    }
    return file;
  }

  static Future<Uint8List> getNetFile(String netUrl) async {
    http.Response response = await http.get(
      Uri.parse(getFilePath(netUrl)),
    );
    Uint8List uint8list = response.bodyBytes;
    return uint8list;
  }

  static Future<File> getLocationVideoFile(String netUrl) async {
    final directory = await getApplicationDocumentsDirectory();
    File file = File('${directory.path}/$netUrl');
    return file;
  }

  static Future<FileInfo> getBackgroundPicCacheManager(String url) async {
    FileInfo? fileInfo =
        await DefaultCacheManager().getFileFromCache(getPublicPath(url));
    fileInfo ??= await DefaultCacheManager().downloadFile(getPublicPath(url));
    return fileInfo;
  }

  static Future<FileInfo> getFileCacheManager(String url) async {
    FileInfo? fileInfo =
        await DefaultCacheManager().getFileFromCache(getFilePath(url));
    log('是否需要重取：${fileInfo == null} $url');
    fileInfo ??= await DefaultCacheManager().downloadFile(getFilePath(url));
    log('結果：${fileInfo.originalUrl} $url');
    return fileInfo;
  }
}
