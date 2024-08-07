import 'dart:async';

import 'package:ashera_pet_new/view_model/kanban.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../enum/filter_animal_type.dart';
import '../../utils/app_color.dart';
import '../../utils/app_image.dart';
import '../button.dart';

class MapBody extends StatefulWidget {
  const MapBody({super.key});

  @override
  State<StatefulWidget> createState() => _MapBodyState();
}

class _MapBodyState extends State<MapBody> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.loose,
      children: [
        Consumer<KanBanVm>(
          builder: (context, vm, _) {
            return GoogleMap(
              markers: vm.marker,
              mapType: MapType.normal,
              zoomControlsEnabled: false,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              mapToolbarEnabled: false,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                vm.initClusterManager(controller.mapId);
              },
              onCameraMove: (position) {
                // if (vm.manager != null) {
                //   //log('onCameraMove: $position');
                //   vm.manager!.onCameraMove(position);
                // }
              },
              onCameraIdle: () {
                // if (vm.manager != null) {
                //   //log('onCameraIdle');
                //   vm.manager!.updateMap();
                // }
              },
              initialCameraPosition: CameraPosition(
                  target: LatLng(
                      vm.selfLatLng['latitude'], vm.selfLatLng['longitude']),
                  zoom: 16),
            );
          },
        ),
        //左
        Positioned(bottom: 40, left: 10, child: _leftButton()),
      ],
    );
  }

  //篩選
  Widget _leftButton() {
    return CircleButton(
        iconData: AppImage.iconFilter, callback: () => _showFilter());
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
                            //Expanded(child: _status(FilterHealthStatus.healthy)),
                            Expanded(child: Container()),
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
