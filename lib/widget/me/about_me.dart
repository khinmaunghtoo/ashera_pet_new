import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rf_expand_collapse_text/rf_expand_collapse_text.dart';

import '../../data/member.dart';
import '../../utils/app_color.dart';
import '../../view_model/about_us.dart';
import '../../view_model/member.dart';

class MeAbout extends StatelessWidget{
  const MeAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints){
      return Consumer2<MemberVm,AboutUsVm>(builder: (context, vm, vm1, _){
        final span = TextSpan(text: Member.memberModel.aboutMe, style: const TextStyle(fontSize: 14, color: AppColor.textFieldTitle));
        final tp = TextPainter(text: span, textDirection: TextDirection.ltr);
        tp.layout(maxWidth: constraints.maxWidth);
        final numLines = tp.computeLineMetrics().length;
        log('幾行：$numLines');
        log('已經展開了？${vm1.isOpen}');
        return Container(
          height: vm1.isOpen ? _getNoOpenLinesHeight(numLines) : _getIsOpenLinesHeight(numLines),
          width: constraints.maxWidth,
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: RFExpandCollapseText(
              text: Member.memberModel.aboutMe,
              textStyle: const TextStyle(fontSize: 14, color: AppColor.textFieldTitle),
              expandStr: ' 更多',
              collapseStr: ' 收起',
              expandOrCollapseStyle: const TextStyle(fontSize: 14, color: AppColor.textFieldUnSelectBorder),
              maxLines: 2,
              onChangeExpandStatus: (value) => vm1.setAboutStatus(value),
            ),
          ),
        );
      });
    });
  }

  double _getIsOpenLinesHeight(int numLines){
    switch(numLines){
      case 1:
        return 25;
      case 2:
        return 40;
      case 3:
        return 60;
      case 4:
        return 80;
      case 5:
        return 100;
      case 6:
        return 120;
      case 7:
        return 140;
      case 8:
        return 160;
      case 9:
        return 180;
      case 10:
        return 200;
      case >10:
        return 200;
      default:
        return 25;
    }
  }

  double _getNoOpenLinesHeight(int numLines){
    switch(numLines){
      case 1:
        return 25;
      case 2:
        return 40;
      case 3:
        return 40;
      case 4:
        return 40;
      case 5:
        return 40;
      case 6:
        return 40;
      case 7:
        return 40;
      case 8:
        return 40;
      case 9:
        return 40;
      case 10:
        return 40;
      case >10:
        return 40;
      default:
        return 25;
    }
  }
}