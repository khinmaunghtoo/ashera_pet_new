import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/db/app_db.dart';
import 'package:ashera_pet_new/model/member_pet.dart';
import 'package:ashera_pet_new/utils/geolocator_service.dart';
import 'package:ashera_pet_new/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_cluster_manager/google_maps_cluster_manager.dart'
    as c;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../data/auth.dart';
import '../data/pet.dart';
import '../enum/filter_animal_type.dart';
import '../enum/health_status.dart';
import '../enum/like_content_type.dart';
import '../enum/member_status.dart';
import '../model/member_pet_like.dart';
import '../model/member_view.dart';
import '../model/place.dart';
import '../model/tuple.dart';
import '../routes/app_router.dart';
import '../routes/route_name.dart';
import '../utils/api.dart';
import '../utils/app_color.dart';
import '../widget/map/bottom_sheet.dart';

class KanBanVm extends ChangeNotifier {
  List<MemberPetModel> _pets = [];
  List<MemberPetModel> _filterPets = [];
  List<MemberPetModel> get pets => _pets;
  List<MemberPetModel> get filterPets => _filterPets;

  FilterAnimalType _type = FilterAnimalType.all;
  FilterAnimalType get type => _type;

  FilterHealthStatus _status = FilterHealthStatus.all;
  FilterHealthStatus get status => _status;

  PageController? _controller;
  PageController get controller => _controller!;
  LikeContentType _likeContentType = LikeContentType.like;
  LikeContentType get likeContentType => _likeContentType;

  //我點的
  List<MemberPetLikeModel> _likes = [];
  final List<MemberPetLikeModel> _meLikes = [];
  List<MemberPetLikeModel> get collectionList =>
      _likes.where((element) => element.iKeep == true).toList();
  List<MemberPetLikeModel> get meLikes =>
      _meLikes.where((element) => element.iLike == true).toList();
  //別人點我
  final List<MemberPetLikeModel> _likeMes = [];
  List<MemberPetLikeModel> get likeMes =>
      _likeMes.where((element) => element.iLike == true).toList();

  c.ClusterManager? _manager;
  c.ClusterManager? get manager => _manager;

  final List<Place> _item = [];

  final List<MemberPetModel> _showBottomPet = [];
  List<MemberPetModel> get showBottomPet => _showBottomPet;

  //顯示搜尋
  bool _isShowAnimation = false;
  bool get isShowAnimation => _isShowAnimation;

  //本身座標
  final Map<String, dynamic> _selfLatLng = {'latitude': 0.0, 'longitude': 0.0};
  Map<String, dynamic> get selfLatLng => _selfLatLng;

  final Set<Marker> _marker = {};
  Set<Marker> get marker => _marker;

  //是否點讚
  bool isLike(int petId) =>
      _likes.where((element) => element.memberPetId == petId).isNotEmpty
          ? _likes.where((element) => element.memberPetId == petId).first.iLike
          : false;

  //是否收藏
  bool isCollection(int petId) =>
      _likes.where((element) => element.memberPetId == petId).isNotEmpty
          ? _likes.where((element) => element.memberPetId == petId).first.iKeep
          : false;

  final Map<int, int> _counts = {};
  int count(int petId) => _counts[petId] ?? 0;

