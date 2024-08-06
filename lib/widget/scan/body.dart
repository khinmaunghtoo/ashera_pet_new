import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ashera_pet_new/enum/animal.dart';
import 'package:ashera_pet_new/model/face_detect.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/utils/app_image.dart';
import 'package:ashera_pet_new/utils/utils.dart';
import 'package:ashera_pet_new/widget/button.dart';
import 'package:ashera_pet_new/widget/scan/camera_preview.dart';
import 'package:ashera_pet_new/widget/scan/scan_frame_painter.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../data/member.dart';
import '../../dialog/cupertion_alert.dart';
import '../../enum/photo_type.dart';
import '../../model/tuple.dart';
import '../../utils/api.dart';
import '../../view_model/camera.dart';

class ScanBody extends StatefulWidget {
  const ScanBody({super.key});
  @override
  State<StatefulWidget> createState() => _ScanBodyState();
}

class _ScanBodyState extends State<ScanBody> {
  CameraVm? _cameraVm;

  _onLayoutDone(_) {
    _cameraVm!.init();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
  }

  @override
  Widget build(BuildContext context) {
    _cameraVm = Provider.of<CameraVm>(context, listen: false);
    return Stack(
      fit: StackFit.expand,
      alignment: Alignment.center,
      children: [
        const ScanCameraPreview(),
        const Positioned(
            top: 250,
            child: CustomPaint(
              painter: ScanFramePainter(),
            )),
        Positioned(bottom: 30, right: 20, left: 20, child: _controller()),
      ],
    );
  }

  Widget _controller() {
    return Column(
      children: [
        //狗或貓
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _dogButtonStatus(),
            const SizedBox(
              width: 20,
            ),
            _catButtonStatus()
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        //說明
        const Text(
          '請先選取寵物類型\n再掃描臉部，以便進行辨識',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColor.textFieldTitle, fontSize: 16),
        ),
        const SizedBox(
          height: 20,
        ),
        //拍照
        SizedBox(
          width: 120,
          child:
              iconGrayRectangleButton('拍照', _takePicture, null, _cameraIcon()),
        )
      ],
    );
  }

  Widget _dogButtonStatus() {
    return Selector<CameraVm, AnimalType>(
      selector: (context, data) => data.animalType,
      shouldRebuild: (previous, next) => previous != next,
      builder: (context, animal, _) {
        switch (animal) {
          case AnimalType.dog:
            return _dogSelectedButton();
          case AnimalType.cat:
            return _dogButton();
        }
      },
    );
  }

  Widget _catButtonStatus() {
    return Selector<CameraVm, AnimalType>(
      selector: (context, data) => data.animalType,
      shouldRebuild: (previous, next) => previous != next,
      builder: (context, animal, _) {
        switch (animal) {
          case AnimalType.dog:
            return _catButton();
          case AnimalType.cat:
            return _catSelectedButton();
        }
      },
    );
  }

  //狗 按鈕
  Widget _dogSelectedButton() {
    return SizedBox(
      width: 120,
      child: iconBlueRectangleButton(
          '狗狗',
          () => _cameraVm!.setAnimalType(AnimalType.dog),
          null,
          _imgIcon(AppImage.iconDogSelected)),
    );
  }

  //狗 未選擇 按鈕
  Widget _dogButton() {
    return SizedBox(
      width: 120,
      child: iconGrayRectangleButton(
        '狗狗',
        () => _cameraVm!.setAnimalType(AnimalType.dog),
        null,
        _imgIcon(AppImage.iconDog),
      ),
    );
  }

  //貓 按鈕
  Widget _catSelectedButton() {
    return SizedBox(
      width: 120,
      child: iconBlueRectangleButton(
          '貓咪',
          () => _cameraVm!.setAnimalType(AnimalType.cat),
          null,
          _imgIcon(AppImage.iconCatSelected)),
    );
  }

  //貓 未選擇 按鈕
  Widget _catButton() {
    return SizedBox(
      width: 120,
      child: iconGrayRectangleButton(
        '貓咪',
        () => _cameraVm!.setAnimalType(AnimalType.cat),
        null,
        _imgIcon(AppImage.iconCat),
      ),
    );
  }

  //相片製icon
  Widget _imgIcon(String img) {
    return Image(
      width: 25,
      height: 25,
      image: AssetImage(
        img,
      ),
    );
  }

  //相機
  Widget _cameraIcon() {
    return const Icon(
      Icons.camera_alt,
      size: 25,
      color: AppColor.textFieldTitle,
    );
  }

  Size _getSize() {
    return MediaQuery.of(context).size;
  }

  void _takePicture() async {
    SVProgressHUD.show();
    //拍照
    XFile? file = await _cameraVm!.takePicture();
    if (file != null) {
      Size size = _getSize();
      File r = await Utils.cropImage(file, size);

      Tuple<bool, String> uploadImg =
          await Api.uploadFile(Member.memberModel.name, r.path, PhotoType.tmp);
      if (uploadImg.i1!) {
        FaceDetectModel dto = FaceDetectModel(
            memberId: Member.memberModel.id,
            animalType: _cameraVm!.animalType,
            pic: uploadImg.i2!);
        log('上傳資料：${dto.toApi()}');
        Tuple<bool, String> r = await Api.postDetect(dto.toApi());
        if (r.i1!) {
          //辨識回傳
          log('辨識回傳: ${r.i2}');
          SVProgressHUD.dismiss();
          List list = json.decode(r.i2!);

          if (list.isEmpty) {
            //沒有
            _showAlert('沒有相似的寵物');
          } else {
            //關閉並跳轉
            List<FaceDetectResponseModel> data =
                list.map((e) => FaceDetectResponseModel.fromMap(e)).toList();
            //較大 較小
            data.sort((bigger, smaller) =>
                smaller.similarity.compareTo(bigger.similarity));
            _jumpToNextPage(data);
          }
        } else {
          SVProgressHUD.showError(status: '');
        }
      } else {
        SVProgressHUD.showError(status: '');
      }
    } else {
      SVProgressHUD.showError(status: '');
    }
  }

  void _showDialog(File file) {
    Widget okButton = GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: const Text('ok'),
    );

    AlertDialog alert = AlertDialog(
      content: Image.file(file),
      actions: [okButton],
    );

    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  void _jumpToNextPage(List<FaceDetectResponseModel> list) {
    context.pop(list);
  }

  Future<bool> _showAlert(String text) async {
    Future.delayed(const Duration(milliseconds: 1800),
        () => Navigator.of(context).pop(true));
    return await showCupertinoAlert(
        context: context, content: text, cancel: false, confirmation: false);
  }
}
