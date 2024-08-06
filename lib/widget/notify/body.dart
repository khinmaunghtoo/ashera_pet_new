import 'dart:developer';

import 'package:ashera_pet_new/enum/notify_time_type.dart';
import 'package:ashera_pet_new/model/notify.dart';
import 'package:ashera_pet_new/view_model/notify.dart';
import 'package:ashera_pet_new/widget/notify/notify_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../../utils/app_color.dart';

class NotifyBody extends StatefulWidget {
  const NotifyBody({super.key});

  @override
  State<StatefulWidget> createState() => _NotifyBody();
}

class _NotifyBody extends State<NotifyBody> {
  NotifyVm? _notifyVm;
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(_listener);
  }

  void _listener() {
    if (controller.offset == controller.position.maxScrollExtent) {
      log('到達底部');
      _notifyVm!.addPage();
    }
  }

  @override
  void dispose() {
    controller.removeListener(_listener);
    _notifyVm!.clearDto();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _notifyVm = Provider.of<NotifyVm>(context, listen: false);
    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverToBoxAdapter(
          child: Selector<NotifyVm, List<NotifyModel>>(
            selector: (context, data) => data.thisWeekNotify.toList(),
            shouldRebuild: (previous, next) => previous != next,
            builder: (context, list, _) {
              return NotifyCard(
                title: NotifyTimeType.thisWeek.zh,
                listData: list,
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Selector<NotifyVm, List<NotifyModel>>(
            selector: (context, data) => data.thisMonthNotify.toList(),
            shouldRebuild: (previous, next) => previous != next,
            builder: (context, list, _) {
              return NotifyCard(
                title: NotifyTimeType.thisMonth.zh,
                listData: list,
              );
            },
          ),
        ),
        SliverToBoxAdapter(
          child: Selector<NotifyVm, List<NotifyModel>>(
            selector: (context, data) => data.earlierNotify.toList(),
            shouldRebuild: (previous, next) => previous != next,
            builder: (context, list, _) {
              return NotifyCard(
                title: NotifyTimeType.earlier.zh,
                listData: list,
              );
            },
          ),
        ),
        SliverFillRemaining(
          child: Consumer<NotifyVm>(
            builder: (context, vm, _) {
              if (vm.thisWeekNotify.isNotEmpty ||
                  vm.thisMonthNotify.isNotEmpty ||
                  vm.earlierNotify.isNotEmpty) {
                return Container();
              }
              return const Center(
                child: Text(
                  '空空如也的通知',
                  style: TextStyle(color: AppColor.textFieldTitle),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
