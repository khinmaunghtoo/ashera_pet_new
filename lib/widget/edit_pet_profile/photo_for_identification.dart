import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ashera_pet_new/view_model/member_pet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/pet.dart';
import '../../routes/route_name.dart';
import '../../utils/api.dart';
import '../../utils/app_color.dart';
import '../../utils/app_image.dart';
import '../../utils/utils.dart';
import '../button.dart';
// import 'package:image_pickers/image_pickers.dart';

class PhotoForIdentification extends StatefulWidget {
  final int? index;
  const PhotoForIdentification({super.key, required this.index});

  @override
  State<StatefulWidget> createState() => _PhotoForIdentificationState();
}

class _PhotoForIdentificationState extends State<PhotoForIdentification> {
  File? newPhoto;
  MemberPetVm? _memberPetVm;
  int? get index => widget.index;

  @override
  Widget build(BuildContext context) {
    _memberPetVm = Provider.of<MemberPetVm>(context, listen: false);
    return Column(
      children: [
        //照片區
        Expanded(
            child: Stack(
          alignment: Alignment.center,
          fit: StackFit.expand,
          children: [
            //頭像
            _avatar(),
            //addButton
            Positioned(
                right: 25,
                bottom: 0,
                child: blueAddButton(23, () => _onTap(), AppColor.toBeAdopted)),
          ],
        )),
        const SizedBox(
          height: 10,
        ),
        const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '上傳更多照片',
            style: TextStyle(color: AppColor.textFieldTitle, fontSize: 15),
          ),
        )
      ],
    );
  }

  Widget _avatar() {
    if (newPhoto != null) {
      return _fileAvatar();
    } else if (Pet.petModel.isNotEmpty) {
      if (Pet.petModel[index ?? 0].pics.isNotEmpty) {
        return _catchAvatar();
      } else {
        return _noAvatar();
      }
    } else {
      return _noAvatar();
    }
  }

  Widget _fileAvatar() {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.textFieldHintText, width: 3)),
      child: CircleAvatar(
        radius: 55,
        backgroundImage: FileImage(newPhoto!),
      ),
    );
  }

  Widget _catchAvatar() {
    return Consumer<MemberPetVm>(
      builder: (context, vm, _) {
        List<String> pics =
            List<String>.from(json.decode(Pet.petModel[vm.petTarget].pics));
        if (pics.isNotEmpty) {
          return Container(
              width: 120,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: AppColor.textFieldHintText, width: 3)),
              child: CachedNetworkImage(
                imageUrl: Utils.getFilePath(pics.first),
                httpHeaders: {"authorization": "Bearer ${Api.accessToken}"},
                imageBuilder: (context, img) {
                  return CircleAvatar(
                    radius: 55,
                    backgroundImage: img,
                  );
                },
                errorWidget: (context, url, e) {
                  log(e.toString());
                  return _noAvatar();
                },
              ));
        } else {
          return _noAvatar();
        }
      },
    );
  }

  Widget _noAvatar() {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColor.textFieldHintText, width: 3)),
      child: const CircleAvatar(
        radius: 55,
        backgroundColor: AppColor.textFieldTitle,
        child: Image(
          width: 48,
          fit: BoxFit.cover,
          image: AssetImage(AppImage.logoGray),
        ),
      ),
    );
  }

  void _onTap() {
    /*showModalBottomSheet(
        context: context,
        builder: (context){
          return _chooseImage();
        });*/
    context.push(RouteName.petMorePic);
  }

  Widget _chooseImage() {
    return Container(
      height: 200,
      decoration: const BoxDecoration(color: AppColor.appBackground),
      child: Column(
        children: [
          //相片選擇
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Text(
              '相片選擇',
              style: TextStyle(color: AppColor.textFieldTitle, fontSize: 16),
            ),
          ),
          //拍照
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
            // child: blueRectangleButton('拍照', () => _takePhoto()),
          ),
          //相簿
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
            // child: blueRectangleButton('相簿', () => _selectImage()),
          )
        ],
      ),
    );
  }

  // void _takePhoto() async {
  //   Navigator.of(context).pop();
  //   Media? media = await ImagePickers.openCamera(
  //       cameraMimeType: CameraMimeType.photo,
  //       cropConfig: CropConfig(enableCrop: true, width: 2, height: 2));
  //   if(media != null){
  //     newPhoto = File(media.path!);
  //     _memberPetVm!.setFacePic(media.path!, index);
  //     setState(() {});
  //   }
  // }

  // void _selectImage() async {
  //   Navigator.of(context).pop();
  //   List<Media>? media = await ImagePickers.pickerPaths(
  //       galleryMode: GalleryMode.image,
  //       showCamera: false,
  //       showGif: false,
  //       selectCount: 1,
  //       cropConfig: CropConfig(enableCrop: true, height: 2, width: 2),
  //       compressSize: 500,
  //       uiConfig: UIConfig(uiThemeColor: AppColor.appBackground));
  //   if(media.isNotEmpty){
  //     newPhoto = File(media.first.path!);
  //     _memberPetVm!.setFacePic(media.first.path!, index);
  //     setState(() {});
  //   }
  // }
}
