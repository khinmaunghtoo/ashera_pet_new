import 'package:ashera_pet_new/model/member_pet.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';

import '../../enum/gender.dart';
import '../../enum/health_status.dart';
import '../../utils/app_color.dart';
import '../../utils/app_image.dart';

class RankingPetCardData extends StatelessWidget {
  final MemberPetModel pet;
  final int count;
  const RankingPetCardData({super.key, required this.pet, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        children: [
          Row(
            children: [
              //animalType name
              Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //animalType
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Colors.transparent),
                        child: const Image(
                          width: 35,
                          image: AssetImage(AppImage
                              .iconCollarUnBound /*pet.animalType == AnimalType.cat.index ? AppImage.iconCatFill : AppImage.iconDogFill*/),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      //name
                      Flexible(
                          child: Text(
                        pet.nickname,
                        style: const TextStyle(
                            color: AppColor.textFieldTitle,
                            fontSize: 16,
                            height: 1.1),
                      )),
                    ],
                  )),
              //like
              Expanded(
                  child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Spacer(),
                  const Icon(
                    BootstrapIcons.heart_fill,
                    color: Colors.redAccent,
                    size: 15,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    '$count',
                    style: const TextStyle(
                        color: AppColor.textFieldTitle,
                        fontSize: 14,
                        height: 1.1),
                  )
                ],
              ))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //gender
              Icon(
                GenderEnum.values[pet.gender].icon,
                size: 13,
                color: GenderEnum.values[pet.gender].color,
              ),
              Container(
                width: 8,
              ),
              //age
              Text(
                '${pet.age} Age',
                style: const TextStyle(
                    color: AppColor.textFieldTitle, fontSize: 14, height: 1.1),
              ),
              const Spacer(),
              //petStatus
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: HealthStatus.values[pet.healthStatus].color,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                        color: HealthStatus.values[pet.healthStatus].color,
                        width: 1)),
                child: Text(
                  HealthStatus.values[pet.healthStatus].zh,
                  style: const TextStyle(
                      fontSize: 14,
                      color: Colors
                          .white /*HealthStatus.values[pet.healthStatus].color*/
                      ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
