import 'package:flutter/cupertino.dart';

import '../../model/member_pet.dart';
import '../assist_in_pet_hunting/item.dart';

class OtherMemberPetsBody extends StatelessWidget{
  final List<MemberPetModel> pets;
  const OtherMemberPetsBody({super.key, required this.pets});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5),
      child: GridView.builder(
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, childAspectRatio: 0.7, crossAxisSpacing: 0),
          itemBuilder: (context, index) => SearchPetItem(pet: pets[index], isShowCollection: true),
          itemCount: pets.length,
        addAutomaticKeepAlives: true,
      ),
    );
  }

}