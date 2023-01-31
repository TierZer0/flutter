import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/app_model.dart';
import 'package:recipe_book/pages/home.page.dart';
import 'package:recipe_book/pages/login.page.dart';
import 'package:recipe_book/pages/profile/profile.page.dart';
import 'package:recipe_book/styles.dart';
import 'package:ui/ui.dart';
import 'package:go_router/go_router.dart';

class MainView extends StatefulWidget {
  // ThemeData theme;
  // AppModel appModel;

  // MainView(this.theme, this.appModel);

  @override
  MainViewState createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  @override
  void initState() {
    super.initState();
  }

  // var views = {
  //   "Home": HomePage(),
  //   "Profile": ProfilePage(),
  // };

  var views = [
    HomePage(),
    Container(),
    Container(),
    ProfilePage(),
  ];

  void changeView(String view, AppModel appModel) async {
    appModel.view = view;
  }

  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context);
    final textColor = (Theme.of(context).textTheme.titleLarge?.color)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: views[currentPageIndex],
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: [
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
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: tertiaryColor,
        onPressed: () {},
        child: const Icon(
          Icons.add_outlined,
          size: 40.0,
        ),
      ),
    );
  }
}
