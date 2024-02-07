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

enum EMyFavoritesViews { Made, NotMade }

class _FavoritesPageState extends State<FavoritesPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  EMyFavoritesViews _currentView = EMyFavoritesViews.Made;
  buildView() {
    switch (_currentView) {
      case EMyFavoritesViews.Made:
        return MadeFavoritesTab();
      case EMyFavoritesViews.NotMade:
        return NotMadeFavoritesTab();
    }
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
          return notification.depth >= 0;
        },
        title: CText(
          'Favorite Recipes',
          textLevel: EText.title,
          weight: FontWeight.bold,
        ),
        toolbarHeight: 50.0,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 12.0,
                ),
                child: SegmentedButton<EMyFavoritesViews>(
                  segments: [
                    ButtonSegment<EMyFavoritesViews>(
                      value: EMyFavoritesViews.Made,
                      label: CText(
                        'Made',
                        textLevel: EText.button,
                      ),
                    ),
                    ButtonSegment<EMyFavoritesViews>(
                      value: EMyFavoritesViews.NotMade,
                      label: CText(
                        "Not Made",
                        textLevel: EText.button,
                      ),
                    ),
                  ],
                  selected: <EMyFavoritesViews>{_currentView},
                  onSelectionChanged: (Set<EMyFavoritesViews> newSelection) {
                    setState(() {
                      _currentView = newSelection.first;
                    });
                  },
                ),
              )
            ],
          ),
        ),
      ),
      body: buildView(),
    );
  }
}
