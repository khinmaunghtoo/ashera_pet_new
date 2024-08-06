import 'package:flutter/material.dart';

import '../utils/app_color.dart';
import '../utils/app_image.dart';

class ComplaintSuccessAlert extends StatefulWidget{
  const ComplaintSuccessAlert({super.key});

  @override
  State<StatefulWidget> createState() => _ComplaintSuccessAlertState();
}

class _ComplaintSuccessAlertState extends State<ComplaintSuccessAlert>{


  @override
  void initState() {
    super.initState();
    Future.delayed( const Duration(milliseconds: 3000), (){
      if(mounted){
        if(Navigator.of(context).canPop()){
          Navigator.of(context).pop();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 370,
      height: 500,
      decoration: BoxDecoration(
          color: AppColor.itemBackgroundColor,
          borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          //title
          Container(
            height: 50,
            alignment: Alignment.center,
            child: const Text(
              '檢舉',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
          Container(
            height: 1,
            color: AppColor.dialogLineColor,
          ),
          //body
          Expanded(
              child: _body()
          ),
          //button
          _button(),
          const SizedBox(height: 30,)
        ],
      ),
    );
  }

  Widget _body(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //image
        const SizedBox(
          width: 50,
          height: 50,
          child: Image(
            image: AssetImage(
              AppImage.iconConfirm
            ),
          ),
        ),
        const SizedBox(height: 20),
        //感謝您的檢舉 size 20
        Container(
          height: 45,
          alignment: Alignment.center,
          child: const Text(
            '感謝您的檢舉',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20
            ),
          ),
        ),
        const SizedBox(height: 30),
        //我們將審查您的檢舉內容，若確實存在違反
        //《社群自律公約》的行為，我們將採取適當行動。 size 16
        Container(
          height: 45,
          alignment: Alignment.center,
          child: const Text(
            '我們將審查您的檢舉內容，若確實存在違反\n《社群自律公約》的行為，我們將採取適當行動。',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,

            ),
          ),
        )
      ],
    );
  }
  
  Widget _button(){
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 90),
        decoration: BoxDecoration(
            color: AppColor.button,
            borderRadius: BorderRadius.circular(5)
        ),
        child: const Text(
          '確認',
          style: TextStyle(
              color: Colors.white,
              fontSize: 16
          ),
        ),
      ),
    );
  }
}