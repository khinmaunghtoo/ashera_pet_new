import 'dart:developer';
import 'dart:io';

import 'package:ashera_pet_new/model/list_photo_viewer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../enum/message_type.dart';
import '../../model/message.dart';
import '../../routes/route_name.dart';
import '../../utils/api.dart';
import '../../utils/app_color.dart';
import '../../utils/utils.dart';

class PhotosAndVideosItem extends StatefulWidget {
  final String date;
  final List<MessageModel> messages;
  const PhotosAndVideosItem(
      {super.key, required this.date, required this.messages});

  @override
  State<StatefulWidget> createState() => _PhotosAndVideosItemState();
}

class _PhotosAndVideosItemState extends State<PhotosAndVideosItem> {
  String get date => widget.date;
  List<MessageModel> get messages => widget.messages;

  @override
  void initState() {
    super.initState();
    for (var element in messages) {
      log('內容：${element.toMap()}');
    }
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
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        const SizedBox(
          height: 10,
        ),
        Flexible(
            fit: FlexFit.loose,
            child: Wrap(
              spacing: 4,
              runSpacing: 4,
              alignment: WrapAlignment.start,
              children: messages.map((e) => _image(e)).toList(),
            ))
      ],
    );
  }

  Widget _image(MessageModel value) {
    switch (value.type) {
      case MessageType.VIDEO:
        return SizedBox(
          width: 90,
          height: 90,
          child: FutureBuilder(
              future: _getFileImage(value.content),
              builder: (context, AsyncSnapshot<String?> snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return Container();
                  case ConnectionState.waiting:
                    return Container();
                  case ConnectionState.active:
                    return Container();
                  case ConnectionState.done:
                    return Container(
                      width: 200,
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          context.push(RouteName.listPhotoViewer,
                              extra: ListPhotoViewerModel(
                                  id: value.id, messages: messages));
                        },
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Hero(
                              tag: 'video_${value.id}',
                              child: Image(
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                                gaplessPlayback: true,
                                image: FileImage(File(snapshot.data!)),
                              ),
                            ),
                            Center(
                              child: Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle),
                                  child: const Icon(
                                    Icons.play_arrow_rounded,
                                    size: 40,
                                    color: Colors.black,
                                  )),
                            )
                          ],
                        ),
                      ),
                    );
                }
              }),
        );
      case MessageType.PIC:
        return SizedBox(
          width: 90,
          height: 90,
          child: CachedNetworkImage(
            imageUrl: Utils.getFilePath(value.content),
            httpHeaders: {"authorization": "Bearer ${Api.accessToken}"},
            fadeInDuration: const Duration(milliseconds: 0),
            fadeOutDuration: const Duration(milliseconds: 0),
            placeholderFadeInDuration: const Duration(milliseconds: 0),
            imageBuilder: (context, img) {
              return GestureDetector(
                onTap: () {
                  context.push(RouteName.listPhotoViewer,
                      extra: ListPhotoViewerModel(
                          id: value.id, messages: messages));
                },
                child: Hero(
                  tag: 'img_${value.id}',
                  child: Image(
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                    image: img,
                  ),
                ),
              );
            },
            placeholder: (context, url) => const SizedBox(
              height: 200,
              width: 200,
            ),
            errorWidget: (context, url, error) {
              return Container(
                width: 160,
                alignment: Alignment.center,
                child: const Column(
                  children: [
                    Icon(
                      Icons.priority_high,
                      size: 40,
                      color: AppColor.required,
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '這張相片\n發生了一些問題！',
                        textAlign: TextAlign.center,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        );
      default:
        return Container();
    }
  }
}
