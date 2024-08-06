import 'package:ashera_pet_new/enum/chat_setting.dart';
import 'package:ashera_pet_new/widget/back_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_color.dart';
import '../../utils/utils.dart';
import '../../view_model/member.dart';
import '../button.dart';

class RoomTitle extends StatelessWidget {
  final VoidCallback callback;
  final VoidCallback userNameOnTap;
  final VoidCallback adoptRecordOnTap;
  final Function(ChatSetting) menuCallback;
  final String title;
  final int id;
  final bool isShowReport;
  const RoomTitle(
      {super.key,
      required this.callback,
      required this.title,
      required this.id,
      required this.menuCallback,
      required this.userNameOnTap,
      required this.adoptRecordOnTap,
      this.isShowReport = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      height: Utils.appBarHeight,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: AppColor.textFieldUnSelect),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: TopBackButton(
            alignment: Alignment.centerLeft,
            callback: callback,
          )),
          Row(
            children: [
              Consumer<MemberVm>(
                builder: (context, vm, _) {
                  if (vm.targetMemberWarnings
                      .where((e) => e.targetMemberId == id && e.warning == true)
                      .isNotEmpty) {
                    return yellowButton(25, () {});
                  } else {
                    return Container();
                  }
                },
              ),
              const SizedBox(
                width: 5,
              ),
              GestureDetector(
                onTap: userNameOnTap,
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20,
                      color: AppColor.textFieldTitle,
                      height: 1.1),
                ),
              ),
            ],
          ),
          Expanded(
              child: Container(
            alignment: Alignment.centerRight,
            child: PopupMenuButton<ChatSetting>(
              offset: const Offset(0, 55),
              icon: Icon(
                Icons.adaptive.more,
                color: AppColor.textFieldTitle,
              ),
              color: Colors.black,
              onSelected: menuCallback,
              itemBuilder: (context) => [
                PopupMenuItem<ChatSetting>(
                    value: ChatSetting.photosAndVideos,
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.image_outlined,
                          size: 20,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          ChatSetting.photosAndVideos.zh,
                          style: const TextStyle(height: 1.1),
                        )
                      ],
                    )),
                PopupMenuItem<ChatSetting>(
                    value: ChatSetting.blacklist,
                    height: 35,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.do_disturb,
                          size: 20,
                          color: Colors.white,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          ChatSetting.blacklist.zh,
                          style: const TextStyle(height: 1.1),
                        )
                      ],
                    )),
                if (isShowReport)
                  PopupMenuItem<ChatSetting>(
                      value: ChatSetting.report,
                      height: 35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.report_outlined,
                            size: 20,
                            color: Colors.white,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            ChatSetting.report.zh,
                            style: const TextStyle(height: 1.1),
                          )
                        ],
                      )),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
