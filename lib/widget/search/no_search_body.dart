import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ashera_pet_new/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../model/post.dart';
import '../../model/post_background_model.dart';
import '../../routes/route_name.dart';
import '../../utils/api.dart';
import '../no_search/post_pic.dart';
import '../no_search/post_text.dart';

class NoSearchBody extends StatefulWidget {
  final PostModel postData;
  final FocusNode focusNode;
  const NoSearchBody(
      {super.key, required this.postData, required this.focusNode});

  @override
  State<StatefulWidget> createState() => _NoSearchBodyState();
}

class _NoSearchBodyState extends State<NoSearchBody>
    with AutomaticKeepAliveClientMixin {
  PostModel get postData => widget.postData;

  String image = '';

  String get body => widget.postData.body;

  bool isMultiple = false;

  bool isImg = true;
  bool isText = false;
  String? _existsImage;

  @override
  void initState() {
    super.initState();
    List<String> images = List<String>.from(json.decode(postData.pics));
    if (images.isNotEmpty) {
      image = /*Utils.getFilePath(*/ images.first /*)*/;
      isMultiple = images.length > 1;
    }
    if (image.isEmpty) {
      isText = true;
      isImg = false;
    } else if (Utils.imageFileVerification(image)) {
      isText = false;
      isImg = true;
    } else if (Utils.videoFileVerification(image)) {
      isText = false;
      isImg = false;
      _getImage();
    }
  }

  void _getImage() async {
    _existsImage = await _getFileImage();
    if (mounted) setState(() {});
  }

  //儲存影片暫存圖
  Future<String?> _getFileImage() async {
    String keepFileName =
        Utils.getFilePath(image).split('/').last.toString().split('.').first;
    String path = '${(await getTemporaryDirectory()).path}/$keepFileName.jpg';
    if (await File(path).exists()) {
      return path;
    } else {
      return await VideoThumbnail.thumbnailFile(
            headers: {"authorization": "Bearer ${Api.accessToken}"},
            video: Utils.getFilePath(image),
            thumbnailPath: (await getTemporaryDirectory()).path,
            imageFormat: ImageFormat.JPEG,
            maxHeight: 350,
            quality: 75,
          ) ??
          '';
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (isText && !isImg) {
      return GestureDetector(
        onTap: () => _onPicTap(),
        child: NoSearchPostText(
          imgUrl: Utils.postBackgroundLists
              .firstWhere(
                  (element) => element.id == widget.postData.postBackgroundId,
                  orElse: () => const PostBackgroundModel(
                      id: 1, pic: "/background/bg_1.jpg", status: 1))
              .pic,
          text: body,
        ),
      );
    } else if (isImg && !isText) {
      return GestureDetector(
        onTap: () => _onPicTap(),
        child: PostPic(id: postData.id, imgUrl: image, isMultiple: isMultiple),
      );
    }
    if (_existsImage != null) {
      return Container(
        width: 200,
        alignment: Alignment.center,
        child: GestureDetector(
          onTap: () => _onPicTap(),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Image(
                fit: BoxFit.cover,
                gaplessPlayback: true,
                image: FileImage(File(_existsImage!)),
              ),
              const Icon(
                Icons.play_arrow_rounded,
                size: 40,
              )
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  void _onPicTap() {
    log('貼文：${postData.body}');
    widget.focusNode.nextFocus();
    widget.focusNode.unfocus();
    context.push(RouteName.comments, extra: postData);
  }

  @override
  bool get wantKeepAlive => true;
}
