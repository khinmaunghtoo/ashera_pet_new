import 'package:ashera_pet_new/view_model/comments_vm.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/post.dart';
import '../../../utils/app_color.dart';

class BoxDone extends StatefulWidget {
  final TextEditingController comment;
  final PostModel cardData;
  const BoxDone({super.key, required this.cardData, required this.comment});

  @override
  State<StatefulWidget> createState() => _BoxDoneState();
}

class _BoxDoneState extends State<BoxDone> {
  TextEditingController get comment => widget.comment;
  PostModel get cardData => widget.cardData;

  @override
  void initState() {
    super.initState();
    comment.addListener(_listener);
  }

  void _listener() {
    setState(() {});
  }

  @override
  void dispose() {
    comment.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Consumer<CommentsVm>(
        builder: (context, vm, _) {
          return GestureDetector(
            onTap: () => _onTap(vm),
            child: Icon(
              Icons.near_me_sharp,
              color: comment.text.isEmpty
                  ? AppColor.textFieldHintText
                  : AppColor.button,
              size: 35,
            ),
          );
        },
      ),
    );
  }

  void _onTap(CommentsVm vm) {
    if (comment.text.isNotEmpty) {
      vm.addPostMessage(widget.cardData, comment.text);
      comment.clear();
    }
  }
}
