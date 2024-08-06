import 'package:ashera_pet_new/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../model/hero_view_params.dart';
import '../../routes/route_name.dart';
import '../../utils/api.dart';
import '../../utils/app_color.dart';
import '../image_carousel/indicator.dart';

class ContentPicView extends StatefulWidget {
  final List<String> imagePaths;
  final String tag;

  const ContentPicView(
      {super.key, required this.imagePaths, required this.tag});

  @override
  State<StatefulWidget> createState() => _ContentPicViewState();
}

class _ContentPicViewState extends State<ContentPicView> {
  PageController pageController = PageController();
  List<String> get imagePaths => widget.imagePaths;
  String get tag => widget.tag;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 250,
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
      itemCount: imagePaths.length,
      itemBuilder: (context, index) {
        return CachedNetworkImage(
          imageUrl: Utils.getFilePath(imagePaths[index]),
          httpHeaders: {"authorization": "Bearer ${Api.accessToken}"},
          imageBuilder: (context, image) {
            return GestureDetector(
              onTap: onTap,
              child: Hero(
                tag: tag,
                child: Container(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      image: image,
                      fit: BoxFit.contain,
                    ),
                  ),
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
      },
      onPageChanged: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      controller: pageController,
    );
  }

  void onTap() {
    HeroViewParamsModel data = HeroViewParamsModel(
        tag: tag, data: widget.imagePaths, index: currentIndex);
    context.push(RouteName.photoAndVideoView, extra: data);
  }
}
