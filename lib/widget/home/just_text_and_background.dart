import 'package:ashera_pet_new/model/post_background_model.dart';
import 'package:ashera_pet_new/view_model/post.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';

import '../just_text_and_background_img.dart';

class JustTextAndBackground extends StatefulWidget {
  final int backgroundId;
  final String text;
  final ScreenshotController? screenshotController;

  const JustTextAndBackground(
      {super.key,
      required this.backgroundId,
      required this.text,
      this.screenshotController});

  @override
  State<StatefulWidget> createState() => _JustTextAndBackgroundState();
}

class _JustTextAndBackgroundState extends State<JustTextAndBackground> {
  int get backgroundId => widget.backgroundId;
  String get text => widget.text;
  ScreenshotController? get screenshotController => widget.screenshotController;

  @override
  Widget build(BuildContext context) {
    if (screenshotController != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 500),
            child: Screenshot(
                controller: screenshotController!,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Consumer<PostVm>(
                    builder: (context, vm, _) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5)),
                            child: JustTextAndBackgroundImg(
                              imgUrl: vm.postBackgroundLists
                                  .firstWhere(
                                      (element) => element.id == backgroundId,
                                      orElse: () => const PostBackgroundModel(
                                          id: 1,
                                          pic: "/background/bg_1.jpg",
                                          status: 1))
                                  .pic,
                            ),
                          ),
                          Text(
                            text,
                            maxLines: 13,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 18),
                          ),
                        ],
                      );
                    },
                  ),
                )),
          ),
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 500),
          child: AspectRatio(
            aspectRatio: 1,
            child: Consumer<PostVm>(
              builder: (context, vm, _) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(5)),
                      child: JustTextAndBackgroundImg(
                        imgUrl: vm.postBackgroundLists
                            .firstWhere((element) => element.id == backgroundId,
                                orElse: () => const PostBackgroundModel(
                                    id: 1,
                                    pic: "/background/bg_1.jpg",
                                    status: 1))
                            .pic,
                      ),
                    ),
                    Text(
                      text,
                      maxLines: 13,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
