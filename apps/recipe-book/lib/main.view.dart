import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/app_model.dart';
import 'package:recipe_book/pages/home.page.dart';
import 'package:recipe_book/pages/login.page.dart';
import 'package:recipe_book/pages/profile.page.dart';
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

  var views = {
    "Home": HomePage(),
    "Profile": ProfilePage(),
  };

  void changeView(String view, AppModel appModel) async {
    appModel.view = view;
  }

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context);
    final textColor = (Theme.of(context).textTheme.titleLarge?.color)!;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: appModel.uid == '' ? LoginPage() : views[appModel.view],
      bottomNavigationBar: appModel.uid != ''
          ? CustomBottomNavBar(
              height: 90,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              useMat3: true,
              activeColor: tertiaryColor,
              mat3Navs: [
                CustomNavBarItem(
                  label: 'Home',
                  isActive: appModel.view == 'Home',
                  onPressed: () => changeView('Home', appModel),
                  icon: Icon(
                    Icons.home_outlined,
                    size: 35.0,
                    color: textColor,
                  ),
                ),
                CustomNavBarItem(
                  label: 'Recipes',
                  isActive: appModel.view == 'Recipes',
                  onPressed: () => changeView('Recipes', appModel),
                  icon: Icon(
                    Icons.book_outlined,
                    size: 35.0,
                    color: textColor,
                  ),
                ),
                CustomNavBarItem(
                  label: 'New',
                  isActive: false,
                  onPressed: () => context.go('/newRecipe'),
                  icon: Icon(
                    Icons.add,
                    size: 35.0,
                    color: textColor,
                  ),
                ),
                CustomNavBarItem(
                  label: 'Favorites',
                  isActive: appModel.view == 'Favorites',
                  onPressed: () => changeView('Favorites', appModel),
                  icon: Icon(
                    Icons.favorite_outline,
                    size: 35.0,
                    color: textColor,
                  ),
                ),
                CustomNavBarItem(
                  label: 'Profile',
                  isActive: appModel.view == 'Profile',
                  onPressed: () => changeView('Profile', appModel),
                  icon: Icon(
                    Icons.person_outline_outlined,
                    size: 35.0,
                    color: textColor,
                  ),
                ),
              ],
            )
          : null,
    );
  }
}
