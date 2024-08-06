import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../model/hero_view_params.dart';
import '../../../routes/route_name.dart';
import '../../../utils/api.dart';
import '../../../utils/app_color.dart';
import '../../../utils/utils.dart';

class ChatPicWidget extends StatelessWidget{
  final int id;
  final String pic;
  const ChatPicWidget({super.key, required this.id, required this.pic});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: Utils.getFilePath(pic),
      httpHeaders: {"authorization": "Bearer ${Api.accessToken}"},
      fadeInDuration: const Duration(milliseconds: 0),
      fadeOutDuration: const Duration(milliseconds: 0),
      placeholderFadeInDuration: const Duration(milliseconds: 0),
      imageBuilder: (context, img){
        return GestureDetector(
          onTap: () {
            context.push(RouteName.netWorkImageHeroView,
                extra: HeroViewParamsModel(
                    tag: 'img_$id',
                    data: pic,
                    index: 0
                ));
          },
          child: Hero(
            tag: 'img_$id',
            child: Image(
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              image: img,
            ),
          ),
        );
      },
      placeholder: (context, url) => const SizedBox(
        height: 200,
        width: 200,
      ),
      errorWidget: (context, url, error){
        return Container(
          width: 160,
          alignment: Alignment.center,
          child: const Column(
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
                ),
              )
            ],
          ),
        );
      },
    );
  }
}