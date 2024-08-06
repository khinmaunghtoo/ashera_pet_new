import 'package:flutter/cupertino.dart';

class VideoVm with ChangeNotifier{
  //靜音
  bool _isMute = true;
  bool get isMute => _isMute;

  double _volume = 0.0;
  double get volume => _volume;

  void setMute(bool value){
    if(_isMute != value){
      _isMute = value;
      if(_isMute){
        _setVideoVolume(0.0);
      }else{
        _setVideoVolume(100.0);
      }
    }
  }


  void _setVideoVolume(double value) {
    if(_volume != value){
      _volume = value;
      notifyListeners();
    }
  }

  void onRefresh(){
    //notifyListeners();
  }

}