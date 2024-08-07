import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/data/pet.dart';
import 'package:ashera_pet_new/enum/photo_type.dart';
import 'package:ashera_pet_new/model/member_pet.dart';
import 'package:ashera_pet_new/model/pet_classfication_dto.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart' as c;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/auth.dart';
import '../model/place.dart';
import '../model/tuple.dart';
import '../routes/app_router.dart';
import '../utils/api.dart';
import '../utils/app_color.dart';
import '../utils/utils.dart';
import '../widget/map/bottom_sheet.dart';

class MemberPetVm with ChangeNotifier {
  //總共有多少寵物
  int get petTotal => Pet.petModel.length;
  //當前選中
  int _petTarget = 0;
  int get petTarget => _petTarget;

  //本身座標
  final Map<String, dynamic> _selfLatLng = {'latitude': 0.0, 'longitude': 0.0};
  Map<String, dynamic> get selfLatLng => _selfLatLng;

  // c.ClusterManager? _manager;
  // c.ClusterManager? get manager => _manager;

  // final List<Place> _item = [];

  final Set<Marker> _marker = {};
  Set<Marker> get marker => _marker;

  //當前選中的照片
  List<String> pics(int index) =>
      List<String>.from(json.decode(Pet.petModel[index].pics));

  final List<MemberPetModel> _showBottomPet = [];
  List<MemberPetModel> get showBottomPet => _showBottomPet;

  void setNickname(String value, [int? index]) {
    if (value != Pet.petModel[index ?? 0].nickname) {
      Pet.petModel[index ?? 0] =
          Pet.petModel[index ?? 0].copyWith(nickname: value);
    }
  }

  void setAboutMe(String value, [int? index]) {
    if (value != Pet.petModel[index ?? 0].aboutMe) {
      Pet.petModel[index ?? 0] =
          Pet.petModel[index ?? 0].copyWith(aboutMe: value);
    }
  }

  void setMugshot(String value, [int? index]) {
    if (Pet.petModel.isNotEmpty) {
      if (value != Pet.petModel[index ?? 0].mugshot) {
        Pet.petModel[index ?? 0] =
            Pet.petModel[index ?? 0].copyWith(mugshot: value);
      }
    }
  }

  void setFacePic(String value, [int? index]) {
    if (value != Pet.petModel[index ?? 0].facePic) {
      Pet.petModel[index ?? 0] =
          Pet.petModel[index ?? 0].copyWith(facePic: value);
    }
  }

  void setAge(int value, [int? index]) {
    if (value != Pet.petModel[index ?? 0].age) {
      Pet.petModel[index ?? 0] = Pet.petModel[index ?? 0].copyWith(age: value);
    }
  }

  void setBirthday(String value, [int? index]) {
    if (value != Pet.petModel[index ?? 0].birthday) {
      Pet.petModel[index ?? 0] =
          Pet.petModel[index ?? 0].copyWith(birthday: value);
    }
  }

  void setAnimalType(int value, [int? index]) {
    if (value != Pet.petModel[index ?? 0].animalType) {
      Pet.petModel[index ?? 0] =
          Pet.petModel[index ?? 0].copyWith(animalType: value);
    }
  }

  void setGender(int value, [int? index]) {
    if (value != Pet.petModel[index ?? 0].gender) {
      Pet.petModel[index ?? 0] =
          Pet.petModel[index ?? 0].copyWith(gender: value);
    }
  }

  void setHealthStatus(int value, [int? index]) {
    if (value != Pet.petModel[index ?? 0].healthStatus) {
      Pet.petModel[index ?? 0] =
          Pet.petModel[index ?? 0].copyWith(healthStatus: value);
      notifyListeners();
    }
  }

  void setMorePic(List<String> value, [int? index]) {
    if (value !=
        List<String>.from(json.decode(Pet.petModel[index ?? 0].pics))) {
      List<String> list =
          List<String>.from(json.decode(Pet.petModel[index ?? 0].pics))
            ..addAll(value);
      Pet.petModel[index ?? 0] =
          Pet.petModel[index ?? 0].copyWith(pics: json.encode(list));
    }
  }

