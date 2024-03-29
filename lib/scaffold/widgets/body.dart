// ignore_for_file: max_lines_for_file, max_lines_for_function
import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:nested_scroll_view_plus/nested_scroll_view_plus.dart';

import '../../overridens/overriden_cupertino_scrollbar.dart';
import '../models/appbar_search_bar_settings.dart';
import '../utils/measures.dart';
import '../utils/store.dart';
import 'snap_scroll_listener.dart';

class Body extends StatelessWidget {
  const Body({
    required this.scrollController,
    required this.body,
    required this.measures,
    required this.animationBehavior,
    required this.scrollBehavior,
    required this.refreshListenable,
    required this.isScrollable,
    required this.nestedScrollViewKey,
    this.onRefresh,
    super.key,
  });

  final FutureOr<dynamic> Function()? onRefresh;
  final SearchBarAnimationBehavior animationBehavior;
  final Widget body;
  final bool isScrollable;
  final Measures measures;
  final IndicatorStateListenable refreshListenable;
  final SearchBarScrollBehavior scrollBehavior;
  final ScrollController scrollController;
  final GlobalKey<NestedScrollViewStatePlus> nestedScrollViewKey;

  Store get _store => Store.instance();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _store.isInHero,
      builder: (_, isInHero, __) {
        return IgnorePointer(
          ignoring: isInHero,
          child: EasyRefresh.builder(
            onRefresh: onRefresh,
            header: ListenerHeader(
              processedDuration: Duration.zero,
              triggerOffset: 160,
              listenable: refreshListenable,
              clamping: false,
              hitOver: true,
              hapticFeedback: true,
            ),
            childBuilder: (_, physics) {
              return OverridenCupertinoScrollbar(
                controller: scrollController,
                padding: EdgeInsets.only(top: MediaQuery.paddingOf(context).top + measures.appbarHeight),
                thumbVisibility: true,
                thicknessWhileDragging: 6,
                child: SnappingScrollListener(
                  scrollController: scrollController,
                  scrollBehavior: scrollBehavior,
                  collapsedHeight: measures.searchContainerHeight,
                  expandedHeight: measures.largeTitleContainerHeight,
                  child: NestedScrollViewPlus(
                    key: nestedScrollViewKey,
                    controller: scrollController,
                    physics: isScrollable ? physics : const NeverScrollableScrollPhysics(),
                    headerSliverBuilder: (context, _) {
                      return [
                        ValueListenableBuilder(
                          valueListenable: _store.searchBarAnimationStatus,
                          builder: (_, __, ___) {
                            final height = MediaQuery.paddingOf(context).top + measures.appbarHeight;

                            return SliverPersistentHeader(
                              pinned: true,
                              delegate: MyDelegate(
                                minHeight: isScrollable ? 0 : height - 0.000001,
                                maxHeight: height,
                              ),
                            );
                          },
                        ),
                      ];
                    },
                    body: CustomScrollView(
                      physics: isScrollable
                          ? const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics())
                          : const NeverScrollableScrollPhysics(),
                      slivers: [
                        body,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  MyDelegate({
    required this.minHeight,
    required this.maxHeight,
  });

  double maxHeight;
  double minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox(height: maxHeight);
  }
}
