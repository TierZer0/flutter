import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipe_book/pages/home.page.dart';
import 'package:recipe_book/pages/profile/profile.page.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/pages/recipes/my-recipes.page.dart';
import 'package:ui/general/card.custom.dart';
import 'package:ui/general/text.custom.dart';

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
    HomePage(),
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
          return Scaffold(
            appBar: AppBar(
              title: CText(
                'Recipe Book',
                textLevel: EText.title2,
              ),
            ),
            body: Row(
              children: [
                NavigationRail(
                  labelType: NavigationRailLabelType.none,
                  onDestinationSelected: (int index) {
                    setState(() {
                      currentPageIndex = index;
                    });
                  },
                  trailing: Expanded(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 20.0,
                          ),
                          child: FloatingActionButton.extended(
                            onPressed: () => context.push('/newRecipe'),
                            // child: const Icon(
                            //   Icons.add_outlined,
                            //   size: 30.0,
                            // ),
                            icon: const Icon(
                              Icons.add_outlined,
                              size: 30.0,
                            ),
                            label: CText(
                              'New Recipe',
                              textLevel: EText.button,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  groupAlignment: -1.0,
                  extended: true,
                  selectedLabelTextStyle: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                  destinations: <NavigationRailDestination>[
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.groups_2_outlined,
                        size: 35.0,
                        color: theme.colorScheme.onSurface,
                      ),
                      selectedIcon: Icon(
                        Icons.groups_2,
                        size: 35.0,
                        color: theme.colorScheme.onSurface,
                      ),
                      label: CText(
                        'Community',
                        textLevel: EText.title,
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.book_outlined,
                        size: 35.0,
                        color: theme.colorScheme.onSurface,
                      ),
                      selectedIcon: Icon(
                        Icons.book,
                        size: 35.0,
                        color: theme.colorScheme.onSurface,
                      ),
                      label: CText(
                        'My Recipes',
                        textLevel: EText.title,
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.favorite_outline,
                        size: 35.0,
                        color: theme.colorScheme.onSurface,
                      ),
                      label: CText(
                        'Favorites',
                        textLevel: EText.title,
                      ),
                    ),
                    NavigationRailDestination(
                      icon: Icon(
                        Icons.person_outline_outlined,
                        size: 35.0,
                        color: theme.colorScheme.onSurface,
                      ),
                      label: CText(
                        'Profile',
                        textLevel: EText.title,
                      ),
                    ),
                  ],
                  selectedIndex: currentPageIndex,
                ),
                Expanded(
                  child: CustomCard(
                    child: views[currentPageIndex],
                    card: ECard.elevated,
                  ),
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
