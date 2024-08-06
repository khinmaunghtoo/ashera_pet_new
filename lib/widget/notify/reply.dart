import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:isolate';

import 'package:ashera_pet_new/data/auth.dart';
import 'package:ashera_pet_new/model/notify.dart';
import 'package:ashera_pet_new/routes/route_name.dart';
import 'package:ashera_pet_new/view_model/post.dart';
import 'package:ashera_pet_new/widget/notify/reply_pic.dart';
import 'package:ashera_pet_new/widget/notify/reply_text_post_background.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../model/post.dart';
import '../../model/tuple.dart';
import '../../utils/api.dart';
import '../../utils/app_color.dart';
import '../../utils/utils.dart';
import '../time_line/app_widget/avatars.dart';

class NotifyCardReply extends StatefulWidget {
  final NotifyModel model;
  const NotifyCardReply({super.key, required this.model});

  @override
  State<StatefulWidget> createState() => _NotifyCardReplyState();
}

class _NotifyCardReplyState extends State<NotifyCardReply> {
  NotifyModel get model => widget.model;

  late Future<Tuple<bool, String>> _img;

  //取得貼文並回傳一張相片Url
  Future<Tuple<bool, String>> getPostImage(int postId) async {
    String token = Auth.userLoginResDTO.body.token;
    Tuple<bool, String> r = await Isolate.run(() => getPostById(postId, token));
    //Tuple<bool, String> r = await Api.getPostById(postId);
    if (r.i1!) {
      if (r.i2 == '""') {
        //已刪除貼文
        Tuple<bool, String> r = Tuple<bool, String>(true, '');
        return r;
      } else {
        PostModel data = PostModel.fromJson(r.i2!);
        List<String> imageUrl = List<String>.from(json.decode(data.pics));
        if (imageUrl.isEmpty) {
          log('只有文字：${model.toJson()}');
          Tuple<bool, String> r = Tuple<bool, String>(
              true,
              json.encode({
                'body': data.body,
                'postBackgroundId': data.postBackgroundId
              }));
          return r;
        }
        //判斷是圖片或影片
        if (Utils.imageFileVerification(imageUrl.first)) {
          log('回傳圖片：${model.message} ${data.pics} ${data.id}');
          Tuple<bool, String> r = Tuple<bool, String>(true, imageUrl.first);
          return r;
        } else {
          String? u = await _getFileImage(imageUrl.first);
          log('回傳縮圖：${model.message} ${data.pics} ${data.id}');
          Tuple<bool, String> r = Tuple<bool, String>(false, u!);
          return r;
        }
      }
    }
    return Tuple<bool, String>(true, '');
  }

  //儲存影片暫存圖
  Future<String?> _getFileImage(String url) async {
    Map<String, dynamic> r = await _isExistsImage(url);
    if (r['status']) {
      return r['path'];
    }
    return await VideoThumbnail.thumbnailFile(
          headers: {"authorization": "Bearer ${Api.accessToken}"},
          video: Utils.getFilePath(url),
          thumbnailPath: (await getTemporaryDirectory()).path,
          imageFormat: ImageFormat.JPEG,
          maxHeight: 350,
          quality: 100,
        ) ??
        '';
  }

  //判斷是否有此影片暫存檔
  Future<Map<String, dynamic>> _isExistsImage(String url) async {
    String keepFileName =
        Utils.getFilePath(url).split('/').last.toString().split('.').first;
    //log('保留檔案名稱: $_keepFileName');
    String path = '${(await getTemporaryDirectory()).path}/$keepFileName.jpg';
    //log('暫存檔案名稱: $_path');
    if (await File(path).exists()) {
      ///文件在
      //log('有暫存圖');
      return {'status': true, 'path': path};
    } else {
      ///文件不在
      //log('沒有暫存圖');
      return {'status': false, 'path': ''};
    }
  }

  @override
  void initState() {
    super.initState();
    _img = getPostImage(int.tryParse(model.data) ?? 0);

    log('通知：${model.toMap()}');
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: [
          //大頭照
          Avatar.medium(
            user: model.fromMember,
            callback: () {
              context.push(RouteName.searchPet, extra: model.fromMember);
            },
          ),
          //內容
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(left: 10),
            child: Text.rich(TextSpan(children: [
              TextSpan(
                  text: model.message,
                  style: const TextStyle(
                      color: AppColor.textFieldTitle, fontSize: 14)),
              TextSpan(
                  text: '  ${Utils.getPostTime(model.createdAt)}',
                  style: const TextStyle(
                      color: AppColor.textFieldHintText, fontSize: 14))
            ])),
          )),
          //圖
          FutureBuilder(
              future: _img,
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.done:
                    if (snapshot.data != null) {
                      if (snapshot.data!.i1!) {
                        if (snapshot.data!.i2!.isNotEmpty) {
                          if (Utils.imageFileVerification(snapshot.data!.i2!)) {
                            return GestureDetector(
                              onTap: () => context.push(RouteName.singlePost,
                                  extra: model.data),
                              child: ReplyPic(
                                imgUrl: snapshot.data!.i2!,
                              ),
                            );
                          } else {
                            //純文字
                            return GestureDetector(
                              onTap: () => context.push(RouteName.singlePost,
                                  extra: model.data),
                              child: Consumer<PostVm>(
                                builder: (context, vm, _) {
                                  Map<String, dynamic> map =
                                      json.decode(snapshot.data!.i2!);
                                  return ReplyTextPostBackground(
                                    imgUrl: vm.postBackgroundLists
                                        .firstWhere(
                                            (element) =>
                                                element.id ==
                                                map['postBackgroundId'],
                                            orElse: () =>
                                                vm.postBackgroundLists.first)
                                        .pic,
                                    text: map['body'],
                                  );
                                },
                              ),
                            );
                          }
                        } else {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.priority_high,
                                  size: 40,
                                  color: AppColor.required,
                                ),
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Text(
                                    '貼文已被作者刪除！',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: AppColor.textFieldTitle),
                                  ),
                                )
                              ],
                            ),
                          );
                        }
                      } else {
                        return GestureDetector(
                          onTap: () => context.push(RouteName.singlePost,
                              extra: model.data),
                          child: Image(
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            image: FileImage(File(snapshot.data!.i2!)),
                          ),
                        );
                      }
                    } else {
                      return Container();
                    }
                  default:
                    return _loadingWidget();
                }
              })
        ],
      ),
    );
  }

  Widget _loadingWidget() {
    return Container(
      width: 50,
      height: 50,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: const CircularProgressIndicator(
        color: AppColor.textFieldHintText,
      ),
    );
  }
}
