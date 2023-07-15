import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:recipe_book/pages/profile/tabs/books.tab.dart';
import 'package:recipe_book/pages/profile/tabs/categories.tab.dart';
import 'package:recipe_book/pages/profile/tabs/info.tab.dart';
import 'package:recipe_book/pages/profile/tabs/settings.tab.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:ui/ui.dart';

import '../../models/user.models.dart';

class ProfileView extends StatefulWidget {
  @override
  ProfileViewState createState() => ProfileViewState();
}

class ProfileViewState extends State<ProfileView> with TickerProviderStateMixin {
  late TabController _tabController;
  int _selectedIndex = 0;

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
    return Scaffold(
      appBar: AppBar(
        title: CText(
          authService.user?.displayName ?? authService.user?.email ?? '',
          textLevel: EText.title,
          weight: FontWeight.bold,
        ),
      ),
      body: Row(
        children: [
          NavigationRail(
            labelType: NavigationRailLabelType.selected,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.info_outline),
                label: CText(
                  'Info',
                  textLevel: EText.button,
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.category_outlined),
                label: CText(
                  'Categories',
                  textLevel: EText.button,
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.menu_book_sharp),
                label: CText(
                  'Books',
                  textLevel: EText.button,
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.settings),
                label: CText(
                  'Settings',
                  textLevel: EText.button,
                ),
              ),
            ],
            selectedIndex: _selectedIndex,
          ),
          Expanded(
            child: CustomCard(
              card: ECard.filled,
              child: StreamBuilder(
                stream: userService.getUserStream,
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final UserModel user = snapshot.data!.data() as UserModel;
                    final _destinations = [
                      InfoTab(
                        user: user,
                      ),
                      CategoriesTab(
                        user: user,
                      ),
                      BooksTab(),
                      SettingsTab(),
                    ];
                    return _destinations[_selectedIndex];
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              // child: _destinations[_selectedIndex],
            ),
          )
        ],
      ),
    );
    // return ;
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
        elevation: 0,
        toolbarHeight: 50.0,
        notificationPredicate: (ScrollNotification notification) {
          return notification.depth == 1;
        },
        bottom: TabBar(
          controller: _tabController,
          dividerColor: Colors.transparent,
          tabs: const [
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
      body: StreamBuilder(
        stream: userService.getUserStream,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            final UserModel user = snapshot.data!.data() as UserModel;
            return TabBarView(
              controller: _tabController,
              children: [
                InfoTab(
                  user: user,
                ),
                CategoriesTab(
                  user: user,
                ),
                BooksTab(),
                SettingsTab(),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: CText(
                'Error: ${snapshot.error}',
                textLevel: EText.title,
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
