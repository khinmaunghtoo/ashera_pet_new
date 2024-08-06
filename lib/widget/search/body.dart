import 'dart:developer';

import 'package:ashera_pet_new/view_model/recommend_vm.dart';
import 'package:ashera_pet_new/view_model/search_text.dart';
import 'package:ashera_pet_new/widget/search/search_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh_plus/pull_to_refresh_plus.dart';

import '../text_field.dart';
import 'no_search.dart';

class SearchBody extends StatefulWidget {
  const SearchBody({super.key});

  @override
  State<StatefulWidget> createState() => _SearchBodyState();
}

class _SearchBodyState extends State<SearchBody> {
  RecommendVm? _recommendVm;
  SearchTextVm? _textVm;

  FocusNode focusNodeSearch = FocusNode();
  final TextEditingController _search = TextEditingController();
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  _onLayoutDone(_) {
    _textVm!.textAddListener(_search, focusNodeSearch);
    //取新條件貼文
    _recommendVm!.setSortBy();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(_onLayoutDone);
  }

  @override
  void dispose() {
    _textVm!.textDispose();
    super.dispose();
  }

  void _onLoading() async {
    // monitor network fetch
    await _recommendVm!.loadMore();
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    _textVm = Provider.of<SearchTextVm>(context, listen: false);
    _recommendVm = Provider.of(context, listen: false);
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: true,
      enablePullDown: false,
      footer: const ClassicFooter(
        loadingText: '載入中...',
      ),
      onLoading: _onLoading,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
              child: SearchTextField(
                controller: _search,
                focusNode: focusNodeSearch,
              ),
            ),
          ),
          //SliverMasonryGrid & SliverListView
          Selector<SearchTextVm, bool>(
            selector: (context, data) => data.isMasonryGrid,
            builder: (context, status, _) {
              return status
                  ? NoSearch(
                      focusNode: focusNodeSearch,
                    )
                  : const SearchData();
            },
          ),
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              log('沒看到啊');
              await Future.delayed(const Duration(milliseconds: 1000));
              return Future.value();
            },
            builder: (context, refreshState, pulledExtent,
                refreshTriggerPullDistance, refreshIndicatorExtent) {
              return Padding(
                padding: const EdgeInsets.only(top: 100),
                child: CupertinoSliverRefreshControl.buildRefreshIndicator(
                  context,
                  refreshState,
                  pulledExtent,
                  refreshTriggerPullDistance,
                  refreshIndicatorExtent,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
