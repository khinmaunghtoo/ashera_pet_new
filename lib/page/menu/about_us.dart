import 'package:ashera_pet_new/utils/app_color.dart';
import 'package:ashera_pet_new/widget/system_back.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../view_model/about_us.dart';
import '../../widget/about_us/title.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<StatefulWidget> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    return SystemBack(
        child: Scaffold(
      backgroundColor: AppColor.appBackground,
      resizeToAvoidBottomInset: false,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: constraints.maxHeight,
            width: constraints.maxWidth,
            child: Column(
              children: [
                AboutUsTitle(
                  callback: _back,
                ),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Consumer<AboutUsVm>(
                    builder: (context, vm, _) {
                      return Html(
                        data: vm.aboutUsModel.about,
                        onLinkTap: (url, _, __) async {
                          final uri = Uri.parse(url!);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri);
                          }
                        },
                      );
                    },
                  ),
                ))
              ],
            ),
          );
        },
      ),
    ));
  }

  //返回
  void _back() {
    context.pop();
  }
}
