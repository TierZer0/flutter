import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/pages/community/comunity.page.dart';
import 'package:recipe_book/pages/favorites/favorites.page.dart';
import 'package:recipe_book/pages/mine/mine.page.dart';
import 'package:recipe_book/pages/search/search.page.dart';
import 'package:ui/general/text.custom.dart';
import 'package:ui/layout/responsive-widget.custom.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

enum menuOptions { profile, settings, logout }

class _MainPageState extends State<MainPage> {
  Map<int, Map<String, dynamic>> _pages = {
    0: {
      'title': 'Community',
      'icon': FontAwesomeIcons.userGroup,
      'view': CommunityPage(),
    },
    1: {
      'title': 'Search',
      'icon': FontAwesomeIcons.magnifyingGlass,
      'view': SearchPage(),
    },
    2: {
      'title': 'Contributions',
      'icon': FontAwesomeIcons.book,
      'view': MinePage(),
    },
    3: {
      'title': 'Favorites',
      'icon': FontAwesomeIcons.solidHeart,
      'view': FavoritesPage(),
    }
  };
  Map<String, dynamic> _currentPage = {};
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = _pages[0]!;
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobileScreen: buildMobile(context),
      desktopScreen: buildDesktop(context),
    );
  }

  handleMobileNav(int index) {
    setState(() {
      _currentPage = _pages[index]!;
      _currentIndex = index;
    });
  }

  Widget buildDesktop(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _currentIndex,
            onDestinationSelected: (value) => handleMobileNav(value),
            labelType: NavigationRailLabelType.selected,
            destinations: _pages.entries
                .map(
                  (e) => NavigationRailDestination(
                    icon: FaIcon(
                      e.value['icon'],
                    ),
                    label: CText(
                      e.value['title'],
                      textLevel: EText.title2,
                    ),
                  ),
                )
                .toList(),
          ),
          VerticalDivider(
            thickness: 1,
            width: 1,
          ),
          Expanded(
            child: _currentPage['view'],
          ),
        ],
      ),
    );
  }

  Widget buildMobile(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CText(
          _currentPage['title'],
          textLevel: EText.title2,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20,
            ),
            child: PopupMenuButton(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                child: FaIcon(
                  FontAwesomeIcons.circleUser,
                ),
              ),
              onSelected: (value) {
                switch (value) {
                  case menuOptions.profile:
                    context.push('/user/profile');
                    break;
                  case menuOptions.settings:
                    break;
                  case menuOptions.logout:
                    break;
                }
              },
              itemBuilder: (context) => <PopupMenuItem<menuOptions>>[
                PopupMenuItem(
                  value: menuOptions.profile,
                  child: Text(
                    'Profile',
                    textScaler: TextScaler.linear(1.1),
                  ),
                ),
                PopupMenuItem(
                  value: menuOptions.settings,
                  child: Text(
                    'Settings',
                    textScaler: TextScaler.linear(1.1),
                  ),
                ),
                PopupMenuItem(
                  value: menuOptions.logout,
                  child: Text(
                    'Logout',
                    textScaler: TextScaler.linear(1.1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _currentPage['view'],
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/new/recipe'),
        child: FaIcon(FontAwesomeIcons.plus),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (value) => handleMobileNav(value),
        destinations: _pages.entries
            .map(
              (e) => NavigationDestination(
                icon: FaIcon(
                  e.value['icon'],
                ),
                label: e.value['title'],
              ),
            )
            .toList(),
      ),
    );
  }
}
