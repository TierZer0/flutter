import 'package:flutter/material.dart';
import 'package:ui/general/text.custom.dart';
import 'package:ui/ui.dart';

import 'tabs/made-recipes.tab.dart';
import 'tabs/not-made-recipes.tab.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 660) {
        return buildDesktop(context);
      } else {
        return buildMobile(context);
      }
    });
  }

  Widget buildDesktop(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            title: CText(
              'Favorite Recipes',
              textLevel: EText.title,
              weight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .25,
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  text: 'Made',
                ),
                Tab(
                  text: "Haven't Made",
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [MadeFavoritesTab(), NotMadeFavoritesTab()],
            ),
          )
        ],
      ),
    );
  }

  Widget buildMobile(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CText(
          'Favorite Recipes',
          textLevel: EText.title,
          weight: FontWeight.bold,
        ),
        toolbarHeight: 110,
        elevation: 5,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Made',
              icon: Icon(Icons.check),
            ),
            Tab(
              text: "Haven't Made",
              icon: Icon(Icons.clear),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [MadeFavoritesTab(), NotMadeFavoritesTab()],
      ),
    );
  }
}
