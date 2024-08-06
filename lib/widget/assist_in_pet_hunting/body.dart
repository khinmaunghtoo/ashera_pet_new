import 'dart:async';

import 'package:ashera_pet_new/enum/filter_animal_type.dart';
import 'package:ashera_pet_new/routes/route_name.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../model/member_pet.dart';
import '../../utils/app_color.dart';
import '../../utils/app_image.dart';
import '../../view_model/kanban.dart';
import '../button.dart';
import '../water_ripple/water_ripple_page.dart';
import 'item.dart';

class PetRadarBody extends StatefulWidget {
  const PetRadarBody({super.key});

  @override
  State<StatefulWidget> createState() => _PetRadarBodyState();
}

class _PetRadarBodyState extends State<PetRadarBody> {
  KanBanVm? _kanBanVm;
  Timer? _petRefreshTime;

  _onLayoutDone(_) {
    //每五分鐘 取一次所有寵物
    _petRefreshTime ??= Timer.periodic(
        const Duration(minutes: 5), (timer) => _kanBanVm!.getAllPet());
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
  }

  @override
  void dispose() {
    super.dispose();
    if (_petRefreshTime != null) {
      _petRefreshTime!.cancel();
      _petRefreshTime = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    _kanBanVm = Provider.of<KanBanVm>(context);
    return Stack(
      fit: StackFit.loose,
      children: [
        //中間
        _kanban(),
        //左條件篩選按鈕
        Positioned(bottom: 40, left: 10, child: _leftFilterButton()),
        //右地圖按鈕
        Positioned(bottom: 40, right: 10, child: _rightMapButton()),
        //searchi動畫
        Consumer<KanBanVm>(
          builder: (context, vm, _) {
            return Visibility(
                visible: vm.isShowAnimation, child: const WaterRipplePage());
          },
        )
      ],
    );
  }

  //重複列表看板
  Widget _kanban() {
    return Selector<KanBanVm, List<MemberPetModel>>(
      builder: (context, value, child) {
        if (value.isNotEmpty) {
          return Container(
            padding: const EdgeInsets.only(bottom: 5),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 0),
              itemBuilder: (context, index) =>
                  SearchPetItem(pet: value[index], isShowCollection: true),
              itemCount: value.length,
              addAutomaticKeepAlives: true,
            ),
          );
        } else {
          return Container(
            alignment: Alignment.center,
            child: const Text(
              '無篩選寵物',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          );
        }
      },
      selector: (_, data) => data.filterPets,
      shouldRebuild: (m1, m2) {
        return m1.length != m2.length;
      },
    );
  }

  //篩選
  Widget _leftFilterButton() {
    return CircleButton(
        iconData: AppImage.iconFilter, callback: () => _showFilter());
  }

  Widget _rightMapButton() {
    return CircleButton(
        iconData: AppImage.iconMap,
        callback: () => context.push(RouteName.petMap));
  }

  void _showFilter() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              height: 280,
              child: Column(
                children: [
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(flex: 1, child: Container()),
                        const Text(
                          '搜尋條件',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Expanded(child: Container()),
                                Container(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: GestureDetector(
                                    onTap: () => Navigator.of(context).pop(),
                                    child: const Icon(
                                      Icons.clear,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                  //線
                  Container(
                    height: 1,
                    color: Colors.white,
                  ),
                  //寵物類型
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            '寵物類型',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        //按鈕
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _animalType(FilterAnimalType.all),
                            _animalType(FilterAnimalType.cat),
                            _animalType(FilterAnimalType.dog),
                          ],
                        ),
                      ],
                    ),
                  ),
                  //線
                  Container(
                    height: 1,
                    color: AppColor.dialogLineColor,
                  ),
                  //狀態
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            '狀態',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(child: _status(FilterHealthStatus.all)),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(child: _status(FilterHealthStatus.lost)),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                                child: _status(FilterHealthStatus.toBeAdopted)),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                                child: _status(FilterHealthStatus.healthy)),
                            //Expanded(child: Container())
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  //animalType
  Widget _animalType(FilterAnimalType type) {
    return Consumer<KanBanVm>(
      builder: (context, vm, _) {
        return vm.type == type
            ? _selectedButton(vm.type.zh)
            : GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => vm.setFilterAnimalType(type),
                child: _unSelectedButton(type.zh),
              );
      },
    );
  }

  //status
  Widget _status(FilterHealthStatus status) {
    return Consumer<KanBanVm>(
      builder: (context, vm, _) {
        return vm.status == status
            ? _selectedButton(vm.status.zh)
            : GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => vm.setFilterHealthStatue(status),
                child: _unSelectedButton(status.zh),
              );
      },
    );
  }

  //選中
  Widget _selectedButton(String text) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: AppColor.button),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
    );
  }

  //未選中
  Widget _unSelectedButton(String text) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColor.buttonTextColor, width: 1)),
      child: Text(
        text,
        style: const TextStyle(color: AppColor.buttonTextColor, fontSize: 16),
      ),
    );
  }
}
