import 'package:ashera_pet_new/utils/app_image.dart';

enum BottomTab { home, chat, kanban, ranking, me }

extension BottomBarExtension on BottomTab {
  static List<String?> icons = [
    AppImage.tabBarHome,
    AppImage.tabBarChat,
    null,
    AppImage.tabBarRank,
    AppImage.tabBarMe
  ];

  static List<String?> iconsPressed = [
    AppImage.tabBarHomePressed,
    AppImage.tabBarChatPressed,
    null,
    AppImage.tabBarRankPressed,
    AppImage.tabBarMePressed
  ];

  static List<String?> zhs = ['首頁', '聊天', null, '排行', '設定'];
  String? get zh => zhs[index];
  String? get icon => icons[index];
  String? get iconPressed => iconsPressed[index];
}
