import 'message.dart';

class ListPhotoViewerModel{
  final int id;
  final List<MessageModel> messages;

  const ListPhotoViewerModel({required this.id, required this.messages});
}