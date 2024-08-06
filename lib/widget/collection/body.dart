import 'package:ashera_pet_new/model/member_pet_like.dart';
import 'package:ashera_pet_new/view_model/kanban.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../assist_in_pet_hunting/item.dart';

class CollectionBody extends StatefulWidget {
  const CollectionBody({super.key});

  @override
  State<StatefulWidget> createState() => _CollectionBodyState();
}

class _CollectionBodyState extends State<CollectionBody> {
  KanBanVm? _kanBanVm;

  @override
  Widget build(BuildContext context) {
    _kanBanVm = Provider.of<KanBanVm>(context);
    return Container(
      alignment: Alignment.center,
      child: Selector<KanBanVm, List<MemberPetLikeModel>>(
        builder: (context, value, child) {
          if (value.isNotEmpty) {
            return GridView.builder(
              padding: EdgeInsets.zero,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 0),
              itemBuilder: (context, index) => SearchPetItem(
                  pet: _kanBanVm!.pets
                      .where(
                          (element) => element.id == value[index].memberPetId)
                      .first,
                  isShowCollection: false),
              itemCount: value.length,
              addAutomaticKeepAlives: true,
            );
          } else {
            return _noData();
          }
        },
        selector: (_, data) => data.collectionList,
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
            BootstrapIcons.bookmark,
            color: Colors.white,
            size: 50,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            '沒有收藏',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