  void deletePic(String filename, [int? index]) async {
    String token = Auth.userLoginResDTO.body.token;
    int id = Pet.petModel[index ?? 0].id;
    Tuple<bool, String> r =
        await Isolate.run(() => deletePetPicIso(id, filename, token));
    if (r.i1!) {
      List<String> list =
          List<String>.from(json.decode(Pet.petModel[index ?? 0].pics));
      list.remove(filename);
      Pet.petModel[index ?? 0] =
          Pet.petModel[index ?? 0].copyWith(pics: json.encode(list));
      updatePet(index);
    }
  }

  Future<void> updatePetAvatar([int? index]) async {
    Tuple<bool, String> r = await Api.uploadFile(
        Member.memberModel.name,
        Pet.petModel[index ?? 0].mugshot,
        PhotoType.pet,
        Pet.petModel[index ?? 0]);
    if (r.i1!) {
      //上傳成功
      log('update Avatar i2: ${r.i2!}');
      Pet.petModel[index ?? 0] =
          Pet.petModel[index ?? 0].copyWith(mugshot: r.i2!);
    } else {
      //更新失敗
      log('update fail');
    }
  }

  Future<Tuple<bool, String>> updatePetFacePic([int? index]) async {
    //上傳暫存
    Tuple<bool, String> r = await Api.uploadFile(
        Member.memberModel.name,
        Pet.petModel[index ?? 0].facePic,
        PhotoType.tmp,
        Pet.petModel[index ?? 0]);
    if (r.i1!) {
      //上傳成功
      log('update FacePic i2: ${r.i2!}');
      //辨識貓狗
      PetClassficationReqDTO dto = PetClassficationReqDTO(pic: r.i2!);
      Tuple<bool, String> r1 = await Api.postPetClassfication(dto);
      if (r1.i1!) {
        log('${r1.i2}');
        PetClassficationResDTO dto = PetClassficationResDTO.fromJson(r1.i2!);
        if (dto.animalType == null) {
          return Tuple<bool, String>(false, '非寵物相片！請重新上傳');
        }
        if (dto.animalType!.index == Pet.petModel[index ?? 0].animalType &&
            dto.score >= 0.99) {
          //
          Tuple<bool, String> r = await Api.uploadFile(
              Member.memberModel.name,
              Pet.petModel[index ?? 0].facePic,
              PhotoType.face,
              Pet.petModel[index ?? 0]);
          if (r.i1!) {
            Pet.petModel[index ?? 0] =
                Pet.petModel[index ?? 0].copyWith(facePic: r.i2!);
            log('r1: ${r1.i2}');
            return Tuple<bool, String>(true, '上傳成功');
          }
          //更新Pet facePic欄位失敗
          return Tuple<bool, String>(false, '上傳失敗');
        }
        log('r1: ${r1.i2}');
        //寵物類型不符
        return Tuple<bool, String>(false, '寵物類型不符或特徵不明顯，請更換照片');
      } else {
        //辨識失敗
        return Tuple<bool, String>(false, '辨識失敗，請上傳寵物特徵相片');
      }
    } else {
      //更新失敗
      log('update fail');
      return Tuple<bool, String>(false, '更新失敗');
    }
  }

  //新增寵物
  Future<Tuple<bool, String>> addPet([int? index]) async {
    log('上傳的值： ${Pet.petModel[index ?? 0].addMemberPetDTO()}');
    Tuple<bool, String> r =
        await Api.postMemberPet(Pet.petModel[index ?? 0].addMemberPetDTO());
    log('Add Pet i2: ${r.i2!}');
    return r;
  }

  //新增其他寵物
  /*Future<Tuple<bool, String>> addOtherPet() async {
    Tuple<bool, String> r = await Api.postMemberPet();
    log('Add OtherPet i2: ${r.i2!}');
    return r;
  }*/

  //刪除寵物
  Future<void> deletePet([int? index]) async {
    log('上傳的值：${Pet.petModel[index ?? 0].id}');
    if (index != null) {
      int id = Pet.petModel[index].id;
      Tuple<bool, String> r = await Api.deleteMemberPet(id);
      log('Delete Pet i2: ${r.i2!}');
      //防止target不對
      if (index == _petTarget) {
        _petTarget = 0;
      }
      await getPet();

      notifyListeners();
    }
  }

