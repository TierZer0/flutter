import 'package:flutter/material.dart';
import 'package:recipe_book/main.dart';
import 'package:recipe_book/pages/recipes/tabs/my-recipe-books.tab.dart';
import 'package:recipe_book/pages/recipes/tabs/my-recipes.tab.dart';
import 'package:ui/general/text.custom.dart';

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

  Widget buildDesktop(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
            backgroundColor: Colors.transparent,
            title: CText(
              'My Recipes',
              textLevel: EText.title,
              weight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * .25,
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  text: 'Recipes',
                  // icon: Icon(Icons.dinner_dining_outlined),
                ),
                Tab(
                  text: 'Recipe Books',
                  // icon: Icon(Icons.menu_book_sharp),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
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
          )
        ],
      ),
    );
  }

  Widget buildMobile(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        elevation: 5,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(
              text: 'Recipes',
              icon: Icon(Icons.dinner_dining_outlined),
            ),
            Tab(
              text: 'Recipe Books',
              icon: Icon(Icons.menu_book_sharp),
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