  //取得所有寵物
  void getAllPet() async {
    log('取得全部寵物');
    if (_pets.isNotEmpty) {
      List<Map<String, dynamic>> r = await AppDB.getAllTableData(AppDB.allPet);
      if (r.isEmpty) {
        String token = Auth.userLoginResDTO.body.token;
        Tuple<bool, String> r = await Isolate.run(() => getAllMemberPet(token));
        if (r.i1!) {
          log('取得所有寵物: ${r.i2}');
          List<MemberPetModel> list = await _readPetList(r.i2!);
          if (list != _pets) {
            _pets = List<MemberPetModel>.from(list);
            _setPet();
            _dataCollation();
            Pet.allPets = List<MemberPetModel>.from(list);
            notifyListeners();
            //整理資料庫寵物
            _organizeTheDatabaseOfPets(_pets);
          }
        }
      } else {
        List<MemberPetModel> allPets =
            await Isolate.run(() => _readAllTableAllPetData(r));
        _pets = List<MemberPetModel>.from(allPets);
        _setPet();
        _dataCollation();
        Pet.allPets = List<MemberPetModel>.from(allPets);
        notifyListeners();
        String token = Auth.userLoginResDTO.body.token;
        Tuple<bool, String> r0 =
            await Isolate.run(() => getAllMemberPet(token));
        if (r0.i1!) {
          List<MemberPetModel> list = await _readPetList(r0.i2!);
          //整理資料庫寵物
          _organizeTheDatabaseOfPets(list);
        }
      }
    } else {
      List<Map<String, dynamic>> r = await AppDB.getAllTableData(AppDB.allPet);
      log('寵物資料庫是空的嗎？${r.isEmpty}');
      if (r.isEmpty) {
        String token = Auth.userLoginResDTO.body.token;
        Tuple<bool, String> r = await Isolate.run(() => getAllMemberPet(token));
        if (r.i1!) {
          log('取得所有寵物: ${r.i2}');
          List<MemberPetModel> list = await _readPetList(r.i2!);
          _pets = List<MemberPetModel>.from(list);
          Pet.allPets = List<MemberPetModel>.from(list);
          _setPet();
          _dataCollation();
          notifyListeners();
          //整理資料庫寵物
          _organizeTheDatabaseOfPets(_pets);
        }
      } else {
        log('寵物沒放進去嗎');
        List<MemberPetModel> allPets =
            await Isolate.run(() => _readAllTableAllPetData(r));
        _pets = List<MemberPetModel>.from(allPets);
        _setPet();
        _dataCollation();
        Pet.allPets = List<MemberPetModel>.from(allPets);
        notifyListeners();
        await Future.delayed(const Duration(milliseconds: 5000));
        String token = Auth.userLoginResDTO.body.token;
        Tuple<bool, String> r0 =
            await Isolate.run(() => getAllMemberPet(token));
        if (r0.i1!) {
          List<MemberPetModel> list = await _readPetList(r0.i2!);
          //整理資料庫寵物
          _organizeTheDatabaseOfPets(list);
        }
      }
    }
  }

