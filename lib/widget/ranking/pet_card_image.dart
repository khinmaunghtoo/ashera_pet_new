import 'dart:convert';

import 'package:flutter/material.dart';

import '../../model/member_pet.dart';
import '../../utils/app_color.dart';
import '../../utils/app_image.dart';
import '../pet_magazine_content/pic_view.dart';

class RankPetCardImage extends StatelessWidget{
  final MemberPetModel pet;
  const RankPetCardImage({super.key, required this.pet});
  @override
  Widget build(BuildContext context) {
    List<String> pics = List<String>.from(json.decode(pet.pics));
    if(pics.isNotEmpty){
      return ContentPicView(
          imagePaths: pics,
          tag: 'images${pet.id}');
    }else{
      return Container(
        height: 250,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: AppColor.itemBackgroundColor,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(color: Colors.grey, width: 1)
        ),
        child: const Center(
          child: Image(
            width: 45,
            image: AssetImage(
                AppImage.logoWhite
            ),
          ),
        ) ,
      );
    }
  }

}
