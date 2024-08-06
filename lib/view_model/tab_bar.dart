import 'package:flutter/material.dart';

import '../enum/tab_bar.dart';
import '../model/faces_detect_history.dart';

class TabBarVm with ChangeNotifier{
  //辨識用
  PageController? _controller;
  PageController get pageController => _controller!;

  PageController? _followerController = PageController();
  PageController get followerController => _followerController!;

  //辨識用選到的項目
  TabBarEnum _tabBar = TabBarEnum.identifiedMe;
  TabBarEnum get tabBar => _tabBar;

  FollowerTabBarEnum _followerTabBar = FollowerTabBarEnum.myFollower;
  FollowerTabBarEnum get followerTabBar => _followerTabBar;

  List<FacesDetectHistoryModel> get whoSawMeList => [];

  List<FacesDetectHistoryModel> get whoDidISeeList => [];

  void setPageController(PageController controller){
    _controller = controller;
    _tabBar = TabBarEnum.identifiedMe;
    notifyListeners();
  }

  void refreshMe(PageController controller) async {
    _followerController = controller;
    await Future.delayed(const Duration(milliseconds: 300));
    _followerController!.jumpToPage(_followerTabBar.index);
  }

  void refresh(PageController controller) async {
    _followerController = controller;
    await Future.delayed(const Duration(milliseconds: 300));
    _followerController!.jumpToPage(_followerTabBar.index);
  }

  void setFollowerPageController(PageController controller, FollowerTabBarEnum type){
    _followerController = controller;
    _followerTabBar = type;
    notifyListeners();
    _followerController!.jumpToPage(type.index);
  }

  //設定選中項目
  void setTabBar(TabBarEnum value){
    if(_tabBar != value){
      _tabBar = value;
      notifyListeners();
      _controller!.animateToPage(value.index, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  void setFollowerTabBar(FollowerTabBarEnum value){
    if(_followerTabBar != value){
      _followerTabBar = value;
      notifyListeners();
      _followerController!.animateToPage(value.index, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  //滑動換頁
  void onPageChanged(int index){
    _tabBar = TabBarEnum.values[index];
    notifyListeners();
  }

  void onFollowerPageChanged(int index){
    _followerTabBar = FollowerTabBarEnum.values[index];
    notifyListeners();
  }
}