import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:flutter/material.dart';

import '../../../widget/collection/body.dart';
import '../../../widget/collection/title.dart';
import '../../../widget/system_back.dart';

class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SystemBack(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColor.appBackground,
        body: Column(
          children: [
            //title
            CollectionTitle(),
            //body
            Expanded(child: CollectionBody())
          ],
        ),
      ),
    );
  }
}
