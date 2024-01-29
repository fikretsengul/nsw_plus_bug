import 'package:flutter/material.dart';
import 'package:nested_scroll_view_plus/nested_scroll_view_plus.dart';

import 'scaffold/cupertino_scaffold.dart';
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
          searchBar: AppBarSearchBarSettings(
            enabled: true,
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
      ),
    );
  }
}
