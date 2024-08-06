import 'package:flutter/cupertino.dart';

class BoxEmoji extends StatelessWidget {
  final TextEditingController comment;
  const BoxEmoji({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _emojiText('❤️'),
          _emojiText('🙌'),
          _emojiText('🔥'),
          _emojiText('👏🏻'),
          _emojiText('😢'),
          _emojiText('😍'),
          _emojiText('😮'),
          _emojiText('😂'),
        ],
      ),
    );
  }

  Widget _emojiText(String emoji) {
    return GestureDetector(
      onTap: () {
        comment.text = comment.text + emoji;
        comment.selection = TextSelection.fromPosition(
            TextPosition(offset: comment.text.length));
      },
      child: Text(
        emoji,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}
