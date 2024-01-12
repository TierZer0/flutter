import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/app_model.dart';
import 'package:recipe_book/main.dart';
import 'package:recipe_book/pages/favorites/favorites.page.dart';
import 'package:recipe_book/pages/community/community.page.dart';
import 'package:recipe_book/pages/profile/profile.page.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/pages/recipes/my-recipes.page.dart';
import 'package:ui/general/card.custom.dart';
import 'package:ui/general/text.custom.dart';
import 'package:ui/inputs/reactive-input.custom.dart';
import 'package:ui/layout/responsive-widget.custom.dart';

class MainView extends StatefulWidget {
  @override
  MainViewState createState() => MainViewState();
}

class MainViewState extends State<MainView> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Map<String, dynamic> _currentPage = {
    'title': 'Community',
    'icon': Icons.groups_2_outlined,
    'selectedIcon': Icons.groups_2,
    'view': HomePage(),
    'sideNav': []
  };
  getView(int index) {
    return _pages[index];
  }

  final _pages = {
    0: {'title': 'Community', 'icon': Icons.groups_2_outlined, 'selectedIcon': Icons.groups_2, 'view': HomePage(), 'sideNav': []},
    1: {
      'title': 'My Recipes',
      'icon': Icons.book_outlined,
      'selectedIcon': Icons.book,
      'view': RecipesView(),
      'sideNav': [
        NavigationRailDestination(
          icon: Icon(Icons.dinner_dining_outlined),
          label: CText(
            'Recipes',
            textLevel: EText.button,
          ),
        ),
        NavigationRailDestination(
          icon: Icon(Icons.menu_book_sharp),
          label: CText(
            'Books',
            textLevel: EText.button,
          ),
        ),
      ]
    },
    2: {'title': 'Favorites', 'icon': Icons.favorite_outline, 'selectedIcon': Icons.favorite, 'view': FavoritesPage(), 'sideNav': []},
    3: {'title': 'Profile', 'icon': Icons.person_outline_outlined, 'selectedIcon': Icons.person, 'view': ProfileView(), 'sideNav': []},
  };
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktopScreen: buildDesktop(context),
      mobileScreen: buildMobile(context),
    );
  }

  Widget buildDesktop(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        toolbarHeight: 70,
        notificationPredicate: (notification) {
          return notification.depth != 0;
        },
        backgroundColor: seed,
        title: CText(
          'Recipe Book',
          textLevel: EText.custom,
          textStyle: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onPrimary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _currentPage = getView(0);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CText(
                'Community',
                textLevel: EText.custom,
                textStyle: TextStyle(
                  fontSize: 20,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _currentPage = getView(1);
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CText(
                'My Recipes',
                textLevel: EText.custom,
                textStyle: TextStyle(
                  fontSize: 20,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CText(
                'Favorites',
                textLevel: EText.custom,
                textStyle: TextStyle(
                  fontSize: 20,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CText(
                'Profile',
                textLevel: EText.custom,
                textStyle: TextStyle(
                  fontSize: 20,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            right: 0,
            child: _currentPage['sideNav'].length == 0
                ? Container(
                    color: seed,
                    child: SizedBox(
                      height: double.maxFinite,
                      width: double.maxFinite,
                    ),
                  )
                : NavigationRail(
                    extended: true,
                    backgroundColor: seed,
                    destinations: _currentPage['sideNav'],
                    selectedIndex: 0,
                  ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 200),
            left: _currentPage['sideNav'].length == 0 ? 75 : 225,
            top: 0,
            bottom: 0,
            right: 0,
            child: Expanded(
              child: Container(
                margin: EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                  color: theme.colorScheme.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withOpacity(0.3),
                      spreadRadius: 1,
                      offset: Offset(0, 25),
                      blurRadius: 20,
                    ),
                  ],
                ),
                child: Container(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMobile(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      key: scaffoldKey,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          _currentPage['view'],
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 500,
              width: double.maxFinite,
              child: DraggableScrollableSheet(
                initialChildSize: 0.15,
                minChildSize: 0.15,
                maxChildSize: 0.8,
                builder: (BuildContext context, ScrollController scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: seed,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(20.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.shadow.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 20,
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton.filledTonal(
                                  onPressed: () {
                                    setState(() {
                                      _currentPage = getView(0);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.groups_2_outlined,
                                    size: 30,
                                  ),
                                ),
                                IconButton.filledTonal(
                                  onPressed: () {
                                    setState(() {
                                      _currentPage = getView(1);
                                    });
                                  },
                                  icon: Icon(
                                    Icons.book_outlined,
                                    size: 30,
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Center(
                                    child: CText(
                                      _currentPage['title'],
                                      textLevel: EText.custom,
                                      textStyle: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.onPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton.filledTonal(
                                  onPressed: () => {
                                    setState(() {
                                      _currentPage = getView(2);
                                    })
                                  },
                                  icon: Icon(
                                    Icons.favorite_outline,
                                    size: 30,
                                  ),
                                ),
                                IconButton.filledTonal(
                                  onPressed: () => context.push('/newRecipe'),
                                  icon: Icon(
                                    Icons.add,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: ListTile(
                              title: CText(
                                'Create Recipe Book',
                                textLevel: EText.custom,
                                textStyle: TextStyle(
                                  fontSize: 22,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                              onTap: () => {},
                            ),
                          ),
                          Material(
                            color: Colors.transparent,
                            child: ListTile(
                              title: CText(
                                'Create Recipe Ingredient',
                                textLevel: EText.custom,
                                textStyle: TextStyle(
                                  fontSize: 22,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                              onTap: () => {},
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
