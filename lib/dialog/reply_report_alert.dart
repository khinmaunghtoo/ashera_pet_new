import 'dart:developer';
import 'dart:isolate';

import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/view_model/adopt_report_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:provider/provider.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../data/auth.dart';
import '../enum/photo_type.dart';
import '../model/add_adopt_record_dto.dart';
import '../model/complaint_appeal_record.dart';
import '../model/tuple.dart';
import '../model/update_adopt_record_reply.dart';
import '../utils/api.dart';
import '../view_model/report_vm.dart';
import '../widget/new_post/image_picker.dart';
import '../widget/text_field.dart';
import 'cupertion_alert.dart';

class ReplyReportAlert extends StatefulWidget {
  final AdoptRecordModel dto;
  const ReplyReportAlert({super.key, required this.dto});

  @override
  State<StatefulWidget> createState() => _ReplyReportAlertState();
}

class _ReplyReportAlertState extends State<ReplyReportAlert> {
  AdoptRecordModel get dto => widget.dto;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  ReportVm? _reportVm;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    log('檢舉事由：');
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _reportVm = Provider.of<ReportVm>(context);
    return Container(
      width: 370,
      height: 550,
      decoration: BoxDecoration(
          color: AppColor.itemBackgroundColor,
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //title
          _title(),
          //line
          _line(),
          Expanded(
              child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //原因
                Consumer<AdoptReportVm>(
                  builder: (context, vm, _) {
                    return Text.rich(TextSpan(
                        text: '你已被其他用戶檢舉',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        children: [
                          TextSpan(
                              text: '《${vm.nowRecord.reason}》',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 18))
                        ]));
                  },
                ),
                //警告
                const Text(
                  '因此平台已先將你列入警示帳戶',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                //若有其他因素導致，可於下方回傳佐證給我們，我們將盡快為你審查
                const Text(
                  '若有其他因素導致，可於下方回傳佐證給我們，我們將盡快為你審查',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red, fontSize: 16),
                ),
                //Image
                _image(),
                //message
                _message(),
                //button
                _button(),
              ],
            ),
          ))
        ],
      ),
    );
  }

  Widget _title() {
    return SizedBox(
      width: 370,
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Container()),
          Expanded(
              child: Container(
            alignment: Alignment.center,
            child: const Text(
              '檢舉',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )),
          Expanded(
              child: Container(
            padding: const EdgeInsets.only(right: 10),
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: const Icon(
                Icons.close,
                size: 35,
              ),
            ),
          ))
        ],
      ),
    );
  }

  Widget _line() {
    return Container(
        height: 1, width: 370, color: AppColor.textFieldUnSelectBorder);
  }

  Widget _image() {
    return Container(
      width: 370,
      alignment: Alignment.centerLeft,
      child: Consumer<ReportVm>(
        builder: (context, vm, _) {
          if (vm.mediaList.isEmpty) {
            return GestureDetector(
              onTap: () async {
                List<AssetEntity>? result = await pickAssets();
                if (result != null) {
                  vm.setMediaList(result);
                }
              },
              child: Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3)),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            );
          }
          return SizedBox(
            width: 100,
            height: 100,
            child: Stack(
              alignment: Alignment.bottomLeft,
              children: [
                Container(
                  height: 90,
                  width: 90,
                  margin:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                  alignment: Alignment.center,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image(
                      fit: BoxFit.cover,
                      image: MemoryImage(vm.mediaList.first.thumbnailData!),
                    ),
                  ),
                ),
                Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () async {
                        bool r = await _isDeleteImage();
                        if (r) {
                          vm.deleteMediaList();
                        }
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 20,
                      ),
                    ))
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _message() {
    return CombinationTextField(
      title: '申訴內容',
      isRequired: false,
      child: ReportInputField(
        controller: _controller,
        focusNode: _focusNode,
      ),
    );
  }

  Widget _button() {
    return GestureDetector(
      onTap: () async {
        if (dto.pass) {
          log('上訴');
          if (!_isLoading) {
            _isLoading = true;
            SVProgressHUD.show();
            //上傳照片
            Tuple<bool, String> r = await _reportVm!.uploadFile(
                dto.fromMemberView.name,
                _reportVm!.mediaList.first.file!.path,
                PhotoType.report);
            await updateAppeal(r.i2!);
            SVProgressHUD.dismiss();
            _reportVm!.deleteMediaList();
            _isLoading = false;
            Navigator.of(context).pop();
          } else {
            _isLoading = false;
            SVProgressHUD.showError(status: '照片上傳失敗');
          }
          return;
        }
        if (_reportVm!.mediaList.isEmpty) {
          SVProgressHUD.showError(status: '請選擇照片');
          return;
        }
        if (_controller.text.trim().isEmpty) {
          SVProgressHUD.showError(status: '請輸入申訴內容');
          return;
        }

        if (!_isLoading) {
          _isLoading = true;
          SVProgressHUD.show();
          //上傳照片
          Tuple<bool, String> r = await _reportVm!.uploadFile(
              dto.fromMemberView.name,
              _reportVm!.mediaList.first.file!.path,
              PhotoType.report);
          if (r.i1!) {
            await update(r.i2!);
            SVProgressHUD.dismiss();
            _reportVm!.deleteMediaList();
            _isLoading = false;
            Navigator.of(context).pop();
          } else {
            _isLoading = false;
            SVProgressHUD.showError(status: '照片上傳失敗');
          }
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 90),
        decoration: BoxDecoration(
            color: AppColor.button, borderRadius: BorderRadius.circular(5)),
        child: const Text(
          '送出',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  //上訴
  Future<Tuple<bool, String>> updateAppeal(String fileName) async {
    String token = Auth.userLoginResDTO.body.token;
    ComplaintAppealRecordModel uploadDto = ComplaintAppealRecordModel(
        complaintRecordId: dto.id,
        fromMemberId: dto.fromMemberView.id,
        targetMemberId: dto.targetMemberView.id,
        reply: _controller.text,
        replyPics: fileName);
    Tuple<bool, String> r =
        await Isolate.run(() => postComplaintAppealRecord(uploadDto, token));
    return r;
  }

  Future<Tuple<bool, String>> update(String fileName) async {
    String token = Auth.userLoginResDTO.body.token;
    UpdateAdoptRecordReplyDTO uploadDto = UpdateAdoptRecordReplyDTO(
        id: dto.id,
        fromMember: dto.fromMemberView.name,
        targetMember: dto.targetMemberView.name,
        reply: _controller.text,
        replyPics: fileName);
    Tuple<bool, String> r =
        await Isolate.run(() => putComplaintRecord(uploadDto, token));
    return r;
  }

  Future<List<AssetEntity>?> pickAssets() async {
    late PermissionState ps;
    try {
      ps = await AssetPicker.permissionCheck();
    } catch (e) {
      ps = PermissionState.denied;
    }
    if (ps == PermissionState.denied) {
      if (mounted) {
        await showCupertinoAlert(
          title: '提示',
          content: '請至設定開啟相簿權限',
          context: context,
          cancel: false,
          confirmation: true,
        );
      }
      return null;
    }

    const int maxAssets = 1;
    late final ThemeData theme = AssetPicker.themeData(AppColor.appBackground);

    // use always same provider for `keepScrollOffset`
    late final DefaultAssetPickerProvider provider = DefaultAssetPickerProvider(
      maxAssets: maxAssets,
      requestType: RequestType.image,
    );

    final InstaAssetPickerBuilder builder = InstaAssetPickerBuilder(
      provider: provider,
      initialPermission: ps,
      pickerTheme: theme,
      keepScrollOffset: false,
      locale: const Locale('zh', 'TW'),
    );
    if (context.mounted) {
      return await AssetPicker.pickAssetsWithDelegate(
        context,
        delegate: builder,
      );
    }
    return null;
  }

  Future<bool> _isDeleteImage() async {
    return await showCupertinoAlert(
        context: context,
        title: '刪除',
        content: '確認要刪除此相片？',
        cancel: true,
        confirmation: true);
  }
}
