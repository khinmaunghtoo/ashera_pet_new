// import 'dart:async';
// import 'dart:developer';
// import 'dart:isolate';

// import 'package:ashera_pet_new/data/pet.dart';
// import 'package:ashera_pet_new/model/member_pet.dart';
// import 'package:ashera_pet_new/utils/utils.dart';
// import 'package:geolocator/geolocator.dart';

// import '../data/auth.dart';
// import 'api.dart';

// class GeolocatorService {
//   static final GeolocatorPlatform _geolocatorPlatform =
//       GeolocatorPlatform.instance;
//   static StreamSubscription<Position>? _positionStreamSubscription;

//   static Future<bool> handlePermission() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//     serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       //服務未開
//       return false;
//     }

//     permission = await _geolocatorPlatform.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await _geolocatorPlatform.requestPermission();
//       if (permission == LocationPermission.denied) {
//         //權限被拒
//         return false;
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       //權限被拒
//       return false;
//     }

//     return true;
//   }

//   static startDetectingPosition() {
//     if (_positionStreamSubscription == null) {
//       final positionStream = _geolocatorPlatform.getPositionStream(
//           locationSettings: const LocationSettings(distanceFilter: 300));
//       _positionStreamSubscription = positionStream.handleError((error) {
//         _positionStreamSubscription?.cancel();
//       }).listen((event) async {
//         String token = Auth.userLoginResDTO.body.token;
//         log('位置：${event.latitude} ${event.longitude}');
//         Map<String, dynamic> map = {
//           'latitude': event.latitude,
//           'longitude': event.longitude
//         };
//         Utils.locationBus.fire(map);
//         //Utils.selfLatLng.update('latitude', (value) => event.latitude);
//         //Utils.selfLatLng.update('longitude', (value) => event.longitude);
//         Future.forEach(Pet.petModel, (element) async {
//           //更新寵物位置
//           MemberPetLocationDTO dto = MemberPetLocationDTO(
//               memberPetId: element.id,
//               latitude: event.latitude,
//               longitude: event.longitude);
//           await Isolate.run(() => uploadPetLocation(dto, token));
//         });
//       });
//     }
//   }

//   static Future<void> cancel() async {
//     if (_positionStreamSubscription != null) {
//       await _positionStreamSubscription?.cancel();
//       _positionStreamSubscription = null;
//     }
//   }
// }

// double getDistanceBetween(
//     double startLat, double startLng, double endLat, double endLng) {
//   return Geolocator.distanceBetween(startLat, startLng, endLat, endLng);
// }
