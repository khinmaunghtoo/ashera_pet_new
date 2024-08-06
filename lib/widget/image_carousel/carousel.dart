import 'package:ashera_pet_new/view_model/post.dart';
import 'package:ashera_pet_new/view_model/video_vm.dart';
import 'package:ashera_pet_new/widget/image_carousel/indicator.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../model/hero_view_params.dart';
import '../../routes/route_name.dart';
import '../../utils/api.dart';
import '../../utils/app_color.dart';
import '../../utils/utils.dart';
import '../home/carousel_pic.dart';
import '../home/post_video.dart';

class Carousel extends StatefulWidget {
  final List<String> imagePaths;
  final bool inView;
  final String tag;

  const Carousel(
      {super.key,
      required this.imagePaths,
      required this.inView,
      required this.tag});

  @override
  State<StatefulWidget> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  PageController pageController = PageController();
  bool get inView => widget.inView;
  String get tag => widget.tag;
  PostVm? _postVm;

  int currentIndex = 0;

  CachedVideoPlayerPlusController? _controller;

  @override
  Widget build(BuildContext context) {
    _postVm = Provider.of<PostVm>(context, listen: false);
    return Stack(
      children: [
        Container(
          child: _getPageView(),
        ),
        Positioned(left: 0, bottom: 0, right: 0, child: _getIndicator())
      ],
    );
  }

  Widget _getIndicator() {
    return Indicator(
        currentIndex: currentIndex,
        dotCount: widget.imagePaths.length,
        dotColor: AppColor.button,
        dotSelectedColor: AppColor.textFieldHintText,
        dotSize: 6,
        dotPadding: 3,
        onItemTap: (index) {
          pageController.animateToPage(index,
              duration: const Duration(milliseconds: 200), curve: Curves.ease);
        });
  }

  PageView _getPageView() {
    return PageView.builder(
      itemCount: widget.imagePaths.length,
      itemBuilder: (context, index) {
        if (Utils.imageFileVerification(widget.imagePaths[index])) {
          return GestureDetector(
              onTap: onTap,
              child: CarouselPic(tag: tag, imgUrl: widget.imagePaths[index]));
        } else if (Utils.videoFileVerification(widget.imagePaths[index])) {
          return GestureDetector(
            onTap: () => onTap(),
            child: Consumer<VideoVm>(
              builder: (context, vm, _) {
                _controller = CachedVideoPlayerPlusController.networkUrl(
                  Uri.parse(
                    Utils.getFilePath(widget.imagePaths[index]),
                  ),
                  httpHeaders: {"authorization": "Bearer ${Api.accessToken}"},
                );
                return PostVideoWidget(
                  videoController: _controller!,
                  play: inView,
                  controller: false,
                  volume: vm.volume,
                  isShare: false,
                  bottom: 5,
                );
              },
            ),
          );
        } else {
          return Container();
        }
      },
      onPageChanged: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      controller: pageController,
    );
  }

  void onTap() async {
    _controller?.pause();
    HeroViewParamsModel data = HeroViewParamsModel(
        tag: tag,
        data: widget.imagePaths,
        index: currentIndex,
        duration: _controller != null
            ? _controller!.value.position.inMilliseconds.round()
            : 0);
    int? duration =
        await context.push(RouteName.photoAndVideoView, extra: data);
    await Future.delayed(const Duration(milliseconds: 300));
    _postVm!.jumpToPixels();
    if (duration != null) {
      _controller?.seekTo(Duration(milliseconds: duration));
    }
    _controller?.play();
  }
}
