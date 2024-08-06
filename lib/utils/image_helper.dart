import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImageHelper{
  final ImagePicker _imagePicker = ImagePicker();
  final ImageCropper _imageCropper = ImageCropper();

  Future<List<XFile>> pickImage({
    ImageSource source = ImageSource.gallery,
    int imageQuality = 100,
    bool multiple = false
  }) async {
    if(multiple){
      return await _imagePicker.pickMultiImage(imageQuality: imageQuality);
    }
    final file = await _imagePicker.pickImage(
        source: source,
        imageQuality: imageQuality
    );
    if(file != null) return [file];
    return [];
  }

  Future<CroppedFile?> crop({
    required XFile file,
    CropStyle cropStyle = CropStyle.rectangle
  }) async => await _imageCropper.cropImage(sourcePath: file.path, uiSettings: [
    AndroidUiSettings(
      toolbarTitle: '裁切',
      toolbarColor: Colors.deepOrange,
      toolbarWidgetColor: Colors.white,
    ),
    IOSUiSettings(
      title: '裁切',
      rotateClockwiseButtonHidden: true,
      resetButtonHidden: true,
      doneButtonTitle: '確認',
      cancelButtonTitle: '取消',
      aspectRatioPickerButtonHidden: true
    ),
  ]);
}