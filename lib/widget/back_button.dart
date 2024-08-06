import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/material.dart';

class TopBackButton extends StatelessWidget {
  final VoidCallback callback;
  final Alignment alignment;
  const TopBackButton(
      {super.key, required this.callback, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //behavior: HitTestBehavior.opaque,
      onTap: callback,
      child: Container(
        alignment: alignment,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: const Icon(
          Icons.arrow_back,
          color: AppColor.textFieldTitle,
          size: 35,
        ),
      ),
    );
  }
}

class TopCloseBackButton extends StatelessWidget {
  final VoidCallback callback;
  final Alignment alignment;
  const TopCloseBackButton(
      {super.key, required this.callback, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //behavior: HitTestBehavior.opaque,
      onTap: callback,
      child: Container(
        alignment: alignment,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: const Icon(
          Icons.close,
          color: AppColor.textFieldTitle,
          size: 35,
        ),
      ),
    );
  }
}

class TopNewPostButton extends StatelessWidget {
  final VoidCallback callback;
  final Alignment alignment;
  const TopNewPostButton(
      {super.key, required this.callback, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //behavior: HitTestBehavior.opaque,
      onTap: callback,
      child: Container(
        alignment: alignment,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: const Text(
          '發佈',
          style: TextStyle(color: AppColor.button, fontSize: 18, height: 1.1),
        ),
      ),
    );
  }
}

class TopCropImageButton extends StatelessWidget {
  final VoidCallback callback;
  final Alignment alignment;
  const TopCropImageButton(
      {super.key, required this.callback, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //behavior: HitTestBehavior.opaque,
      onTap: callback,
      child: Container(
        alignment: alignment,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: const Text(
          '裁切',
          style: TextStyle(color: AppColor.button, fontSize: 18, height: 1.1),
        ),
      ),
    );
  }
}

class TopDoneButton extends StatelessWidget {
  final VoidCallback callback;
  final Alignment alignment;
  const TopDoneButton(
      {super.key, required this.callback, required this.alignment});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      //behavior: HitTestBehavior.opaque,
      onTap: callback,
      child: Container(
        alignment: alignment,
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: const Text(
          '完成',
          style: TextStyle(color: AppColor.button, fontSize: 18, height: 1.1),
        ),
      ),
    );
  }
}
