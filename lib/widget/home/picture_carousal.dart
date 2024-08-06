import 'dart:convert';
import 'dart:developer';

import 'package:ashera_pet_new/routes/route_name.dart';
import 'package:ashera_pet_new/view_model/video_vm.dart';
import 'package:ashera_pet_new/widget/home/post_img.dart';
import 'package:ashera_pet_new/widget/home/post_video.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../model/hero_view_params.dart';
import '../../model/post.dart';
import '../../routes/app_router.dart';
import '../../utils/api.dart';
import '../../utils/app_color.dart';
import '../../utils/utils.dart';
import '../../view_model/post.dart';
import '../image_carousel/carousel.dart';

///圖片 愛心 留言 分享 喜歡這則貼文的人
class PictureCarousal extends StatefulWidget {
  final bool inView;
  final PostModel postCardData;
  final CachedVideoPlayerPlusController? controller;
  final String routerName;

  const PictureCarousal(
      {super.key,
      required this.postCardData,
      required this.inView,
      required this.routerName,
      this.controller});

  @override
  State<StatefulWidget> createState() => _PictureCarousalState();
}

class _PictureCarousalState extends State<PictureCarousal>
    with AutomaticKeepAliveClientMixin {
  CachedVideoPlayerPlusController? get _controller => widget.controller;
  String get routeName => widget.routerName;
  VideoVm? _videoVm;
  PostVm? _postVm;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
    log('貼文 ${widget.postCardData.body} inView：${widget.inView}');
  }

  _onLayoutDone(_) {
    _videoVm!.addListener(_listener);
  }

  _listener() {
    if (widget.inView && AppRouter.config.location == routeName) {
      _controller?.play();
    }
  }

  @override
  void dispose() {
    _videoVm!.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _videoVm = Provider.of<VideoVm>(context, listen: false);
    _postVm = Provider.of<PostVm>(context, listen: false);
    super.build(context);
    List<String> imageUrl =
        List<String>.from(json.decode(widget.postCardData.pics));
    double aspectRatio = 1;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 500),
          child: AspectRatio(
            aspectRatio: aspectRatio,
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
              child: _dataWidget(imageUrl),
            ),
          ),
        ),
      ),
    );
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
            _controller?.pause();
            log('目前時間：${_controller?.value.position.inMilliseconds.round()}');
            int? duration = await context.push(RouteName.netWorkVideoHeroView,
                extra: HeroViewParamsModel(
                    tag: 'video-${widget.postCardData.id}',
                    data: url,
                    index: 0,
                    duration:
                        _controller!.value.position.inMilliseconds.round()));
            await Future.delayed(const Duration(milliseconds: 300));
            _postVm!.jumpToPixels();
            if (duration != null) {
              log('設定時間：$duration');
              await _controller?.seekTo(Duration(milliseconds: duration));
            }
            _controller?.play();
          },
          child: Consumer<VideoVm>(
            builder: (context, vm, _) {
              return PostVideoWidget(
                  key: ValueKey('post-${widget.postCardData.id}'),
                  videoController: _controller,
                  play: widget.inView && AppRouter.config.location == routeName,
                  controller: false,
                  volume: vm.volume,
                  isShare: false,
                  bottom: 5);
            },
          ),
        );
      } else if (Utils.imageFileVerification(url)) {
        //image
        return GestureDetector(
          onTap: () async {
            await context.push(RouteName.netWorkImageHeroView,
                extra: HeroViewParamsModel(
                    tag: 'img_${widget.postCardData.id}', data: url, index: 0));
            await Future.delayed(const Duration(milliseconds: 300));
            _postVm!.jumpToPixels();
          },
          child: PostImg(id: widget.postCardData.id, imgUrl: url),
        );

        return CachedNetworkImage(
          imageUrl: Utils.getFilePath(url),
          httpHeaders: {"authorization": "Bearer ${Api.accessToken}"},
          imageBuilder: (context, img) {
            //要點了有放大效果
            return GestureDetector(
              onTap: () async {
                await context.push(RouteName.netWorkImageHeroView,
                    extra: HeroViewParamsModel(
                        tag: 'img_${widget.postCardData.id}',
                        data: url,
                        index: 0));
                await Future.delayed(const Duration(milliseconds: 300));
                _postVm!.jumpToPixels();
              },
              child: Hero(
                tag: 'img_${widget.postCardData.id}',
                child: Image(
                  fit: BoxFit.cover,
                  image: img,
                ),
              ),
            );
          },
          errorWidget: (context, url, error) {
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
                      '這張相片\n發生了一些問題！',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColor.textFieldTitle),
                    ),
                  )
                ],
              ),
            );
          },
          progressIndicatorBuilder: (context, _, __) {
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: const CircularProgressIndicator(
                color: AppColor.textFieldHintText,
              ),
            );
          },
          fadeInDuration: const Duration(milliseconds: 0),
          fadeOutDuration: const Duration(milliseconds: 0),
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

  @override
  bool get wantKeepAlive => true;
}
