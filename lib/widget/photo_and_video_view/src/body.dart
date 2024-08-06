import 'package:ashera_pet_new/view_model/video_vm.dart';
import 'package:ashera_pet_new/widget/photo_and_video_view/src/pic.dart';
import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/api.dart';
import '../../../utils/app_color.dart';
import '../../../utils/utils.dart';
import '../../image_carousel/indicator.dart';
import '../../video_widget.dart';

class PhotoAndVideoViewBody extends StatefulWidget {
  final List<String> dataPath;
  final int index;
  const PhotoAndVideoViewBody(
      {super.key, required this.dataPath, required this.index});

  @override
  State<StatefulWidget> createState() => _PhotoAndVideoViewBodyState();
}

class _PhotoAndVideoViewBodyState extends State<PhotoAndVideoViewBody> {
  List<String> get dataPath => widget.dataPath;
  int get index => widget.index;

  late PageController pageController;
  int currentIndex = 0;

  late CachedVideoPlayerPlusController _controller;

  _onLayoutDone(_) {
    //pageController.jumpToPage(currentIndex);
  }

  @override
  void initState() {
    super.initState();
    currentIndex = index;
    pageController = PageController(initialPage: currentIndex);
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
  }

  @override
  Widget build(BuildContext context) {
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
        dotCount: dataPath.length,
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
      itemCount: dataPath.length,
      itemBuilder: (context, index) {
        if (Utils.imageFileVerification(dataPath[index])) {
          return PhotoAndVideoViewPic(imgUrl: dataPath[index]);
        } else if (Utils.videoFileVerification(dataPath[index])) {
          return Consumer<VideoVm>(
            builder: (context, vm, _) {
              _controller = CachedVideoPlayerPlusController.networkUrl(
                Uri.parse(
                  Utils.getFilePath(dataPath[index]),
                ),
                httpHeaders: {"authorization": "Bearer ${Api.accessToken}"},
              );
              return VideoWidget(
                videoController: _controller,
                play: true,
                controller: true,
                volume: vm.volume,
                isShare: true,
                bottom: 5,
              );
            },
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
}
