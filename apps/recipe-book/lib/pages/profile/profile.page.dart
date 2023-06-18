import 'package:flutter/material.dart';
import 'package:recipe_book/pages/profile/tabs/books.tab.dart';
import 'package:recipe_book/pages/profile/tabs/categories.tab.dart';
import 'package:recipe_book/pages/profile/tabs/info.tab.dart';
import 'package:recipe_book/pages/profile/tabs/settings.tab.dart';
import 'package:recipe_book/services/auth.service.dart';
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
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 660) {
        return buildDesktop(context);
      } else {
        return buildMobile(context);
      }
    });
  }

  Widget buildDesktop(BuildContext context) {
    var theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            title: CText(
              authService.user?.displayName ?? authService.user?.email ?? '',
              textLevel: EText.title,
              weight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .35,
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  text: 'Info',
                ),
                Tab(
                  text: 'Categories',
                ),
                Tab(
                  text: 'Recipe Books',
                ),
                Tab(
                  text: 'Settings',
                )
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                InfoTab(),
                CategoriesTab(),
                BooksTab(),
                SettingsTab(),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildMobile(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: CText(
          authService.user?.displayName ?? '',
          textLevel: EText.title,
          scaleFactor: 1.0,
          weight: FontWeight.bold,
        ),
        elevation: 10,
        toolbarHeight: 110.0,
        bottom: TabBar(
          indicatorColor: theme.colorScheme.primary,
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
