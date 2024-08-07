import 'dart:convert';
import 'dart:developer';

import 'package:ashera_pet_new/routes/app_router.dart';
import 'package:ashera_pet_new/view_model/video_vm.dart';
import 'package:ashera_pet_new/widget/home/post_video.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../model/hero_view_params.dart';
import '../../model/post.dart';
import '../../routes/route_name.dart';
import '../../utils/api.dart';
import '../../utils/utils.dart';
import '../home/post_img.dart';
import '../image_carousel/carousel.dart';

class CommentsPictureCarousal extends StatefulWidget {
  final bool inView;
  final PostModel postCardData;
  const CommentsPictureCarousal(
      {super.key, required this.inView, required this.postCardData});

  @override
  State<StatefulWidget> createState() => _CommentsPictureCarousalState();
}

class _CommentsPictureCarousalState extends State<CommentsPictureCarousal> {
  CachedVideoPlayerPlusController? _controller;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
    List<String> imageUrl =
        List<String>.from(json.decode(widget.postCardData.pics));
    if (imageUrl.isNotEmpty) {
      if (imageUrl.length <= 1) {
        if (Utils.videoFileVerification(imageUrl.first)) {
          _controller = CachedVideoPlayerPlusController.networkUrl(
            Uri.parse(
              Utils.getFilePath(imageUrl.first),
            ),
            httpHeaders: {"authorization": "Bearer ${Api.accessToken}"},
          );
          _controller?.play();
        }
      }
    }
  }

  _onLayoutDone(_) async {
    _controller?.addListener(_listener);
  }

  _listener() async {
    if (_controller != null) {
      if (!_controller!.value.isPlaying) {
        //await _controller?.play();
      }
    }
  }

  @override
  void dispose() {
    _controller?.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [..._pictureCarousel()],
    );
  }

  List<Widget> _pictureCarousel() {
    List<String> imageUrl =
        List<String>.from(json.decode(widget.postCardData.pics));
    double aspectRatio = 1;
    return [
      //圖片!! 這部分要修改了 單張 多張 GIF 影片
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 500),
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: Container(
                clipBehavior: Clip.hardEdge,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                child: _dataWidget(imageUrl),
              ),
            ),
          ),
        ),
      ),
    ];
  }

  //判斷是影片還是圖片Widget
  Widget _dataWidget(List<String> urlList) {
    //單張 不要用空值判斷
    if (urlList.length <= 1) {
      log('單張: ${urlList.first}');
      String url = urlList.first;
      if (Utils.videoFileVerification(url)) {
        //video
        //點了要能放大影片
        return GestureDetector(
          onTap: () async {
            _controller!.pause();
            log('目前時間：${_controller?.value.position.inMilliseconds.round()}');
            int? duration = await context.push(RouteName.netWorkVideoHeroView,
                extra: HeroViewParamsModel(
                    tag: 'video-${widget.postCardData.id}',
                    data: url,
                    index: 0,
                    duration:
                        _controller!.value.position.inMilliseconds.round()));

            if (duration != null) {
              log('設定時間：$duration');
              await _controller!.seekTo(Duration(milliseconds: duration));
            }
            _controller!.play();
          },
          child: Consumer<VideoVm>(
            builder: (context, vm, _) {
              return PostVideoWidget(
                key: ValueKey('post-${widget.postCardData.id}'),
                videoController: _controller!,
                play: widget.inView &&
                    AppRouter.currentLocation == RouteName.comments,
                controller: false,
                volume: vm.volume,
                isShare: false,
                bottom: 5,
              );
            },
          ),
        );
      } else if (Utils.imageFileVerification(url)) {
        //image
        return GestureDetector(
          onTap: () {
            context.push(RouteName.netWorkImageHeroView,
                extra: HeroViewParamsModel(
                    tag: 'img_${widget.postCardData.id}', data: url, index: 0));
          },
          child: PostImg(
            id: widget.postCardData.id,
            imgUrl: url,
          ),
        );
      } else {
        return Container();
      }
    } else {
      //多張
      return Carousel(
        tag: 'post-${widget.postCardData.id}',
        imagePaths: urlList,
        inView: widget.inView,
      );
    }
  }
}
