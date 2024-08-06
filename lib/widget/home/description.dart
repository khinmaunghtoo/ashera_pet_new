import 'package:flutter/cupertino.dart';

import '../../model/post.dart';
import '../../utils/app_color.dart';

///文章內容
class Description extends StatelessWidget{
  final PostModel postCardData;

  const Description({
    super.key,
    required this.postCardData
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Text.rich(
          TextSpan(
              children: [
                TextSpan(
                    text: postCardData.member!.nickname,
                    style: const TextStyle(
                        color: AppColor.textFieldTitle,
                        fontWeight: FontWeight.w500,
                        fontSize: 14
                    )
                ),
                const TextSpan(text: ' '),
                TextSpan(
                    text: postCardData.body,
                    style: const TextStyle(
                        color: AppColor.textFieldHintText
                    )
                )
              ]
          )
      ),
    );
  }
}