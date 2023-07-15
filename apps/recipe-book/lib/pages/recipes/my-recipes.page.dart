import 'package:flutter/material.dart';
import 'package:recipe_book/main.dart';
import 'package:recipe_book/pages/recipes/tabs/my-recipe-books.tab.dart';
import 'package:recipe_book/pages/recipes/tabs/my-recipes.tab.dart';
import 'package:ui/general/text.custom.dart';
import 'package:ui/ui.dart';

class RecipesView extends StatefulWidget {
  const RecipesView({super.key});

  @override
  State<RecipesView> createState() => RecipesViewState();
}

class RecipesViewState extends State<RecipesView> with TickerProviderStateMixin {
  late TabController _tabController;
  String _search = '';

  TextEditingController _searchController = TextEditingController();
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    _tabController.addListener(() {
      setState(() {
        _searchController.text = '';
        _focusNode.unfocus();
        _search = '';
      });
    });
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 660) {
        return buildDesktop(context);
      } else {
        return buildMobile(context);
      }
    });
  }

  var _selectedIndex = 0;
  Widget buildDesktop(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: CText(
          'My Recipes',
          textLevel: EText.title,
          weight: FontWeight.bold,
        ),
      ),
      body: Row(
        children: [
          NavigationRail(
            labelType: NavigationRailLabelType.selected,
            onDestinationSelected: (value) {
              setState(() {
                _selectedIndex = value;
              });
            },
            selectedIndex: _selectedIndex,
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.dinner_dining_outlined),
                label: CText(
                  'Recipes',
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
            ],
          ),
          Expanded(
            child: CustomCard(
              card: ECard.filled,
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  MyRecipesTab(
                    search: _search,
                  ),
                  MyRecipeBooksTab(
                    search: _search,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildMobile(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        notificationPredicate: (ScrollNotification notification) {
          return notification.depth == 1;
        },
        title: Wrap(
          runSpacing: 10.0,
          children: [
            CText(
              'My Recipes',
              textLevel: EText.title,
              weight: FontWeight.bold,
            ),
            SearchBar(
              elevation: MaterialStateProperty.all(1.0),
              leading: Icon(Icons.search),
              hintText: "Search Recipes",
              controller: _searchController,
              focusNode: _focusNode,
              onChanged: (value) {
                setState(() {
                  _search = value;
                });
              },
            )
          ],
        ),
        toolbarHeight: 110.0,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          dividerColor: Colors.transparent,
          tabs: [
            Tab(
              text: 'Recipes',
            ),
            Tab(
              text: 'Recipe Books',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MyRecipesTab(
            search: _search,
          ),
          MyRecipeBooksTab(
            search: _search,
          ),
        ],
      ),
    );
  }
}
