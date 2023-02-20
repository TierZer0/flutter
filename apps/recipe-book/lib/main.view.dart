import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/app_model.dart';
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
  navPressed(int index) {
    setState(() {
      currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = (Theme.of(context).textTheme.titleLarge?.color)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      // bottomNavigationBar: NavigationBar(
      //   onDestinationSelected: (int index) {
      //     print(index);
      // setState(() {
      //   currentPageIndex = index;
      // });
      //   },
      //   selectedIndex: currentPageIndex,
      //   destinations: <Widget>[
      //     NavigationDestination(
      // icon: Icon(
      //   Icons.home_outlined,
      //   size: 35.0,
      //   color: textColor,
      // ),
      //       label: 'Home',
      //     ),
      //     NavigationDestination(
      //       icon: Icon(
      //         Icons.book_outlined,
      //         size: 35.0,
      //         color: textColor,
      //       ),
      //       label: 'Recipes',
      //     ),
      //     NavigationDestination(
      //       icon: Icon(
      //         Icons.favorite_outline,
      //         size: 35.0,
      //         color: textColor,
      //       ),
      //       label: 'Favorites',
      //     ),
      //     NavigationDestination(
      //       icon: Icon(
      //         Icons.person_outline_outlined,
      //         size: 35.0,
      //         color: textColor,
      //       ),
      //       label: 'Profile',
      //     ),
      //   ],
      // ),
      bottomNavigationBar: CustomBottomNavBar(
        height: 85,
        activeColor: primaryColor,
        useMat3: true,
        mat3Navs: <CustomNavBarItem>[
          CustomNavBarItem(
            label: 'Home',
            icon: Icon(
              Icons.home_outlined,
              size: 35.0,
              color: textColor,
            ),
            isActive: currentPageIndex == 0,
            onPressed: () => navPressed(0),
          ),
          CustomNavBarItem(
            label: 'Books',
            icon: Icon(
              Icons.book_outlined,
              size: 35.0,
              color: textColor,
            ),
            isActive: currentPageIndex == 1,
            onPressed: () => navPressed(1),
          ),
          CustomNavBarItem(
            label: 'Favorites',
            icon: Icon(
              Icons.favorite_outline,
              size: 35.0,
              color: textColor,
            ),
            isActive: currentPageIndex == 2,
            onPressed: () => navPressed(2),
          ),
          CustomNavBarItem(
            label: 'Profile',
            icon: Icon(
              Icons.person_outline_outlined,
              size: 35.0,
              color: textColor,
            ),
            isActive: currentPageIndex == 3,
            onPressed: () => navPressed(3),
          )
        ],
      ),
      body: views[currentPageIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: secondaryColor,
        onPressed: () => context.go('/newRecipe'),
        child: const Icon(
          Icons.add_outlined,
          size: 40.0,
        ),
      ),
    );
  }
}
