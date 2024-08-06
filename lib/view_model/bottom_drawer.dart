
import 'package:flutter/cupertino.dart';

import '../widget/bottom_drawer/button_drawer.dart';

class BottomDrawerVm with ChangeNotifier{
  final BottomDrawerController _controller = BottomDrawerController();
  BottomDrawerController get controller => _controller;

  void open(){
    _controller.open();
  }

  void close(){
    _controller.close();
  }
}