import 'dart:developer';
import 'dart:isolate';

import 'package:ashera_pet_new/data/auth.dart';
import 'package:ashera_pet_new/data/pet.dart';
import 'package:ashera_pet_new/enum/photo_type.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:go_router/go_router.dart';
// import 'package:image_pickers/image_pickers.dart';
import 'package:provider/provider.dart';

import '../../data/member.dart';
import '../../model/hero_view_params.dart';
import '../../model/member_pet.dart';
import '../../model/tuple.dart';
import '../../routes/route_name.dart';
import '../../utils/api.dart';
import '../../utils/app_color.dart';
import '../../utils/utils.dart';
import '../../view_model/member_pet.dart';

class PetMorePicBody extends StatefulWidget {
  const PetMorePicBody({super.key});

  @override
  State<StatefulWidget> createState() => _PetMorePicBodyState();
}

class _PetMorePicBodyState extends State<PetMorePicBody> {
  MemberPetVm? _petVm;

  @override
  Widget build(BuildContext context) {
    _petVm = Provider.of<MemberPetVm>(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //新增
        _addImageWidget(),
        //列表
        Expanded(child: _bodyWidget())
      ],
    );
  }

  Widget _addImageWidget() {
    return GestureDetector(
      onTap: () => (),
      child: Container(
        height: 80,
        width: 80,
        margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        alignment: Alignment.center,
        decoration:
            BoxDecoration(border: Border.all(color: Colors.white, width: 1)),
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.white,
        ),
      ),
    );
  }

  // void _selectImage() async {
  //   List<Media>? media = await ImagePickers.pickerPaths(
  //       galleryMode: GalleryMode.image,
  //       showCamera: false,
  //       showGif: false,
  //       selectCount: 4,
  //       compressSize: 500,
  //       uiConfig: UIConfig(uiThemeColor: AppColor.appBackground));
  //   if (media.isNotEmpty) {
  //     String name = Member.memberModel.name;
  //     MemberPetModel pet = Pet.petModel[_petVm!.petTarget];
  //     log('Pet: ${pet.toMap()}');
  //     String token = Auth.userLoginResDTO.body.token;
  //     List<String> pics = [];
  //     SVProgressHUD.show();
  //     //上傳相片
  //     await Future.forEach(media, (element) async {
  //       String path = element.path!;
  //       Tuple<bool, String> r;
  //       if (path.contains('.heic') || path.contains('.heif')) {
  //         log('NO ISOLATE');
  //         r = await Api.uploadFile(name, path, PhotoType.more, pet);
  //       } else {
  //         r = await Isolate.run(() => uploadFileIso(name, path, pet, token));
  //       }

  //       if (r.i1!) {
  //         pics.add(r.i2!);
  //       }
  //     });
  //     _petVm!.setMorePic(pics, _petVm!.petTarget);
  //     await Future.delayed(const Duration(milliseconds: 300));
  //     _petVm!.updatePet();

  //     SVProgressHUD.dismiss();
  //   }
  // }

  Widget _bodyWidget() {
    return Consumer<MemberPetVm>(
      builder: (context, vm, _) {
        return Selector<MemberPetVm, List<String>>(
          builder: (context, value, _) {
            if (value.isNotEmpty) {
              return GridView.builder(
                padding: EdgeInsets.zero,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    crossAxisSpacing: 0),
                itemBuilder: (context, index) =>
                    _item(value[index], index, value),
                itemCount: value.length,
              );
            } else {
              return Container();
            }
          },
          selector: (_, data) => data.pics(vm.petTarget),
          shouldRebuild: (m1, m2) {
            return m1.length != m2.length;
          },
        );
      },
    );
  }

  Widget _item(String path, int index, List<String> pics) {
    return Stack(
      children: [
        //image
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(15),
          child: CachedNetworkImage(
            imageUrl: Utils.getFilePath(path),
            httpHeaders: {"authorization": "Bearer ${Api.accessToken}"},
            imageBuilder: (context, image) {
              return GestureDetector(
                onTap: () => onTap(pics, index),
                child: Hero(
                  tag: 'img$index',
                  child: Image(
                    height: 180,
                    image: image,
                    fit: BoxFit.cover,
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
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: const CircularProgressIndicator(
                  color: AppColor.textFieldHintText,
                ),
              );
            },
            fadeInDuration: const Duration(milliseconds: 0),
            fadeOutDuration: const Duration(milliseconds: 0),
          ),
        ),
        //X
        Positioned(
            right: 0,
            top: 0,
            child: Consumer<MemberPetVm>(
              builder: (context, vm, _) {
                return GestureDetector(
                  onTap: () => vm.deletePic(path, _petVm!.petTarget),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 25,
                      color: Colors.red,
                    ),
                  ),
                );
              },
            ))
      ],
    );
  }

  void onTap(List<String> path, int index) {
    HeroViewParamsModel data =
        HeroViewParamsModel(tag: 'img$index', data: path, index: index);
    context.push(RouteName.photoAndVideoView, extra: data);
  }
}
