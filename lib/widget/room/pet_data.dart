import 'dart:developer';

import 'package:ashera_pet_new/model/member_pet.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../enum/animal.dart';
import '../../enum/gender.dart';
import '../../enum/health_status.dart';
import '../../model/member.dart';
import '../../routes/route_name.dart';
import '../../utils/app_color.dart';
import '../../utils/app_image.dart';
import '../../utils/geolocator_service.dart';
import '../../view_model/kanban.dart';
import '../../view_model/message_controller.dart';
import '../time_line/app_widget/avatars.dart';

class ChatRoomPetData extends StatefulWidget {
  final int currentIndex;
  const ChatRoomPetData({super.key, required this.currentIndex});

  @override
  State<StatefulWidget> createState() => _ChatRoomPetDataState();
}

class _ChatRoomPetDataState extends State<ChatRoomPetData> {
  PageController pageController = PageController();
  int currentIndex = 0;

  _onLayoutDone(_) {
    pageController.jumpToPage(currentIndex);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
    currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MessageControllerVm>(
      builder: (context, vm, _) {
        log('length: ${vm.petLists.length}');
        log('currentIndex: $currentIndex');
        return Offstage(
          offstage: !vm.isShowPetData,
          child: Container(
            height: 120,
            decoration: const BoxDecoration(
                color: AppColor.textFieldUnSelect,
                border: Border(
                    top:
                        BorderSide(color: AppColor.dialogLineColor, width: 1))),
            alignment: Alignment.center,
            child: Row(
              children: [
                Visibility(
                    visible: currentIndex != 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (currentIndex > 0) {
                          currentIndex--;
                          log('減少');
                          pageController.animateToPage(currentIndex,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease);
                          setState(() {});
                        }
                      },
                      child: const SizedBox(
                        width: 35,
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 35,
                          color: AppColor.arrowColor,
                        ),
                      ),
                    )),
                Expanded(
                    child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: vm.petLists.length,
                  itemBuilder: (context, index) {
                    log('寵物：${vm.petLists[index].toMap()}');
                    return ChatRoomPetDataItem(pet: vm.petLists[index]);
                  },
                  controller: pageController,
                )),
                Visibility(
                    visible: currentIndex != vm.petLists.length - 1,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (currentIndex < vm.petLists.length) {
                          currentIndex++;
                          log('增加');
                          pageController.animateToPage(currentIndex,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease);
                          setState(() {});
                        }
                      },
                      child: const SizedBox(
                        width: 35,
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 35,
                          color: AppColor.arrowColor,
                        ),
                      ),
                    ))
              ],
            ),
          ),
        );
      },
    );
  }
}

class ChatRoomPetDataItem extends StatelessWidget {
  final MemberPetModel pet;
  const ChatRoomPetDataItem({super.key, required this.pet});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          //頭像
          _image(context),
          Expanded(
              child: Column(
            children: [
              Expanded(
                  child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        //animalType
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: AppColor.button),
                          child: Image(
                            width: 30,
                            image: AssetImage(
                                pet.animalType == AnimalType.cat.index
                                    ? AppImage.iconCatFill
                                    : AppImage.iconDogFill),
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
                    )),
                    //petStatus
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                          color: HealthStatus.values[pet.healthStatus].color,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color:
                                  HealthStatus.values[pet.healthStatus].color,
                              width: 1)),
                      child: Text(
                        HealthStatus.values[pet.healthStatus].zh,
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
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
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                      '${pet.age} 歲',
                      style: const TextStyle(
                          color: AppColor.textFieldTitle,
                          fontSize: 14,
                          height: 1.1),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    //m
                    Flexible(
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
                        Consumer<KanBanVm>(
                          builder: (context, vm, _) {
                            return Text(
                              _getMText(vm.selfLatLng),
                              style: const TextStyle(
                                  color: AppColor.textFieldTitle,
                                  fontSize: 14,
                                  height: 1.1),
                            );
                          },
                        )
                      ],
                    )),
                    //like
                    Flexible(
                        child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
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
          ))
        ],
      ),
    );
  }

  Widget _image(BuildContext context) {
    return Avatar.big(
        user: MemberModel.fromMap(pet.toMap()),
        callback: () => context.push(RouteName.petMagazineContent, extra: pet));
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
        double m = 10;
        if (m <= 1000) {
          return '${m.toStringAsFixed(1)}m';
        } else {
          return '${(m / 1000).toStringAsFixed(1)}km';
        }
      }
      return '${0}m';
    }
  }
}
