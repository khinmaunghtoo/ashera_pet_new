import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:ashera_pet_new/data/auth.dart';
import 'package:ashera_pet_new/widget/home/profile_slab.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../model/post.dart';
import '../../model/tuple.dart';
import '../../routes/route_name.dart';
import '../../utils/api.dart';
import '../../utils/app_color.dart';
import '../../utils/utils.dart';

class SharePost extends StatefulWidget {
  final PostModel postCardData;

  const SharePost({super.key, required this.postCardData});

  @override
  State<StatefulWidget> createState() => _SharePostState();
}

class _SharePostState extends State<SharePost> {
  PostModel get postCardData => widget.postCardData;
  late Future<PostModel?> postData;
  String fileName = '';

  @override
  void initState() {
    super.initState();
    postData = getPost(postCardData.sharePostId);
    initVideoController();
  }

  void initVideoController() async {
    if (postCardData.sharePostId == 0) {
      return;
    }
    Tuple<bool, String> r =
        await Api.getPostByIdNotIso(postCardData.sharePostId);
    if (r.i1!) {
      if (r.i2! != '""') {
        PostModel model = PostModel.fromJson(r.i2!);
        List<String> imageUrl = List<String>.from(json.decode(model.pics));
        if (imageUrl.isNotEmpty) {
          if (imageUrl.length <= 1) {
            if (Utils.videoFileVerification(imageUrl.first)) {
              //縮略圖
              fileName = await VideoThumbnail.thumbnailFile(
                      video: Utils.getFilePath(imageUrl.first),
                      headers: {"authorization": "Bearer ${Api.accessToken}"},
                      thumbnailPath: (await getTemporaryDirectory()).path,
                      imageFormat: ImageFormat.JPEG,
                      quality: 75) ??
                  '';
            }
          }
        }
      }
    }
  }

  //取得貼文
  Future<PostModel?> getPost(int postId) async {
    if (postId == 0) {
      return null;
    }
    String token = Auth.userLoginResDTO.body.token;
    Tuple<bool, String> r = await Isolate.run(() => getPostById(postId, token));
    if (r.i1!) {
      return PostModel.fromJson(r.i2!);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postData,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            if (snapshot.data == null) {
              return Container();
            }
            return GestureDetector(
              onTap: () => context.push(RouteName.singlePost,
                  extra: '${postCardData.sharePostId}'),
              child: Container(
                height: 100,
                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                    color: AppColor.textFieldTitle,
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ProfileSlab(
                          userData: snapshot.data!,
                          textColor: AppColor.appBackground,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Flexible(
                            child: Container(
                          padding: const EdgeInsets.only(left: 15),
                          child: Text(
                            snapshot.data!.body,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: AppColor.textFieldHintText,
                                fontSize: 15),
                          ),
                        ))
                      ],
                    )),
                    Container(
                      padding: const EdgeInsets.only(right: 10),
                      child: _pictureCarousel(snapshot.data!.pics),
                    ),
                  ],
                ),
              ),
            );
          default:
            return Container();
        }
      },
    );
  }

  Widget _pictureCarousel(String pics) {
    List<String> imageUrl = List<String>.from(json.decode(pics));
    double aspectRatio = 1;
    return Center(
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
    );
  }

  //判斷是影片還是圖片Widget
  Widget _dataWidget(List<String> urlList) {
    if (urlList.isEmpty) {
      return Container();
    }
    //單張 不要用空值判斷
    String url = urlList.first;
    if (Utils.videoFileVerification(url)) {
      //video
      if (fileName.isEmpty) {
        return Container();
      }
      return Container(
        alignment: Alignment.center,
        child: AspectRatio(
          aspectRatio: 1.1,
          child: Image(
            fit: BoxFit.cover,
            image: FileImage(File(fileName)),
          ),
        ),
      );
    } else if (Utils.imageFileVerification(url)) {
      //image
      return CachedNetworkImage(
        imageUrl: Utils.getFilePath(url),
        httpHeaders: {"authorization": "Bearer ${Api.accessToken}"},
        imageBuilder: (context, img) {
          return Image(
            fit: BoxFit.cover,
            image: img,
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
      );
    } else {
      return Container();
    }
  }
}
