import 'dart:developer';

import 'package:ashera_pet_new/view_model/camera.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../dialog/cupertion_alert.dart';
import '../../utils/app_color.dart';

class ScanCameraPreview extends StatefulWidget {
  const ScanCameraPreview({super.key});

  @override
  State<StatefulWidget> createState() => _ScanCameraPreviewState();
}

class _ScanCameraPreviewState extends State<ScanCameraPreview> {
  late List<CameraDescription> _cameras;

  CameraController? controller;

  @override
  void initState() {
    super.initState();
    _getAvailableCameras();
  }

  void _getAvailableCameras() async {
    _cameras = await availableCameras();
    //log('${_cameras[0]}');
    controller =
        CameraController(_cameras[0], ResolutionPreset.max, enableAudio: false);
    controller!.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) async {
      if (e is CameraException) {
        log('${e.description}');
        switch (e.code) {
          case 'CameraAccessDenied':
            if (mounted) {
              await showCupertinoAlert(
                title: '提示',
                content: '請至設定開啟相機權限',
                context: context,
                cancel: false,
                confirmation: true,
              );
              if (mounted) context.pop();
            }
            break;
          case 'CameraAccessDeniedWithoutPrompt':
            if (mounted) {
              await showCupertinoAlert(
                title: '提示',
                content: '請至設定開啟相機權限',
                context: context,
                cancel: false,
                confirmation: true,
              );
              if (mounted) context.pop();
            }
            break;
          case 'CameraAccessRestricted':
            if (mounted) {
              await showCupertinoAlert(
                title: '提示',
                content: '請至設定開啟相機權限',
                context: context,
                cancel: false,
                confirmation: true,
              );
              if (mounted) context.pop();
            }
            break;
          default:
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      return Container(
        decoration: const BoxDecoration(color: AppColor.appBackground),
      );
    }
    if (controller!.value.isInitialized) {
      return Consumer<CameraVm>(
        builder: (context, vm, _) {
          vm.setController(controller);
          return CameraPreview(controller!);
        },
      );
    } else {
      return Container(
        decoration: const BoxDecoration(color: AppColor.appBackground),
      );
    }
  }
}
