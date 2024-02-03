import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nested_scroll_view_plus/nested_scroll_view_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.list), text: 'NSViewPlus'),
                Tab(icon: Icon(Icons.list_alt), text: 'NSViewOriginal'),
              ],
            ),
          ),
          backgroundColor: Colors.yellow,
          body: TabBarView(
            children: [
              NestedScrollViewPlus(
                headerSliverBuilder: (_, __) {
                  return [
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: MyDelegate(
                        minHeight: 20,
                        maxHeight: 160,
                      ),
                    ),
                  ];
                },
                body: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final number = index + 1;

                          return Container(
                            height: 50,
                            color: index.isEven
                                ? CupertinoColors.lightBackgroundGray
                                : CupertinoColors.extraLightBackgroundGray,
                            alignment: Alignment.center,
                            child: Text(
                              '$number',
                              style: CupertinoTheme.of(context).textTheme.textStyle,
                            ),
                          );
                        },
                        childCount: 20,
                      ),
                    ),
                  ],
                ),
              ),
              NestedScrollView(
                headerSliverBuilder: (context, __) {
                  return [
                    SliverOverlapAbsorber(
                      handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                      sliver: SliverPersistentHeader(
                        pinned: true,
                        delegate: MyDelegate(
                          minHeight: 20,
                          maxHeight: 160,
                        ),
                      ),
                    ),
                  ];
                },
                body: Builder(
                  builder: (context) {
                    return CustomScrollView(
                      slivers: [
                        SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
                        SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final number = index + 1;

                              return Container(
                                height: 50,
                                color: index.isEven
                                    ? CupertinoColors.lightBackgroundGray
                                    : CupertinoColors.extraLightBackgroundGray,
                                alignment: Alignment.center,
                                child: Text(
                                  '$number',
                                  style: CupertinoTheme.of(context).textTheme.textStyle,
                                ),
                              );
                            },
                            childCount: 20,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MyDelegate extends SliverPersistentHeaderDelegate {
  MyDelegate({
    required this.minHeight,
    required this.maxHeight,
  });

  double minHeight;
  double maxHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: maxHeight,
      color: Colors.purple,
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
