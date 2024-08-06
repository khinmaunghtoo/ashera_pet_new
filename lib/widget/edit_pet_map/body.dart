import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../view_model/member_pet.dart';

class EditPetMapBody extends StatefulWidget {
  const EditPetMapBody({super.key});

  @override
  State<StatefulWidget> createState() => _EditPetMapBodyState();
}

class _EditPetMapBodyState extends State<EditPetMapBody> {
  final Completer<GoogleMapController> _controller = Completer();

  @override
  Widget build(BuildContext context) {
    return Consumer<MemberPetVm>(builder: (context, vm, _){
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
        onCameraMove: (position){
          if(vm.manager != null){
            //log('onCameraMove: $position');
            vm.manager!.onCameraMove(position);
          }
        },
        onCameraIdle: (){
          if(vm.manager != null){
            //log('onCameraIdle');
            vm.manager!.updateMap();
          }
        },
        initialCameraPosition: CameraPosition(
            target: LatLng(
                vm.selfLatLng['latitude'], vm.selfLatLng['longitude']),
            zoom: 16),
      );
    });
  }

}
