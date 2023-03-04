import 'package:flutter/material.dart';
import 'package:recipe_book/pages/home.page.dart';
import 'package:recipe_book/pages/profile/profile.page.dart';
import 'package:recipe_book/styles.dart';
import 'package:go_router/go_router.dart';
import 'package:ui/ui.dart';

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
    final textColor = (Theme.of(context).textTheme.titleLarge?.color)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      bottomNavigationBar: NavigationBar(
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
              color: textColor,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.book_outlined,
              size: 35.0,
              color: textColor,
            ),
            label: 'Recipes',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.favorite_outline,
              size: 35.0,
              color: textColor,
            ),
            label: 'Favorites',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.person_outline_outlined,
              size: 35.0,
              color: textColor,
            ),
            label: 'Profile',
          ),
        ],
      ),
      body: views[currentPageIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondaryColor,
        onPressed: () => context.push('/newRecipe'),
        child: const Icon(
          Icons.add_outlined,
          size: 40.0,
        ),
      ),
    );
  }
}
