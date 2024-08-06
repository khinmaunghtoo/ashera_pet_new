import 'dart:developer';
import 'dart:io';

import 'package:ashera_pet_new/utils/utils.dart';
import 'package:ashera_pet_new/widget/back_button.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:dismissible_page/dismissible_page.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'package:video_thumbnail/video_thumbnail.dart';
import '../../../utils/api.dart';
import '../../../utils/app_color.dart';

class ChatVideoWidget extends StatefulWidget {
  final int id;
  final String url;
  const ChatVideoWidget({super.key, required this.id, required this.url});

  @override
  State<StatefulWidget> createState() => _ChatVideoWidgetState();
}

class _ChatVideoWidgetState extends State<ChatVideoWidget> {
  int get id => widget.id;
  String get url => widget.url;

  bool initialized = false;
  bool hasError = false;

  late Future<String?> _video;

  @override
  void initState() {
    super.initState();
    log('URL: $url');
    _video = _getFileImage();
  }

  //儲存影片暫存圖
  Future<String?> _getFileImage() async {
    Map<String, dynamic> r = await _isExistsImage();
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
  Future<Map<String, dynamic>> _isExistsImage() async {
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _video,
        builder: (context, AsyncSnapshot<String?> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return _loading();
            case ConnectionState.waiting:
              return _loading();
            case ConnectionState.active:
              return _loading();
            case ConnectionState.done:
              return Container(
                width: 200,
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () => videoOnTap('video_$id'),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Hero(
                        tag: 'video_$id',
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
                                color: Colors.white, shape: BoxShape.circle),
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
        });
  }

  void videoOnTap(String tag) {
    showGeneralDialog(
        context: context,
        pageBuilder: (context, animation, secondaryAnimation) =>
            FullScreenPlayer(tag: tag, url: url),
        transitionDuration: const Duration(milliseconds: 1000),
        transitionBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
            child: child,
          );
        });
  }

  Widget _loading() {
    return const SizedBox(
      width: 200,
      height: 200,
      child: Padding(
        padding: EdgeInsets.all(40),
        child: CircularProgressIndicator(
          color: AppColor.textFieldUnSelect,
        ),
      ),
    );
  }
}

class FullScreenPlayer extends StatefulWidget {
  const FullScreenPlayer({super.key, required this.tag, required this.url});
  final String url;
  final String tag;
  @override
  State<StatefulWidget> createState() => _FullScreenPlayerState();
}

class _FullScreenPlayerState extends State<FullScreenPlayer> {
  String get url => widget.url;
  late CachedVideoPlayerPlusController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _playInit();
  }

  void _playInit() async {
    _controller = CachedVideoPlayerPlusController.networkUrl(
        Uri.parse(Utils.getFilePath(url)),
        httpHeaders: {"authorization": "Bearer ${Api.accessToken}"});
    _initializeVideoPlayerFuture = _controller.initialize().then((value) {
      setState(() {});
      _controller.play();
      _controller.setLooping(false);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DismissiblePage(
        child: SafeArea(
          bottom: false,
          child: Stack(
            fit: StackFit.loose,
            children: [
              FutureBuilder(
                  future: _initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(color: Colors.black),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _controller.value.isPlaying
                                  ? _controller.pause()
                                  : _controller.play();
                            });
                          },
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: Hero(
                              tag: widget.tag,
                              child: CachedVideoPlayerPlus(_controller),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                            color: AppColor.textFieldHintText),
                      );
                    }
                  }),
              Center(
                child: _controller.value.isPlaying
                    ? const SizedBox()
                    : const Icon(
                        Icons.play_arrow_rounded,
                        size: 50,
                        color: AppColor.textFieldTitle,
                      ),
              ),
              Positioned(
                left: 10,
                top: 10,
                child: TopBackButton(
                  alignment: Alignment.centerLeft,
                  callback: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
        onDismissed: () => Navigator.pop(context));
  }
}
