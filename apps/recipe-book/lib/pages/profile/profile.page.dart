import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/pages/profile/tabs/books.tab.dart';
import 'package:recipe_book/pages/profile/tabs/categories.tab.dart';
import 'package:recipe_book/pages/profile/tabs/info.tab.dart';
import 'package:recipe_book/pages/profile/tabs/settings.tab.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/styles.dart';
import 'package:ui/ui.dart';
import 'package:recipe_book/app_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> with TickerProviderStateMixin {
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
        ),
        elevation: 0,
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
