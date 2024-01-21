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
      home: Scaffold(
        backgroundColor: Colors.yellow,
        body: NestedScrollViewPlus(
          headerSliverBuilder: (_, __) {
            return [
              OverlapAbsorberPlus(
                sliver: SliverPersistentHeader(
                  pinned: true,
                  delegate: MyDelegate(
                    minHeight: 100,
                    maxHeight: 160,
                  ),
                ),
              ),
            ];
          },
          body: CustomScrollView(
            slivers: [
              const OverlapInjectorPlus(),
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(height: 100, color: Colors.red),
                  ],
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