  //整理資料庫寵物
  void _organizeTheDatabaseOfPets(List<MemberPetModel> pets) async {
    pets.forEach((element) async {
      List<Map<String, dynamic>> dbPets =
          await AppDB.getTableData(AppDB.allPet, 'id = ?', ['${element.id}']);
      if (dbPets.isEmpty) {
        //log('新增進寵物資料庫${element.toMap()}');
        await AppDB.insert(AppDB.allPet, element.addAllPetToDB());
        await Future.delayed(const Duration(milliseconds: 100));
      } else {
        MemberPetModel model = MemberPetModel.fromMap(dbPets.first);
        if (model != element) {
          //log('修改進寵物資料庫${element.toMap()}');
          await AppDB.update(AppDB.allPet, 'id = ?', ['${element.id}'],
              element.addAllPetToDB());
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }
    });

    List<Map<String, dynamic>> dbAllPets =
        await AppDB.getAllTableData(AppDB.allPet);
    await Future.forEach(dbAllPets, (element) async {
      MemberPetModel model = MemberPetModel.fromMap(element);
      if (pets.where((onlinePet) => onlinePet.id == model.id).isNotEmpty) {
      } else {
        await AppDB.deleteData(AppDB.allPet, 'id = ?', [model.id]);
      }
    });
    List<Map<String, dynamic>> r = await AppDB.getAllTableData(AppDB.allPet);
    List<MemberPetModel> allPets =
        await Isolate.run(() => _readAllTableAllPetData(r));
    Pet.allPets = List<MemberPetModel>.from(allPets);
    notifyListeners();
  }

  void setFilterAnimalType(FilterAnimalType value) {
    if (_type != value) {
      _type = value;
      _setPet();
    }
  }

  void setFilterHealthStatue(FilterHealthStatus value) {
    if (_status != value) {
      _status = value;
      _setPet();
    }
  }

  void setLikeContentType(LikeContentType value) {
    if (_likeContentType != value) {
      _likeContentType = value;
      notifyListeners();
      _controller!.jumpToPage(value.index);
    }
  }

  void setPageController(PageController value) {
    _controller = value;
    notifyListeners();
    _controller!.jumpToPage(LikeContentType.like.index);
  }

  void _setPet() {
    _marker.clear();
    _item.clear();
    if (_status == FilterHealthStatus.all && _type == FilterAnimalType.all) {
      _pets.sort((f, l) {
        int compare = HealthStatus.values[f.healthStatus].sortIndex
            .compareTo(HealthStatus.values[l.healthStatus].sortIndex);
        if (compare == 0) {
          return _getKm(HealthStatus.values[f.healthStatus],
                  f.latitude.toDouble(), f.longitude.toDouble())
              .compareTo(_getKm(HealthStatus.values[l.healthStatus],
                  l.latitude.toDouble(), l.longitude.toDouble()));
        } else {
          return compare;
        }
      });
      _filterPets = List<MemberPetModel>.from(_pets);
      notifyListeners();
    } else if (_status != FilterHealthStatus.all &&
        _type == FilterAnimalType.all) {
      _filterPets = List<MemberPetModel>.from(_pets
          .where((element) => element.healthStatus == _status.index)
          .toList());
      _filterPets.sort((f, l) {
        int compare = HealthStatus.values[f.healthStatus].sortIndex
            .compareTo(HealthStatus.values[l.healthStatus].sortIndex);
        if (compare == 0) {
          return _getKm(HealthStatus.values[f.healthStatus],
                  f.latitude.toDouble(), f.longitude.toDouble())
              .compareTo(_getKm(HealthStatus.values[l.healthStatus],
                  l.latitude.toDouble(), l.longitude.toDouble()));
        } else {
          return compare;
        }
      });
      notifyListeners();
    } else if (_status == FilterHealthStatus.all &&
        _type != FilterAnimalType.all) {
      _filterPets = List<MemberPetModel>.from(
          _pets.where((element) => element.animalType == _type.index).toList());
      _filterPets.sort((f, l) {
        int compare = HealthStatus.values[f.healthStatus].sortIndex
            .compareTo(HealthStatus.values[l.healthStatus].sortIndex);
        if (compare == 0) {
          return _getKm(HealthStatus.values[f.healthStatus],
                  f.latitude.toDouble(), f.longitude.toDouble())
              .compareTo(_getKm(HealthStatus.values[l.healthStatus],
                  l.latitude.toDouble(), l.longitude.toDouble()));
        } else {
          return compare;
        }
      });
      notifyListeners();
    } else if (_status != FilterHealthStatus.all &&
        _type != FilterAnimalType.all) {
      _filterPets = List<MemberPetModel>.from(_pets
          .where((element) =>
              element.healthStatus == _status.index &&
              element.animalType == _type.index)
          .toList());
      _filterPets.sort((f, l) {
        int compare = HealthStatus.values[f.healthStatus].sortIndex
            .compareTo(HealthStatus.values[l.healthStatus].sortIndex);
        if (compare == 0) {
          return _getKm(HealthStatus.values[f.healthStatus],
                  f.latitude.toDouble(), f.longitude.toDouble())
              .compareTo(_getKm(HealthStatus.values[l.healthStatus],
                  l.latitude.toDouble(), l.longitude.toDouble()));
        } else {
          return compare;
        }
      });
      notifyListeners();
    }
    _setMarker();
    if (_manager != null) {
      Future.delayed(
          const Duration(milliseconds: 500), () => _manager!.updateMap());
    }
  }

  void _setMarker() async {
    await Future.forEach(filterPets, (element) async {
      if (element.longitude != 0.0 && element.latitude != 0.0) {
        if (element.mugshot.isNotEmpty &&
            element.healthStatus != HealthStatus.healthy.index) {
          if (_item.where((item) => item.pet.id == element.id).isEmpty) {
            _item.add(Place(
                name: element.nickname,
                pet: element,
                latLng: LatLng(element.latitude.toDouble(),
                    element.longitude.toDouble())));
          }
        }
      }
    });
  }

  Color _getColor(int healthStatus) {
    switch (healthStatus) {
      case 1: //走失
        return AppColor.lost;
      case 2: //待領養
        return AppColor.toBeAdopted;
      default:
        return Colors.white;
    }
  }

  void onTapHeart(MemberPetModel pet) async {
    String token = Auth.userLoginResDTO.body.token;
    if (isLike(pet.id)) {
      //取消點讚
      MemberPetLikeModel dto = _likes
          .where((element) => element.memberPetId == pet.id)
          .first
          .copyWith(iLike: false);
      await Isolate.run(() => putMemberPetLike(dto, token));
      int indexMeLikes = _meLikes.indexWhere((e) =>
          e.memberPetId == pet.id && e.memberId == Member.memberModel.id);
      int indexLikes = _likes.indexWhere((e) =>
          e.memberPetId == pet.id && e.memberId == Member.memberModel.id);
      _likes.removeAt(indexLikes);
      _meLikes.removeAt(indexMeLikes);
      _counts.update(pet.id, (value) => value - 1);
      notifyListeners();
    } else {
      //點讚
      MemberPetLikeModel dto;
      if (_likes.where((element) => element.memberPetId == pet.id).isNotEmpty) {
        int index = _likes.indexWhere((e) => e.memberPetId == pet.id);

        dto = _likes
            .where((element) => element.memberPetId == pet.id)
            .first
            .copyWith(iLike: true, petMemberId: pet.memberId);
        _likes.removeAt(index);
        _likes.add(dto);
        _meLikes.add(dto);
        if (_counts[pet.id] == null) {
          _counts[pet.id] = 1;
        } else {
          _counts.update(pet.id, (value) => value + 1);
        }
        notifyListeners();
      } else {
        dto = MemberPetLikeModel(
            iLike: true,
            memberId: Member.memberModel.id,
            memberPetId: pet.id,
            petMemberId: pet.memberId);
        _likes.add(dto);
        _meLikes.add(dto);
        if (_counts[pet.id] == null) {
          _counts[pet.id] = 1;
        } else {
          _counts.update(pet.id, (value) => value + 1);
        }
        notifyListeners();
      }
      await Isolate.run(() => putMemberPetLike(dto, token));
    }
  }

  void onTapCollection(int petId) async {
    String token = Auth.userLoginResDTO.body.token;
    if (isCollection(petId)) {
      //取消收藏
      MemberPetLikeModel dto = _likes
          .where((element) => element.memberPetId == petId)
          .first
          .copyWith(iKeep: false);
      await Isolate.run(() => putMemberPetLike(dto, token));
      getMyLike();
    } else {
      //收藏
      MemberPetLikeModel dto;
      if (_likes.where((element) => element.memberPetId == petId).isNotEmpty) {
        dto = _likes
            .where((element) => element.memberPetId == petId)
            .first
            .copyWith(iKeep: true);
      } else {
        dto = MemberPetLikeModel(
            iKeep: true, memberId: Member.memberModel.id, memberPetId: petId);
      }
      await Isolate.run(() => putMemberPetLike(dto, token));
      getMyLike();
    }
  }

  void getMyLike() async {
    String token = Auth.userLoginResDTO.body.token;
    int id = Member.memberModel.id;
    _meLikes.clear();
    Tuple<bool, String> r =
        await Isolate.run(() => getMemberPetLikeByMemberId(id, token));
    if (r.i1!) {
      List list = json.decode(r.i2!);
      log('Like: ${r.i2}');
      _likes = List<MemberPetLikeModel>.from(
          list.map((e) => MemberPetLikeModel.fromMap(e)).toList());

      for (var element in _likes) {
        if (Pet.petModel
            .where((value) => value.id == element.memberPetId)
            .isEmpty) {
          if (_pets
              .where((value) => value.id == element.memberPetId)
              .isNotEmpty) {
            element = element.copyWith(
                petMemberId: _pets
                    .firstWhere((value) => value.id == element.memberPetId)
                    .memberId);
            _meLikes.add(element);
            /*if(_meLikes.where((value) => value.petMemberId == element.petMemberId).isEmpty){
              _meLikes.add(element);
            }*/
          }
        }
      }

      notifyListeners();
    }
  }

  void getLikeMe() async {
    String token = Auth.userLoginResDTO.body.token;
    int id = Member.memberModel.id;
    _likeMes.clear();
    Tuple<bool, String> r =
        await Isolate.run(() => getMemberPetLikeByMemberIdNot(id, token));
    if (r.i1!) {
      List list = json.decode(r.i2!);
      List<MemberPetLikeModel> data = List<MemberPetLikeModel>.from(
          list.map((e) => MemberPetLikeModel.fromMap(e)).toList());
      for (var element in data) {
        if (Pet.petModel
            .where((value) => value.id == element.memberPetId)
            .isNotEmpty) {
          //if(_likeMes.where((value) => value.memberId == element.memberId).isEmpty){
          _likeMes.add(element);
          //}
        }
      }
      notifyListeners();
    }
  }

  Future<int> getCount(petId) async {
    String token = Auth.userLoginResDTO.body.token;
    Tuple<bool, String> r =
        await Isolate.run(() => getCountByMemberPetIdAndILike(petId, token));
    log('取得讚數: ${r.i2}');
    if (r.i1!) {
      return int.parse(r.i2!);
    }
    return 0;
  }

  //資料整理
  void _dataCollation() async {
    Future.forEach(_pets, (element) async => await _updateData(element.id));
  }

  Future<void> _updateData(int petId) async {
    int count = await getCount(petId);
    if (_counts[petId] == null) {
      _counts[petId] = count;
    } else {
      _counts.update(petId, (value) => count);
    }
    notifyListeners();
  }

  void setLocation(Map<String, dynamic> map) {
    if (_selfLatLng != map) {
      _selfLatLng.update('latitude', (value) => map['latitude']);
      _selfLatLng.update('longitude', (value) => map['longitude']);
      notifyListeners();
    }
  }

  void initClusterManager(int mapId) async {
    _manager = _initClusterManager();
    _manager!.setMapId(mapId);
    await Future.delayed(
        const Duration(milliseconds: 500), () => _setItemToManager());
  }

  void _setItemToManager() {
    _manager!.setItems(_item);
  }

  c.ClusterManager _initClusterManager() {
    return c.ClusterManager<Place>(
      _item,
      _updateMarkers,
      markerBuilder: _markerBuilder,
      //levels: [1],
      //extraPercent: 0.9,
      //stopClusteringZoom: 10.5
    );
  }

  void _updateMarkers(Set<Marker> markers) {
    _marker.clear();
    _marker.addAll(markers);
    notifyListeners();
  }

  Future<Marker> Function(dynamic) get _markerBuilder => (cluster) async {
        cluster as c.Cluster<Place>;
        String token = Auth.userLoginResDTO.body.token;
        log('cluster: ${cluster.location} ${cluster.count} ${cluster.isMultiple}');
        return Marker(
            markerId: MarkerId(cluster.getId()),
            position: cluster.location,
            onTap: () async {
              if (cluster.count == 1) {
                log('只有自己');
                AppRouter.ctx.push(RouteName.petMagazineContent,
                    extra: cluster.items.first.pet);
              } else {
                log('多人');
                _showBottomPet.clear();
                await Future.forEach(cluster.items,
                    (element) => _showBottomPet.add(element.pet));
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

  void setShowAnimation(bool value) {
    if (value != _isShowAnimation) {
      _isShowAnimation = value;
      notifyListeners();
      Future.delayed(const Duration(milliseconds: 3000), () {
        _isShowAnimation = false;
        notifyListeners();
      });
    }
  }

  double _getKm(HealthStatus status, double endLat, double endLng) {
    if (status == HealthStatus.healthy) {
      return 0;
    }
    if (endLng != 0 && endLat != 0) {
      double startLat = _selfLatLng['latitude'];
      double startLng = _selfLatLng['longitude'];
      double km = getDistanceBetween(startLat, startLng, endLat, endLng);
      return km / 1000;
    } else {
      return 0;
    }
  }

  void likeDispose() {
    _likeContentType = LikeContentType.like;
  }
}

Future<List<MemberPetModel>> _readPetList(String value) async {
  List list = json.decode(value);
  return list.map((e) => MemberPetModel.fromMap(e)).toList();
}

List<MemberPetModel> _readAllTableAllPetData(List<Map<String, dynamic>> data) {
  return List.generate(
      data.length,
      (index) => MemberPetModel(
          id: data[index]['id'],
          memberId: data[index]['memberId'],
          nickname: data[index]['nickname'],
          mugshot: data[index]['mugshot'],
          aboutMe: data[index]['aboutMe'],
          age: data[index]['age'],
          birthday: data[index]['birthday'],
          animalType: data[index]['animalType'],
          gender: data[index]['gender'],
          healthStatus: data[index]['healthStatus'],
          status: MemberStatus.values.byName(data[index]['status']),
          member: MemberView.fromJson(data[index]['member']),
          latitude: data[index]['latitude'],
          longitude: data[index]['longitude'],
          pics: data[index]['pics']));
}
