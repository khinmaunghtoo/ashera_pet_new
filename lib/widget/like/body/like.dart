import 'dart:developer';

import 'package:ashera_pet_new/model/member_pet_like.dart';
import 'package:ashera_pet_new/view_model/kanban.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../item.dart';

//我點別人
class Like extends StatelessWidget {
  const Like({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Selector<KanBanVm, List<MemberPetLikeModel>>(
        builder: (context, value, child) {
          if (value.isNotEmpty) {
            return ListView.builder(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                log('Like: ${value[index].toMap()}');
                return LikeItem(
                  model: value[index],
                  isBeLike: false,
                );
              },
              itemCount: value.length,
              addAutomaticKeepAlives: true,
            );
          } else {
            return _noData();
          }
        },
        selector: (_, data) => data.meLikes,
        shouldRebuild: (m1, m2) {
          return m1.length != m2.length;
        },
      ),
    );
  }

  Widget _noData() {
    return Container(
      alignment: Alignment.center,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            BootstrapIcons.heart,
            color: Colors.white,
            size: 50,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '沒有點贊',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
