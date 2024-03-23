import 'package:flutter/material.dart';
import 'package:recipe_book/pages/mine/parts/my_recipe_books.part.dart';
import 'package:recipe_book/pages/mine/parts/my_recipes.part.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: TabBar(
          controller: _tabController,
          tabAlignment: TabAlignment.start,
          isScrollable: true,
          dividerColor: Colors.transparent,
          tabs: [
            Tab(
              child: Text(
                'My Recipes',
                textScaler: TextScaler.linear(1.1),
              ),
            ),
            Tab(
              child: Text(
                'My Recipe Books',
                textScaler: TextScaler.linear(1.1),
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MyRecipesPart(),
          MyRecipeBooksPart(),
        ],
      ),
    );
  }
}
