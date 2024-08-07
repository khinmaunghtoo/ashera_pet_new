import 'package:ashera_pet_new/enum/gender.dart';
import 'package:ashera_pet_new/enum/health_status.dart';
import 'package:ashera_pet_new/model/member_pet.dart';
import 'package:ashera_pet_new/utils/app_image.dart';
import 'package:ashera_pet_new/utils/utils.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../routes/route_name.dart';
import '../../utils/api.dart';
import '../../utils/app_color.dart';
import '../../utils/geolocator_service.dart';
import '../../view_model/kanban.dart';

class SearchPetItem extends StatefulWidget {
  final MemberPetModel pet;
  final bool isShowCollection;
  const SearchPetItem(
      {super.key, required this.pet, required this.isShowCollection});

  @override
  State<StatefulWidget> createState() => _SearchPetItemState();
}

class _SearchPetItemState extends State<SearchPetItem>
    with AutomaticKeepAliveClientMixin {
  MemberPetModel get pet => widget.pet;
  bool get isShowCollection => widget.isShowCollection;
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => context.push(RouteName.petMagazineContent, extra: pet),
      child: Stack(
        fit: StackFit.loose,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(8),
                color: AppColor.textFieldUnSelect),
            child: Column(
              children: [
                //圖片
                Expanded(
                    child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: _image(),
                )),
                //資料
                _data()
              ],
            ),
          ),
          Consumer<KanBanVm>(builder: (context, vm, _) {
            return Positioned(
                top: 5,
                left: 20,
                child: Visibility(
                  visible: vm.isCollection(pet.id) && isShowCollection,
                  child: const Icon(
                    BootstrapIcons.bookmark_fill,
                    color: AppColor.button,
                    size: 20,
                  ),
                ));
          })
        ],
      ),
    );
  }

  Widget _image() {
    if (pet.mugshot.isNotEmpty) {
      return CachedNetworkImage(
        fit: BoxFit.cover,
        imageUrl: Utils.getFilePath(pet.mugshot),
        httpHeaders: {"authorization": "Bearer ${Api.accessToken}"},
        fadeOutDuration: const Duration(milliseconds: 0),
        fadeInDuration: const Duration(milliseconds: 0),
        errorWidget: (context, url, error) => Container(
          alignment: Alignment.center,
          decoration: const BoxDecoration(color: AppColor.itemBackgroundColor),
          child: const Image(
            width: 50,
            image: AssetImage(AppImage.logoWhite),
          ),
        ),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(color: AppColor.itemBackgroundColor),
        child: const Image(
          width: 50,
          image: AssetImage(AppImage.logoWhite),
        ),
      );
    }
  }

  Widget _data() {
    //name gender animalType
    //age petStatus
    //m like

    //animalType name
    //gender age petStatus
    //m like
    return SizedBox(
      height: 100,
      child: Column(
        children: [
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //animalType
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.transparent),
                  child: const Image(
                    image: AssetImage(AppImage
                        .iconCollarUnBound) /*AssetImage(pet.animalType == AnimalType.cat.index ? AppImage.iconCatFill : AppImage.iconDogFill)*/,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                //name
                Flexible(
                    child: Text(
                  pet.nickname,
                  style: const TextStyle(
                      color: AppColor.textFieldTitle,
                      fontSize: 16,
                      height: 1.1),
                )),
              ],
            ),
          )),
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //gender
                Icon(
                  GenderEnum.values[pet.gender].icon,
                  size: 13,
                  color: GenderEnum.values[pet.gender].color,
                ),
                Container(
                  width: 8,
                ),
                //age
                Text(
                  '${pet.age} Age',
                  style: const TextStyle(
                      color: AppColor.textFieldTitle,
                      fontSize: 14,
                      height: 1.1),
                ),
                const Spacer(),
                //petStatus
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: HealthStatus.values[pet.healthStatus].color,
                      border: Border.all(
                          color: HealthStatus.values[pet.healthStatus].color,
                          width: 1)),
                  child: Text(
                    HealthStatus.values[pet.healthStatus].zh,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                )
              ],
            ),
          )),
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //m
                Expanded(
                    child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Icon(
                      Icons.near_me,
                      color: AppColor.nearMeColor,
                      size: 15,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(child: Consumer<KanBanVm>(
                      builder: (context, vm, _) {
                        return FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            _getMText(vm.selfLatLng),
                            maxLines: 1,
                            style: const TextStyle(
                                color: AppColor.textFieldTitle,
                                fontSize: 14,
                                height: 1.1),
                          ),
                        );
                      },
                    ))
                  ],
                )),
                //like
                Expanded(
                    child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const Spacer(),
                    Consumer<KanBanVm>(
                      builder: (context, vm, _) {
                        return GestureDetector(
                          onTap: () => vm.onTapHeart(pet),
                          child: Icon(
                            vm.isLike(pet.id)
                                ? BootstrapIcons.heart_fill
                                : BootstrapIcons.heart,
                            color: Colors.redAccent,
                            size: 15,
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Consumer<KanBanVm>(
                      builder: (context, vm, _) {
                        return Text(
                          '${vm.count(pet.id)}',
                          style: const TextStyle(
                              color: AppColor.textFieldTitle,
                              fontSize: 14,
                              height: 1.1),
                        );
                      },
                    ),
                  ],
                ))
              ],
            ),
          )),
        ],
      ),
    );
  }

  String _getMText(Map<String, dynamic> location) {
    if (pet.healthStatus == HealthStatus.healthy.index) {
      return '--------';
    } else {
      if (pet.longitude != 0.0 && pet.latitude != 0.0) {
        double startLat = location['latitude'];
        double startLng = location['longitude'];
        double endLat = double.parse('${pet.latitude}');
        double endLng = double.parse('${pet.longitude}');
        // double m = getDistanceBetween(startLat, startLng, endLat, endLng);
        return '${(100 / 1000).toStringAsFixed(1)}km';
      }
      return '${0}km';
    }
  }

  @override
  bool get wantKeepAlive => true;
}
