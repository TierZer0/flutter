import 'package:flutter/material.dart';
import 'package:recipe_book/views/profile/tabs/books.tab.dart';
import 'package:recipe_book/views/profile/tabs/categories.tab.dart';
import 'package:recipe_book/views/profile/tabs/info.tab.dart';
import 'package:recipe_book/views/profile/tabs/settings.tab.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/styles.dart';
import 'package:ui/ui.dart';

class ProfileView extends StatefulWidget {
  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          text: authService.user?.displayName,
          fontSize: 35.0,
          fontFamily: "Lato",
          color: theme.colorScheme.onBackground,
          padding: EdgeInsets.only(
            bottom: 40.0,
          ),
        ),
        elevation: 10,
        toolbarHeight: 110.0,
        bottom: TabBar(
          indicatorColor: primaryColor,
          controller: _tabController,
          tabs: const [
            Tab(
              text: 'Info',
              icon: Icon(Icons.info_outline),
            ),
            Tab(
              text: 'Categories',
              icon: Icon(Icons.category_outlined),
            ),
            Tab(
              text: 'Recipe Books',
              icon: Icon(Icons.book_outlined),
            ),
            Tab(
              text: 'Settings',
              icon: Icon(Icons.settings_outlined),
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          InfoTab(),
          CategoriesTab(),
          BooksTab(),
          SettingsTab(),
        ],
      ),
    );
  }
}
