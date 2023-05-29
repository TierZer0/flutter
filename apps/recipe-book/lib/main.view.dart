import 'package:flutter/material.dart';
import 'package:recipe_book/pages/home.page.dart';
import 'package:recipe_book/pages/profile/profile.page.dart';
import 'package:go_router/go_router.dart';

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
    Container(),
    Container(),
    ProfilePage(),
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
              Icons.home_outlined,
              size: 35.0,
              color: theme.colorScheme.onSurface,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.book_outlined,
              size: 35.0,
              color: theme.colorScheme.onSurface,
            ),
            label: 'Recipes',
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
