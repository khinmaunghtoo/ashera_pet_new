import 'dart:convert';

import 'package:ashera_pet_new/view_model/video_vm.dart';
import 'package:ashera_pet_new/widget/system_back.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../enum/message_type.dart';
import '../../model/message.dart';
import '../../utils/api.dart';
import '../../utils/app_color.dart';
import '../../utils/utils.dart';
import '../../view_model/photos_and_videos.dart';
import '../back_button.dart';
import '../video_widget.dart';

class ListPhotoViewer extends StatefulWidget {
  final int id;
  const ListPhotoViewer({
    super.key,
    required this.id,
  });

  @override
  State<StatefulWidget> createState() => _ListPhotoViewerState();
}

class _ListPhotoViewerState extends State<ListPhotoViewer> {
  int get id => widget.id;
  PhotosAndVideosVm? _photosAndVideosVm;

  PageController? _pageController;

  late CachedVideoPlayerPlusController _controller;

  _onLayoutDone(_) {
    _pageController = PageController(
        initialPage: _photosAndVideosVm!.allPhotoAndVideo
            .indexWhere((element) => element.id == id));
    _pageController!.addListener(_listener);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
  }

  void _listener() {
    _pageController!.page;
  }

  @override
  void dispose() {
    _pageController!.removeListener(_listener);
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _photosAndVideosVm = Provider.of<PhotosAndVideosVm>(context);
    return SystemBack(
        child: Scaffold(
      backgroundColor: AppColor.appBackground,
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //
                _title(context),
                Expanded(child: Consumer<PhotosAndVideosVm>(
                  builder: (context, vm, _) {
                    if (_pageController == null) {
                      return Container();
                    }
                    return PageView.builder(
                      controller: _pageController,
                      itemBuilder: (context, index) =>
                          _hero(vm.allPhotoAndVideo[index]),
                      itemCount: vm.allPhotoAndVideo.length,
                    );
                  },
                ))
              ],
            ),
          );
        },
      ),
    ));
  }

  Widget _hero(MessageModel data) {
    switch (data.type) {
      case MessageType.VIDEO:
        List<String> imageUrl = List<String>.from(json.decode(data.content));
        if (imageUrl.length <= 1) {
          if (Utils.videoFileVerification(imageUrl.first)) {
            _controller = CachedVideoPlayerPlusController.networkUrl(
              Uri.parse(
                Utils.getFilePath(imageUrl.first),
              ),
              httpHeaders: {"authorization": "Bearer ${Api.accessToken}"},
            );
          }
        }
        return Hero(
          tag: 'video_${data.id}',
          child: Consumer<VideoVm>(
            builder: (context, vm, _) {
              return VideoWidget(
                videoController: _controller,
                play: false,
                controller: true,
                volume: vm.volume,
                isShare: true,
                bottom: 5,
              );
            },
          ),
        );
      case MessageType.PIC:
        return Hero(
          tag: 'img_${data.id}',
          child: Image(
            image: CachedNetworkImageProvider(
              Utils.getFilePath(data.content),
              headers: {"authorization": "Bearer ${Api.accessToken}"},
            ),
          ),
        );
      default:
        return Container();
    }
  }

  Widget _title(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: Utils.appBarHeight,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: AppColor.textFieldUnSelect),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: TopCloseBackButton(
            alignment: Alignment.centerLeft,
            callback: () {
              if (context.canPop()) {
                context.pop();
              }
            },
          )),
          Expanded(child: Container())
        ],
      ),
    );
  }
}
