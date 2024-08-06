import 'package:flutter/material.dart';

import '../../utils/app_color.dart';
import '../../widget/chat/body.dart';
import '../../widget/chat/title.dart';


// chat page, 聊天頁面
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<StatefulWidget> createState() => _ChatPageState();
}

// AutomaticKeepAliveClientMixin 保持頁面狀態
class _ChatPageState extends State<ChatPage> with AutomaticKeepAliveClientMixin{
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.appBackground,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: const Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //title
                ChatTitleBar(),
                Expanded(child: ChatBody()),
              ],
            ),
          );
        },
      ),
    );
  }
}
