import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../utils/app_color.dart';
import '../../widget/identification_record/body.dart';
import '../../widget/identification_record/title.dart';

class IdentificationRecord extends StatefulWidget{
  const IdentificationRecord({super.key});

  @override
  State<StatefulWidget> createState() => _IdentificationRecordState();
}

class _IdentificationRecordState extends State<IdentificationRecord>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColor.appBackground,
      body: LayoutBuilder(builder: (context, constraints){
        return SizedBox(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //title
              IdentificationRecordTitle(
                callback: _back
              ),
              const Expanded(child: IdentificationRecordBody())
            ],
          ),
        );
      },),
    );
  }

  //返回
  void _back(){
    context.pop();
  }
}