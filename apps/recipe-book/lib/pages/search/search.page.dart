import 'package:flutter/material.dart';
import 'package:recipe_book/pages/search/parts/past-week.part.dart';
import 'package:recipe_book/pages/search/parts/recipe-books.part.dart';
import 'package:recipe_book/pages/search/parts/today.part.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
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
                'Today',
                textScaler: TextScaler.linear(1.1),
              ),
            ),
            Tab(
              child: Text(
                'This Week',
                textScaler: TextScaler.linear(1.1),
              ),
            ),
            Tab(
              child: Text(
                'Recipe Book',
                textScaler: TextScaler.linear(1.1),
              ),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          TodaySearchPart(),
          PastWeekSearchPart(),
          RecipeBookSearchPart(),
        ],
      ),
    );
  }
}
