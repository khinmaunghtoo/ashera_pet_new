import 'package:ashera_pet_new/model/member.dart';
import 'package:ashera_pet_new/model/member_pet.dart';
import 'package:ashera_pet_new/routes/route_name.dart';
import 'package:ashera_pet_new/widget/time_line/app_widget/avatars.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../model/face_detect.dart';
import '../../model/tuple.dart';
import '../../utils/api.dart';
import '../../utils/app_color.dart';
import '../../utils/app_image.dart';
import '../button.dart';

class IdentificationListItem extends StatefulWidget {
  final FaceDetectResponseModel data;
  const IdentificationListItem({super.key, required this.data});

  @override
  State<StatefulWidget> createState() => _IdentificationListItemState();
}

class _IdentificationListItemState extends State<IdentificationListItem> {
  FaceDetectResponseModel get data => widget.data;

  late Future<MemberPetModel> _pet;

  Future<MemberPetModel> getPet(int memberPetId) async {
    Tuple<bool, String> r = await Api.getPet(memberPetId);
    return MemberPetModel.fromJson(r.i2!);
  }

  @override
  void initState() {
    super.initState();
    _pet = getPet(data.memberPetId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
          color: AppColor.textFieldUnSelect,
          borderRadius: BorderRadius.circular(10)),
      child: FutureBuilder(
        future: _pet,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: () => _jumpToResult(snapshot.data!),
                child: Stack(
                  alignment: Alignment.center,
                  fit: StackFit.expand,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //大頭照
                        Avatar.big(
                            user: MemberModel.fromMap(snapshot.data!.toMap())),
                        const SizedBox(
                          height: 10,
                        ),
                        //名字
                        Text(
                          snapshot.data!.nickname,
                          style: const TextStyle(
                              fontSize: 16, color: AppColor.textFieldTitle),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: blueRectangleButton(
                              '相似度 ${getSimilarity(data.similarity).toStringAsFixed(0)}%',
                              () {}),
                        )
                      ],
                    ),
                    if (getSimilarity(data.similarity) >= 60)
                      const Positioned(
                          right: 5,
                          top: 5,
                          child: Image(
                            width: 30,
                            height: 30,
                            image: AssetImage(
                              AppImage.imgSimilar,
                            ),
                          )),
                  ],
                ),
              );
            default:
              return Container();
          }
        },
      ),
    );
  }

  double getSimilarity(double similarity) {
    if (similarity >= 95) {
      return similarity * 100;
    }
    return (similarity * 100) + 5;
  }

  void _jumpToResult(MemberPetModel pet) {
    context.push(RouteName.identificationResult, extra: pet);
  }
}
