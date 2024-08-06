//照片及影片
//加入黑名單
enum ChatSetting{
  photosAndVideos,
  blacklist,
  //檢舉
  report,
}
extension ChatSettingExtension on ChatSetting{
  static List<String> zhs = [
    '照片及影片',
    '加入黑名單',
    '檢舉'
  ];
  String get zh => zhs[index];
}