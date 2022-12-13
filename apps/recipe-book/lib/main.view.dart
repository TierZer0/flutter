import 'package:flutter/material.dart';
import 'package:recipe_book/app_model.dart';
import 'package:recipe_book/pages/home.page.dart';
import 'package:recipe_book/pages/login.page.dart';
import 'package:recipe_book/pages/profile.page.dart';
import 'package:recipe_book/styles.dart';
import 'package:ui/ui.dart';

class MainView extends StatefulWidget {
  ThemeData theme;
  AppModel appModel;

  MainView(this.theme, this.appModel);

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

  void changeView(String view) async {
    widget.appModel.view = view;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: widget.theme,
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        body: widget.appModel.uid == ''
            ? LoginPage()
            : views[widget.appModel.view],
        bottomNavigationBar: widget.appModel.uid != ''
            ? CustomBottomNavBar(
                height: 90,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                useMat3: true,
                activeColor: tertiaryColor,
                mat3Navs: [
                  CustomNavBarItem(
                    label: 'Home',
                    isActive: widget.appModel.view == 'Home',
                    onPressed: () => changeView('Home'),
                    icon: Icon(
                      Icons.home_outlined,
                      size: 35.0,
                      color: (widget.theme.textTheme.titleLarge?.color)!,
                    ),
                  ),
                  CustomNavBarItem(
                    label: 'Recipes',
                    isActive: widget.appModel.view == 'Recipes',
                    onPressed: () => changeView('Recipes'),
                    icon: Icon(
                      Icons.book_outlined,
                      size: 35.0,
                      color: (widget.theme.textTheme.titleLarge?.color)!,
                    ),
                  ),
                  CustomNavBarItem(
                    label: 'New',
                    isActive: false,
                    onPressed: () {
                      showModalBottomSheet<void>(
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (BuildContext context) {
                          return Container(
                            height: 400,
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: widget.theme.shadowColor,
                                  blurRadius: 10.0,
                                ),
                              ],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                              color: widget.theme.backgroundColor,
                            ),
                            width: MediaQuery.of(context).size.width,
                          );
                        },
                      );
                    },
                    icon: Icon(
                      Icons.add,
                      size: 35.0,
                      color: (widget.theme.textTheme.titleLarge?.color)!,
                    ),
                  ),
                  CustomNavBarItem(
                    label: 'Favorites',
                    isActive: widget.appModel.view == 'Favorites',
                    onPressed: () => changeView('Favorites'),
                    icon: Icon(
                      Icons.favorite_outline,
                      size: 35.0,
                      color: (widget.theme.textTheme.titleLarge?.color)!,
                    ),
                  ),
                  CustomNavBarItem(
                    label: 'Profile',
                    isActive: widget.appModel.view == 'Profile',
                    onPressed: () => changeView('Profile'),
                    icon: Icon(
                      Icons.person_outline_outlined,
                      size: 35.0,
                      color: (widget.theme.textTheme.titleLarge?.color)!,
                    ),
                  ),
                ],
              )
            : null,
      ),
    );
  }
}
