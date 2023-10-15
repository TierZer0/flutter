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
    return ResponsiveWidget(
      desktopScreen: buildDesktop(context),
      mobileScreen: buildMobile(context),
    );
  }

  var _selectedIndex = 0;
  final _destinations = [
    MadeFavoritesTab(),
    NotMadeFavoritesTab(),
  ];
  Widget buildDesktop(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: CText(
          'Favorite Recipes',
          textLevel: EText.title,
          weight: FontWeight.bold,
        ),
      ),
      body: Row(
        children: [
          NavigationRail(
            labelType: NavigationRailLabelType.selected,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            selectedIndex: _selectedIndex,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.check),
                label: CText(
                  'Made',
                  textLevel: EText.button,
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.clear),
                label: CText(
                  "Not Made",
                  textLevel: EText.button,
                ),
              ),
            ],
          ),
          Expanded(
            child: CustomCard(
              card: ECard.filled,
              child: _destinations[_selectedIndex],
            ),
          )
        ],
      ),
    );
  }

  Widget buildMobile(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        notificationPredicate: (ScrollNotification notification) {
          return notification.depth == 1;
        },
        title: CText(
          'Favorite Recipes',
          textLevel: EText.title,
          weight: FontWeight.bold,
        ),
        toolbarHeight: 50.0,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          dividerColor: Colors.transparent,
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
      body: TabBarView(
        controller: _tabController,
        children: [MadeFavoritesTab(), NotMadeFavoritesTab()],
      ),
    );
  }
}
