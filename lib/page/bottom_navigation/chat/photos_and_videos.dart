import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/widget/system_back.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_model/photos_and_videos.dart';
import '../../../widget/photos_and_videos/body.dart';
import '../../../widget/photos_and_videos/title.dart';

class PhotosAndVideosPage extends StatefulWidget {
  const PhotosAndVideosPage({super.key});

  @override
  State<StatefulWidget> createState() => _PhotosAndVideosPageState();
}

class _PhotosAndVideosPageState extends State<PhotosAndVideosPage> {
  PhotosAndVideosVm? _photosAndVideosVm;
  _onLayoutDone(_) {}

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
  }

  @override
  void dispose() {
    _photosAndVideosVm!.disposePhotosAndVideosData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _photosAndVideosVm = Provider.of<PhotosAndVideosVm>(context);
    return SystemBack(
        child: Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.appBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: const Column(
              children: [
                PhotosAndVideosTitle(),
                Expanded(child: PhotosAndVideosBody())
              ],
            ),
          );
        },
      ),
    ));
  }
}
