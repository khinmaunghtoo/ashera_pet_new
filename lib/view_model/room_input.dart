import 'dart:developer';

import 'package:flutter/cupertino.dart';

class RoomInputVm with ChangeNotifier{
  late FocusNode focusNode;
  late TextEditingController input;

  late ScrollController _controller;

  void init(FocusNode focus, TextEditingController controller){
    focusNode = focus;
    input = controller;
    focusNode.addListener(_focusNodeListener);
  }

  void initScrollController(ScrollController controller){
    _controller = controller;
  }

  void _focusNodeListener()async{
    if(focusNode.hasFocus){
      log('focusNode監聽');
      await Future.delayed(const Duration(milliseconds: 500));
      //_controller.animateTo(_controller.position.maxScrollExtent + 999, duration: const Duration(milliseconds: 500), curve: Curves.ease);
    }
  }

  void disposeFocus(){
    focusNode.removeListener(_focusNodeListener);
  }
}