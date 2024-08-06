import 'package:flutter/cupertino.dart';

Future<bool> showCupertinoAlert({
  required BuildContext context,
  String? title,
  String? content,
  required bool cancel,
  required bool confirmation,
}) async {
  return await showCupertinoModalPopup(
          context: context,
          barrierDismissible: false,
          builder: (context) => CupertinoAlertDialog(
                insetAnimationDuration: const Duration(milliseconds: 1500),
                insetAnimationCurve: Curves.easeInCirc,
                title: title != null
                    ? Text(
                        title,
                        style: const TextStyle(fontSize: 16),
                      )
                    : null,
                content: content != null
                    ? Text(
                        content,
                        style: const TextStyle(fontSize: 16),
                      )
                    : null,
                actions: [
                  if (cancel)
                    CupertinoDialogAction(
                      isDefaultAction: false,
                      child: const Text('取消'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  if (confirmation)
                    CupertinoDialogAction(
                      isDestructiveAction: true,
                      child: const Text('確認'),
                      onPressed: () => Navigator.of(context).pop(true),
                    )
                ],
              )) ??
      true;
}
