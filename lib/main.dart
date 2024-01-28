import 'package:flutter/material.dart';
import 'package:flutter/src/rendering/sliver_persistent_header.dart';
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
                    const OverlapAbsorberPlus(
                      sliver: SliverAppBar(
                        pinned: true,
                        stretch: true,
                        backgroundColor: Colors.purple,
                        collapsedHeight: 100,
                        expandedHeight: 160,
                      ),
                    ),
                  ];
                },
                body: CustomScrollView(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  slivers: [
                    const OverlapInjectorPlus(),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(height: 200, color: Colors.red),
                          Container(height: 200, color: Colors.green),
                          Container(height: 200, color: Colors.blue),
                        ],
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
                      sliver: const SliverAppBar(
                        pinned: true,
                        stretch: true,
                        backgroundColor: Colors.purple,
                        collapsedHeight: 100,
                        expandedHeight: 160,
                      ),
                    ),
                  ];
                },
                body: Builder(
                  builder: (context) {
                    return CustomScrollView(
                      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                      slivers: [
                        SliverOverlapInjector(handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
                        SliverToBoxAdapter(
                          child: Column(
                            children: [
                              Container(height: 200, color: Colors.red),
                              Container(height: 200, color: Colors.green),
                              Container(height: 200, color: Colors.blue),
                            ],
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
  OverScrollHeaderStretchConfiguration? get stretchConfiguration => OverScrollHeaderStretchConfiguration();

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: maxHeight,
          color: Colors.purple,
        ),
      ),
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
