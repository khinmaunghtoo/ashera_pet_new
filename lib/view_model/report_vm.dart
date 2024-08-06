import 'dart:io';
import 'dart:typed_data';

import 'package:ashera_pet_new/utils/api.dart';
import 'package:flutter/cupertino.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../enum/photo_type.dart';
import '../model/post_card_media.dart';
import '../model/tuple.dart';

class ReportVm with ChangeNotifier {
  final List<PostCardMediaModel> _mediaList = [];
  List<PostCardMediaModel> get mediaList => _mediaList;

  //相片新增
  void setMediaList(List<AssetEntity> result) async {
    List<AssetEntity> r = List.from(result);

    await Future.forEach(r, (element) async {
      File? file = await element.file;
      Uint8List? thumbnailData = await element.thumbnailData;
      _mediaList.add(PostCardMediaModel(
          title: element.title,
          typeInt: element.typeInt,
          height: element.height,
          width: element.width,
          duration: element.duration,
          file: file,
          thumbnailData: thumbnailData));
    });
    notifyListeners();
  }

  //刪除相片
  void deleteMediaList() {
    _mediaList.clear();
    notifyListeners();
  }

  //清除
  void clearMediaList() {
    _mediaList.clear();
  }

  //檔案上傳
  Future<Tuple<bool, String>> uploadFile(
      String account, String path, PhotoType type) async {
    return await Api.uploadFile(account, path, type);
  }
}
