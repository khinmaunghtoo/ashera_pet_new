import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/material.dart';

import '../../model/faces_detect_history.dart';

class RecordItem extends StatelessWidget {
  final FacesDetectHistoryModel data;

  const RecordItem({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: AppColor.textFieldUnSelect),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //頭像
          /*Container(
            padding: const EdgeInsets.only(right: 10),
            child: Avatar.medium(user: data.userData),
          ),*/
          //名稱&性別&地址
          Expanded(
              child: Column(
            children: [
              //名稱&性別
              _nameAndGender(),
              const SizedBox(
                height: 5,
              ),
              //地址
              _address()
            ],
          )),
          Column(
            children: [
              //時間
              _time(),
              const SizedBox(
                height: 15,
              ),
            ],
          )
        ],
      ),
    );
  }

  //名稱&性別
  Widget _nameAndGender() {
    return Row(
      children: [
        //名稱
        Container(
          alignment: Alignment.centerLeft,
          child: const Text(
            //data.userData.nickname,
            'nickname',
            style: TextStyle(
                color: AppColor.textFieldTitle,
                fontSize: 16,
                fontWeight: FontWeight.w500),
          ),
        ),
        //性別icon
        //Utils.genderIcon(data.userData.gender)
      ],
    );
  }

  //地址
  Widget _address() {
    return Row(
      children: [
        const Icon(
          Icons.location_on_outlined,
          color: AppColor.textFieldTitle,
          size: 14,
        ),
        Expanded(
            child: Container(
          alignment: Alignment.centerLeft,
          child: Text(
            data.address,
            style:
                const TextStyle(color: AppColor.textFieldTitle, fontSize: 12),
          ),
        ))
      ],
    );
  }

  //時間
  Widget _time() {
    return Container(
      alignment: Alignment.topCenter,
      child: const Text(
        'data.time',
        style: TextStyle(color: AppColor.textFieldHintText, fontSize: 12),
      ),
    );
  }
}