  //取得寵物
  Future<void> getPet() async {
    Tuple<bool, String> r = await Api.getPetByMemberId();
    log('getPet i2: ${r.i2!}');
    if (json.decode(r.i2!).isNotEmpty) {
      Pet.petModel = await Isolate.run(() => _getPet(r.i2!));
      _setMarker();
      notifyListeners();
    } else {
      Pet.petModel.clear();
      _petTarget = 0;
    }
  }

  //更新寵物
  Future<Tuple<bool, String>> updatePet([int? index]) async {
    Pet.petModel[index ?? 0] = Pet.petModel[index ?? 0].copyWith(
        latitude: _selfLatLng['latitude'], longitude: _selfLatLng['longitude']);
    Tuple<bool, String> r = await Api.putPetByMemberId(
        Pet.petModel[index ?? 0].updateMemberPetDTO());
    log('Update Pet i2: ${r.i2!}');
    Pet.petModel[index ?? 0] = MemberPetModel.fromJson(r.i2!);
    notifyListeners();
    return r;
  }

  void setTarget(int index) {
    if (_petTarget != index) {
      _petTarget = index;
      notifyListeners();
    }
  }

  void setLocation(Map<String, dynamic> map) {
    if (_selfLatLng != map) {
      _selfLatLng.update('latitude', (value) => map['latitude']);
      _selfLatLng.update('longitude', (value) => map['longitude']);
      notifyListeners();
    }
  }

  void _setMarker() async {
    await Future.forEach(Pet.petModel, (element) async {
      if (element.longitude != 0.0 && element.latitude != 0.0) {
        if (element.mugshot.isNotEmpty) {
          // if (_item.where((item) => item.pet.id == element.id).isEmpty) {
          //   _item.add(Place(
          //       name: element.nickname,
          //       pet: element,
          //       latLng: LatLng(element.latitude.toDouble(),
          //           element.longitude.toDouble())));
          // }
        }
      }
    });
  }

  void initClusterManager(int mapId) async {
    // _manager = _initClusterManager();
    // _manager!.setMapId(mapId);
    await Future.delayed(
        const Duration(milliseconds: 500), () => _setItemToManager());
  }

  void _setItemToManager() {
    // _manager!.setItems(_item);
  }

  // c.ClusterManager _initClusterManager() {
    // return c.ClusterManager<Place>(_item, _updateMarkers,
    //     markerBuilder: _markerBuilder,
    //     //extraPercent: 3,
    //     stopClusteringZoom: 16.5);
  // }

  void _updateMarkers(Set<Marker> markers) {
    _marker.clear();
    _marker.addAll(markers);
    notifyListeners();
  }

  Future<Marker> Function(dynamic) get _markerBuilder => (cluster) async {
        // cluster as c.Cluster<Place>;
        String token = Auth.userLoginResDTO.body.token;
        log('cluster: ${cluster.count} ${cluster.isMultiple}');
        return Marker(
            markerId: MarkerId(cluster.getId()),
            position: cluster.location,
            onTap: () async {
              if (cluster.count == 1) {
                log('只有自己');
              } else {
                log('多人');
                _showBottomPet.clear();
                // await Future.forEach(cluster.items,
                //     (element) => _showBottomPet.add(element.pet));
                _multiPersonBottomSheet();
              }
            },
            icon: await Utils.buildMarkerIcon(
                cluster.items.first.mugshot,
                token,
                const Size(150, 150),
                _getColor(cluster.items.first.healthStatus),
                cluster.isMultiple,
                cluster.count));
      };

  void _multiPersonBottomSheet() {
    showModalBottomSheet(
        context: AppRouter.ctx,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
          top: Radius.circular(30),
        )),
        builder: (context) => DraggableScrollableSheet(
              initialChildSize: 0.4,
              maxChildSize: 0.9,
              minChildSize: 0.32,
              expand: false,
              snap: true,
              builder: (context, scrollController) => PetBottomSheet(
                controller: scrollController,
                pets: _showBottomPet,
              ),
            ));
  }

  Color _getColor(int healthStatus) {
    switch (healthStatus) {
      case 0:
        return AppColor.healthy;
      case 1: //走失
        return AppColor.lost;
      case 2: //待領養
        return AppColor.toBeAdopted;
      default:
        return Colors.white;
    }
  }
}

List<MemberPetModel> _getPet(String value) {
  List petList = json.decode(value);
  return petList.map((e) => MemberPetModel.fromMap(e)).toList();
}
