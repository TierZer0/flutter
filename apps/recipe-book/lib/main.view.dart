import 'package:flutter/material.dart';
import 'package:recipe_book/pages/home.page.dart';
import 'package:recipe_book/pages/profile/profile.page.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/pages/recipes/my-recipes.page.dart';

class MainView extends StatefulWidget {
  @override
  MainViewState createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  @override
  void initState() {
    super.initState();
  }

  var views = [
    HomeView(),
    RecipesView(),
    Container(),
    ProfileView(),
  ];

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 660) {
          return SafeArea(
            child: Row(
              children: [
                NavigationRail(
                  labelType: NavigationRailLabelType.all,
                  onDestinationSelected: (int index) {
                    setState(() {
                      currentPageIndex = index;
                    });
                  },
                  leading: FloatingActionButton(
                    onPressed: () => context.push('/newRecipe'),
                    child: const Icon(
                      Icons.add_outlined,
                      size: 30.0,
                    ),
                  ),
                  groupAlignment: -1.0,
                  destinations: <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.groups_2_outlined,
                        size: 35.0,
                        color: theme.colorScheme.onSurface,
                      ),
                      label: Text('Community'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.book_outlined,
                        size: 35.0,
                        color: theme.colorScheme.onSurface,
                      ),
                      label: Text('My Recipes'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.favorite_outline,
                        size: 35.0,
                        color: theme.colorScheme.onSurface,
                      ),
                      label: Text('Favorites'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.person_outline_outlined,
                        size: 35.0,
                        color: theme.colorScheme.onSurface,
                      ),
                      label: Text('Profile'),
                    ),
                  ],
                  selectedIndex: currentPageIndex,
                ),
                VerticalDivider(
                  thickness: 1,
                  width: 1,
                  color: theme.colorScheme.outlineVariant,
                ),
                Expanded(
                  child: views[currentPageIndex],
                )
              ],
            ),
          );
        } else {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: NavigationBar(
              elevation: 0,
              onDestinationSelected: (int index) {
                setState(() {
                  currentPageIndex = index;
                });
              },
              selectedIndex: currentPageIndex,
              destinations: <Widget>[
                NavigationDestination(
                  icon: Icon(
                    Icons.groups_2_outlined,
                    size: 35.0,
                    color: theme.colorScheme.onSurface,
                  ),
                  label: 'Community',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.book_outlined,
                    size: 35.0,
                    color: theme.colorScheme.onSurface,
                  ),
                  label: 'My Recipes',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.favorite_outline,
                    size: 35.0,
                    color: theme.colorScheme.onSurface,
                  ),
                  label: 'Favorites',
                ),
                NavigationDestination(
                  icon: Icon(
                    Icons.person_outline_outlined,
                    size: 35.0,
                    color: theme.colorScheme.onSurface,
                  ),
                  label: 'Profile',
                ),
              ],
            ),
            body: views[currentPageIndex],
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () => context.push('/newRecipe'),
              child: const Icon(
                Icons.add_outlined,
                size: 30.0,
              ),
            ),
          );
        }
      },
    );
  }
}
