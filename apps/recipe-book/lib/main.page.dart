import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:recipe_book/pages/community/comunity.page.dart';
import 'package:recipe_book/pages2/community/community.page.dart';
import 'package:recipe_book/pages2/recipes/my-recipes.page.dart';
import 'package:recipe_book/providers/recipes/recipes.providers.dart';
import 'package:recipe_book/shared/search.shared.dart';
import 'package:ui/general/text.custom.dart';
import 'package:ui/layout/responsive-widget.custom.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  Map<int, Map<String, dynamic>> _pages = {
    0: {
      'title': 'Community',
      'icon': FontAwesomeIcons.userGroup,
      'view': CommunityPage(),
    },
    1: {
      'title': 'My Recipes',
      'icon': FontAwesomeIcons.book,
      'view': RecipesView(),
    },
    2: {
      'title': 'Favorites',
      'icon': FontAwesomeIcons.solidHeart,
      'view': HomePage(),
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
    );
  }

  handleMobileNav(int index) {
    setState(() {
      _currentPage = _pages[index]!;
      _currentIndex = index;
    });
  }

  Widget buildMobile(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CText(
          _currentPage['title'],
          textLevel: EText.title2,
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(75.0),
          child: SearchWidget(),
        ),
      ),
      body: Stack(
        children: [
          _currentPage['view'],
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: 500,
              width: double.infinity,
              child: DraggableScrollableSheet(
                initialChildSize: 0.1,
                minChildSize: 0.1,
                maxChildSize: 0.9,
                builder: (context, scrollController) {
                  return Container(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      child: SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: [
                            Gap(10),
                            FaIcon(
                              FontAwesomeIcons.gripLines,
                              color: Colors.white,
                              size: 30,
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        currentIndex: _currentIndex,
        onTap: (value) => handleMobileNav(value),
        items: _pages.entries
            .map(
              (e) => BottomNavigationBarItem(
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
