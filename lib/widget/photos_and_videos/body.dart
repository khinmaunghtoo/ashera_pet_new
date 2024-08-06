import 'package:ashera_pet_new/view_model/photos_and_videos.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/message.dart';
import 'item.dart';

class PhotosAndVideosBody extends StatefulWidget {
  const PhotosAndVideosBody({super.key});

  @override
  State<StatefulWidget> createState() => _PhotosAndVideosBodyState();
}

class _PhotosAndVideosBodyState extends State<PhotosAndVideosBody> {
  @override
  Widget build(BuildContext context) {
    return Consumer<PhotosAndVideosVm>(
      builder: (context, vm, _) {
        if (vm.grouped.isEmpty) {
          return Container(
            alignment: Alignment.center,
            child: const Text(
              '無圖片與影片紀錄',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
        } else {
          return ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: vm.grouped.keys.length,
              itemBuilder: (context, index) {
                String date = vm.grouped.keys.toList()[index];
                List<MessageModel> messages = vm.grouped[date]!;
                return PhotosAndVideosItem(
                  date: date,
                  messages: messages,
                );
              });
        }
      },
    );
  }
}
