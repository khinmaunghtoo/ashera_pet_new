import 'package:flutter/cupertino.dart';

import '../utils/app_image.dart';

class AsheraPetText extends StatelessWidget{
  const AsheraPetText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20),
      alignment: Alignment.centerLeft,
      child: const Image(
        width: 130,
        image: AssetImage(
          AppImage.imgAsheraPet
        ),
      )/* Text(
        'Ashera Pet',
        style: GoogleFonts.getFont(
            'Cookie',
            color: AppColor.textFieldTitle,
            fontSize: 31,
            height: 1.1,
            fontWeight: FontWeight.w500,
            letterSpacing: 1
        ),
      )*/,
    );
  }
}