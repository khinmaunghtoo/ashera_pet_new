import 'dart:developer';

import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/view_model/message_controller.dart';
import 'package:ashera_pet_new/view_model/room_input.dart';
import 'package:ashera_pet_new/widget/room/bubble/message_bubble.dart';
import 'package:ashera_pet_new/widget/room/pet_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_pro/pull_to_refresh_pro.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../enum/message_type.dart';
import '../../model/member.dart';
import '../../model/message.dart';
import '../../utils/utils.dart';
import 'chat_ui/chat_pic.dart';
import 'chat_ui/chat_text.dart';
import 'chat_ui/chat_video.dart';

class RoomBody extends StatefulWidget {
  final MemberModel member;
  const RoomBody({super.key, required this.member});

  @override
  State<StatefulWidget> createState() => _RoomBodyState();
}

class _RoomBodyState extends State<RoomBody> {
  RoomInputVm? _inputVm;
  MessageControllerVm? _messageControllerVm;
  MemberModel get member => widget.member;

  ScrollController controller = ScrollController();
  ItemScrollController itemScrollController = ItemScrollController();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  _onLayoutDone(_) {
    _inputVm!.initScrollController(controller);
    _messageControllerVm!.setScrollController(controller);
    _messageControllerVm!.setItemScrollController(itemScrollController);
  }

  void _onRefresh() async {
    log('onRefresh');
    await _messageControllerVm!.setOffset();
    _refreshController.refreshCompleted(resetFooterState: false);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _inputVm = Provider.of<RoomInputVm>(context, listen: false);
    _messageControllerVm =
        Provider.of<MessageControllerVm>(context, listen: false);
    return Selector<MessageControllerVm, Map<String, List<MessageModel>>>(
      selector: (context, msgMap) => msgMap.grouped,
      shouldRebuild: (pro, next) => pro != next,
      builder: (context, groups, _) {
        return Column(
          children: [
            Consumer<MessageControllerVm>(
              builder: (context, vm, _) {
                return Visibility(
                  visible: vm.petLists.isNotEmpty,
                  child: ChatRoomPetData(
                    currentIndex: vm.petLists.length - 1,
                  ),
                );
              },
            ),
            Expanded(
                child: SmartRefresher(
              header: const ClassicHeader(
                refreshingText: '刷新中',
                releaseText: '放開刷新',
                completeText: '完成',
                failedText: '失敗',
                idleText: '載入更多',
              ),
              controller: _refreshController,
              onRefresh: _onRefresh,
              enablePullDown: true,
              enablePullUp: false,
              child: ListView.builder(
                  controller: controller,
                  physics: const ClampingScrollPhysics(),
                  itemCount: groups.keys.length,
                  itemBuilder: (context, index) {
                    String date = groups.keys.toList()[index];
                    List<MessageModel> messages = groups[date]!;
                    //已讀
                    if (!messages.last.isMine && messages.last.isRead == 0) {
                      log('已讀：${messages.last}');
                      _messageControllerVm!.isRead(messages.last);
                    }
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 80,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: AppColor.textFieldUnSelect),
                          child: Text(
                            date,
                            style:
                                const TextStyle(color: AppColor.textFieldTitle),
                          ),
                        ),
                        Flexible(
                            fit: FlexFit.loose,
                            child: ScrollablePositionedList.builder(
                                padding: EdgeInsets.zero,
                                addAutomaticKeepAlives: true,
                                addSemanticIndexes: true,
                                addRepaintBoundaries: true,
                                shrinkWrap: true,
                                reverse: false,
                                physics: const ClampingScrollPhysics(),
                                itemScrollController:
                                    index == 0 ? itemScrollController : null,
                                itemCount: messages.length,
                                itemBuilder: (context, index) {
                                  return MessageBubble(
                                    member: member,
                                    showAvatar: Utils.topIsMe(
                                        messages, messages[index]),
                                    message: messages[index],
                                    padding: _getPadding(messages[index]),
                                    child: _data(messages[index]),
                                  );
                                }))
                      ],
                    );
                  }),
            ))
          ],
        );
      },
    );
  }

  Widget _data(MessageModel value) {
    switch (value.type) {
      case MessageType.TEXT:
        return ChatTextWidget(
          key: ValueKey('${value.id}'),
          content: value.content,
        );
      case MessageType.AUDIO:
        return Container();
      case MessageType.VIDEO:
        return ChatVideoWidget(
          key: ValueKey('${value.id}'),
          id: value.id,
          url: value.content,
        );
      case MessageType.PIC:
        return ChatPicWidget(
            key: ValueKey('${value.id}'), id: value.id, pic: value.content);
      case MessageType.VIDEO_CALL:
        return Container();
      case MessageType.VOICE_CALL:
        return Container();
    }
  }

  EdgeInsetsGeometry _getPadding(MessageModel value) {
    switch (value.type) {
      case MessageType.TEXT:
        return const EdgeInsets.all(12.0);
      case MessageType.AUDIO:
        return const EdgeInsets.all(12.0);
      case MessageType.VIDEO:
        return const EdgeInsets.all(0);
      case MessageType.PIC:
        return const EdgeInsets.all(0);
      case MessageType.VIDEO_CALL:
        return const EdgeInsets.all(12.0);
      case MessageType.VOICE_CALL:
        return const EdgeInsets.all(12.0);
    }
  }
}
