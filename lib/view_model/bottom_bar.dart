import 'package:flutter/material.dart';

import '../enum/bottom_bar.dart';

//* 底部導航欄的Tabs provider
// 管理tabs的狀態
// 配合 Pagecontroller 來切換page view
// 配合 ScrollController 來控制滑動
class BottomBarVm with ChangeNotifier {

  // PageController
  PageController? _controller;
  PageController get pageController => _controller!;

  // ScrollController
  ScrollController? _scrollController;

  //選到的項目
  BottomTab _selectedTab = BottomTab.home;
  BottomTab get selectedTab => _selectedTab;

  // 設定主頁的ScrollController
  void setHomeScrollController(ScrollController controller) {
    _scrollController = controller;
  }

  // 設定PageController
  void setPageController(PageController controller) {
    _controller = controller;
    _selectedTab = BottomTab.home;
    notifyListeners();
  }

  void _setScrollController() {
    if (_scrollController != null) {
      if (_scrollController!.position.pixels != 0) {
        _scrollController!.animateTo(0.0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.decelerate);
      }
    }
  }

  //設定底部選中項目
  void setBottomBar(BottomTab value) {
    if (value == BottomTab.home) {
      _setScrollController();
    }
    if (_selectedTab != value) {
      _selectedTab = value;
      notifyListeners();
      _controller!.animateToPage(value.index,
          duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
    }
  }

  //滑動換頁
  void onPageChanged(int index) {
    _selectedTab = BottomTab.values[index];
    notifyListeners();
  }
}
