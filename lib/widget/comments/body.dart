import 'package:flutter/cupertino.dart';

import '../../model/post.dart';
import 'box/box.dart';
import 'description_and_comments.dart';

//留言
class CommentsBody extends StatefulWidget{
  final PostModel postCardData;
  const CommentsBody({super.key, required this.postCardData});

  @override
  State<StatefulWidget> createState() => _CommentsBodyState();
}

class _CommentsBodyState extends State<CommentsBody>{

  ScrollController controller = ScrollController();

  PostModel get cardData => widget.postCardData;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      return SizedBox(
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        child: Column(
          children: [
            //文章與留言
            Expanded(child: DescriptionAndComments(
              controller: controller,
              cardData: cardData,
            )),
            CommentBox(
              postCardData: cardData,
            )
          ],
        ),
      );
    },);
  }
}