import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nested_scroll_view_plus/nested_scroll_view_plus.dart';

import 'scaffold/cupertino_scaffold.dart';
import 'scaffold/models/appbar_bottom_settings.dart';
import 'scaffold/models/appbar_large_title_settings.dart';
import 'scaffold/models/appbar_search_bar_settings.dart';
import 'scaffold/models/appbar_settings.dart';

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
      home: CupertinoScaffold(
        forceScroll: true,
        onRefresh: () => print('refresh'),
        appBar: AppBarSettings(
          title: const Text('Snapping Scroll'),
          largeTitle: AppBarLargeTitleSettings(
            largeTitle: 'Snapping Scroll',
          ),
          searchBar: AppBarSearchBarSettings(
            enabled: true,
          ),
        ),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            const OverlapInjectorPlus(),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final number = index + 1;

                  return GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      CupertinoPageRoute(
                        builder: (context) => const SecondPage(),
                      ),
                    ),
                    child: Container(
                      height: 50,
                      color:
                          index.isEven ? CupertinoColors.lightBackgroundGray : CupertinoColors.extraLightBackgroundGray,
                      alignment: Alignment.center,
                      child: Text(
                        '$number',
                        style: CupertinoTheme.of(context).textTheme.textStyle,
                      ),
                    ),
                  );
                },
                childCount: 100,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      forceScroll: true,
      onRefresh: () => print('refresh'),
      appBar: AppBarSettings(
        bottom: AppBarBottomSettings(
          enabled: true,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Wrap(
                spacing: 16,
                children: ['First', 'Second', 'Third', 'Fourth', 'Fifth'].map((e) {
                  return Container(
                    height: 30,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: e == 'First' ? CupertinoColors.systemBlue : CupertinoColors.lightBackgroundGray,
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                    ),
                    child: Center(
                      child: Text(
                        e,
                        style: CupertinoTheme.of(context).textTheme.actionTextStyle.copyWith(
                              color: e == 'First' ? CupertinoColors.white : CupertinoColors.black,
                            ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
        largeTitle: AppBarLargeTitleSettings(
          largeTitle: 'Second Page',
        ),
      ),
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
                Container(height: 200, color: Colors.orange),
                Container(height: 200, color: Colors.yellow),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
