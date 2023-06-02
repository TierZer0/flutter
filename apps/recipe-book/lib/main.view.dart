import 'package:flutter/material.dart';
import 'package:recipe_book/views/home.view.dart';
import 'package:recipe_book/views/profile/profile.view.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/views/recipes/my-recipes.view.dart';

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
}
