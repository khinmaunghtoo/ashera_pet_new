import 'package:ashera_pet_new/enum/animal.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class CameraVm extends ChangeNotifier {
  //選擇拍哪種動物
  AnimalType _animalType = AnimalType.dog;
  AnimalType get animalType => _animalType;

  CameraController? _controller;

  void setController(CameraController? controller) {
    _controller = controller;
  }

  Future<XFile?> takePicture() async {
    if (_controller != null) {
      if (_controller!.value.isInitialized) {
        return await _controller!.takePicture();
      }
      return null;
    }
    return null;
  }

  //初始化
  void init() {
    _animalType = AnimalType.dog;
    notifyListeners();
  }

  //設定
  void setAnimalType(AnimalType type) {
    if (_animalType != type) {
      _animalType = type;
      notifyListeners();
    }
  }
}
