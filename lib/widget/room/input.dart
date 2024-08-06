import 'dart:developer';
import 'dart:io';

import 'package:ashera_pet_new/data/blacklist.dart';
import 'package:ashera_pet_new/data/member.dart';
import 'package:ashera_pet_new/enum/message_type.dart';
import 'package:ashera_pet_new/enum/photo_type.dart';
import 'package:ashera_pet_new/model/member.dart';
import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/utils/shared_preference.dart';
import 'package:ashera_pet_new/view_model/message_controller.dart';
import 'package:ashera_pet_new/widget/room/send_button.dart';
import 'package:ashera_pet_new/widget/text_field.dart';
import 'package:flutter/material.dart';
// import 'package:image_pickers/image_pickers.dart';
import 'package:provider/provider.dart';

import '../../dialog/cupertion_alert.dart';
import '../../model/tuple.dart';
import '../../utils/api.dart';
import '../../view_model/room_input.dart';

class RoomInput extends StatefulWidget {
  final MemberModel userData;
  const RoomInput({super.key, required this.userData});

  @override
  State<StatefulWidget> createState() => _RoomInputState();
}

class _RoomInputState extends State<RoomInput> {
  MemberModel get userData => widget.userData;
  RoomInputVm? _inputVm;
  MessageControllerVm? _messageControllerVm;
  late MemberModel other;
  final TextEditingController _input = TextEditingController();
  final FocusNode focusNodeInput = FocusNode();

  _onLayoutDone(_) {
    _inputVm!.init(focusNodeInput, _input);
  }

  void _uploadFile(File file, PhotoType type) async {
    Tuple<bool, String> r = await _messageControllerVm!
        .uploadFileToSQL(Member.memberModel.name, file.path, type);
    if (r.i1!) {
      _messageControllerVm!.addMsg(other, r.i2!,
          type == PhotoType.image ? MessageType.PIC : MessageType.VIDEO);
    }
  }

  @override
  void initState() {
    super.initState();
    _getOther();
    _getSendRecord();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
    focusNodeInput.addListener(_listener);
  }

  void _getSendRecord() async {
    String record = await SharedPreferenceUtil.readSendRecord('${userData.id}');
    _input.text = record;
  }

  void _getOther() async {
    Tuple<bool, String> r = await Api.getMemberData(userData.id);
    if (r.i1!) {
      other = MemberModel.fromJson(r.i2!);
    }
  }

  @override
  void dispose() {
    SharedPreferenceUtil.saveSendRecord('${userData.id}', _input.text);
    _inputVm!.disposeFocus();
    focusNodeInput.removeListener(_listener);
    super.dispose();
  }

  void _listener() async {
    log('focusNodeInput: ${focusNodeInput.hasFocus}');
    if (focusNodeInput.hasFocus) {
      _messageControllerVm!.jumpBottom();
    } else {
      _messageControllerVm!.jumpBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    _inputVm = Provider.of<RoomInputVm>(context, listen: false);
    _messageControllerVm =
        Provider.of<MessageControllerVm>(context, listen: false);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: const BoxDecoration(color: AppColor.textFieldUnSelect),
      child: Row(
        children: [
          //圖片
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: GestureDetector(
              // onTap: () => _selectImage(GalleryMode.image),
              child: const Icon(
                Icons.image_outlined,
                size: 30,
                color: AppColor.textFieldHintText,
              ),
            ),
          ),
          //影片
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: GestureDetector(
              // onTap: () => _selectImage(GalleryMode.video),
              child: const Icon(
                Icons.movie_creation_outlined,
                size: 30,
                color: AppColor.textFieldHintText,
              ),
            ),
          ),
          //輸入框
          Expanded(
              child: ChatTextField(
            readOnly: BlackList.blacklist
                    .where((element) => element.targetMemberId == userData.id)
                    .isNotEmpty
                ? true
                : false,
            controller: _input,
            focusNode: focusNodeInput,
            hintText: BlackList.blacklist
                    .where((element) => element.targetMemberId == userData.id)
                    .isNotEmpty
                ? '對方已被你加入黑名單'
                : '輸入訊息...',
          )),
          const SizedBox(
            width: 5,
          ),
          //發送
          SendButton(
            input: _input,
            userData: userData,
          )
        ],
      ),
    );
  }

  // void _selectImage(GalleryMode mode) async {
  //   //判斷是否有加入黑名單
  //   if (BlackList.blacklist
  //       .where((element) => element.targetMemberId == userData.id)
  //       .isNotEmpty) {
  //     await _showAlert('對方已被你加入黑名單');
  //     return;
  //   }
  //   List<Media>? media = await ImagePickers.pickerPaths(
  //       galleryMode: mode,
  //       showCamera: false,
  //       showGif: false,
  //       selectCount: 1,
  //       cropConfig: CropConfig(enableCrop: false, height: 2, width: 2),
  //       compressSize: 500,
  //       uiConfig: UIConfig(uiThemeColor: AppColor.appBackground));
  //   if (media.isNotEmpty) {
  //     _uploadFile(File(media.first.path!),
  //         mode == GalleryMode.image ? PhotoType.image : PhotoType.video);
  //   }
  // }

  Future<bool> _showAlert(String text) async {
    Future.delayed(const Duration(milliseconds: 1800),
        () => Navigator.of(context).pop(true));
    return await showCupertinoAlert(
        context: context, content: text, cancel: false, confirmation: false);
  }
}
