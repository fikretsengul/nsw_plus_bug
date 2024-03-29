// ignore_for_file: avoid_returning_widgets, max_lines_for_file

import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nested_scroll_view_plus/nested_scroll_view_plus.dart';

import '../overridens/overriden_transitionable_navigation_bar.dart';
import 'models/appbar_settings.dart';
import 'utils/helpers.dart';
import 'utils/measures.dart';
import 'utils/store.dart';
import 'widgets/app_bar/animated_app_bar_builder.dart';
import 'widgets/app_bar/search_bar/search_bar_result.dart';
import 'widgets/body.dart';
import 'widgets/refresher.dart';

class CupertinoScaffold extends StatefulWidget {
  CupertinoScaffold({
    required this.body,
    required this.appBar,
    super.key,
    this.shouldStretch = true,
    this.onCollapsed,
    this.scrollController,
    this.shouldTransiteBetweenRoutes = true,
    this.onRefresh,
    this.forceScroll = false,
  }) : measures = Measures(
          searchTextFieldHeight: appBar.searchBar!.height,
          largeTitleContainerHeight: appBar.largeTitle!.height,
          primaryToolbarHeight: appBar.height,
          bottomToolbarHeight: appBar.bottom!.height,
          searchBarAnimationDurationx: appBar.searchBar!.animationDuration,
        );

  final FutureOr<dynamic> Function()? onRefresh;
  final AppBarSettings appBar;
  final Widget body;
  final bool forceScroll;
  final Measures measures;
  final ValueChanged<bool>? onCollapsed;
  late final ScrollController? scrollController;
  final bool shouldStretch;
  final bool shouldTransiteBetweenRoutes;

  @override
  State<CupertinoScaffold> createState() => _SuperScaffoldState();
}

class _SuperScaffoldState extends State<CupertinoScaffold> {
  bool _isScrollable = false;
  late final NavigationBarStaticComponentsKeys _keys;
  late final GlobalKey<NestedScrollViewStatePlus> _nestedScrollViewKey;
  late final IndicatorStateListenable _refreshListenable;
  late final ScrollController _scrollController;

  @override
  void didChangeDependencies() {
    setState(() {
      if (widget.forceScroll) {
        _isScrollable = true;
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_nestedScrollViewKey.currentState!.innerController.position.maxScrollExtent > 0) {
            _isScrollable = true;
          } else {
            _isScrollable = false;
          }
        });
      }
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _keys = NavigationBarStaticComponentsKeys();
    _scrollController = widget.scrollController ?? ScrollController();
    _refreshListenable = IndicatorStateListenable();
    _nestedScrollViewKey = GlobalKey<NestedScrollViewStatePlus>();
  }

  Store get _store => Store.instance();

  Widget? _getTitle() {
    if (widget.appBar.title is Text) {
      return Text(
        '${(widget.appBar.title! as Text).data}',
        style: defaultTitleTextStyle(context, widget.appBar),
      );
    } else {
      return widget.appBar.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    final components = NavigationBarStaticComponents(
      keys: _keys,
      route: ModalRoute.of(context),
      userLeading: widget.appBar.leading,
      automaticallyImplyLeading: widget.appBar.automaticallyImplyLeading,
      automaticallyImplyTitle: true,
      previousPageTitle: widget.appBar.previousPageTitle,
      userMiddle: _getTitle(),
      userTrailing: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [...widget.appBar.actions],
        ),
      ),
      largeTitleActions: Row(
        children: [
          ...?widget.appBar.largeTitle!.actions,
        ],
      ),
      userLargeTitle: Text(
        widget.appBar.largeTitle!.largeTitle,
        style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle.copyWith(inherit: false),
        overflow: TextOverflow.ellipsis,
      ),
      appbarBottom: widget.appBar.bottom!.child,
      padding: null,
      large: true,
    );

    return PopScope(
      canPop: !_store.searchBarHasFocus.value,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Body(
              scrollController: _scrollController,
              measures: widget.measures,
              scrollBehavior: widget.appBar.searchBar!.scrollBehavior,
              animationBehavior: widget.appBar.searchBar!.animationBehavior,
              body: widget.body,
              onRefresh: widget.onRefresh,
              refreshListenable: _refreshListenable,
              isScrollable: _isScrollable,
              nestedScrollViewKey: _nestedScrollViewKey,
            ),
            SearchBarResult(
              measures: widget.measures,
              searchBar: widget.appBar.searchBar!,
            ),
            AnimatedAppBarBuilder(
              scrollController: _scrollController,
              measures: widget.measures,
              appBar: widget.appBar,
              components: components,
              keys: _keys,
              shouldStretch: widget.shouldStretch,
              shouldTransiteBetweenRoutes: widget.shouldTransiteBetweenRoutes,
              onCollapsed: widget.onCollapsed,
              isScrollable: _isScrollable,
            ),
            Refresher(refreshListenable: _refreshListenable),
          ],
        ),
      ),
    );
  }
}
