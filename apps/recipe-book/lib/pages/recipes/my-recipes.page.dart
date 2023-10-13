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

enum EMyRecipeViews { Recipes, Books }

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

  EMyRecipeViews _currentView = EMyRecipeViews.Recipes;
  buildView() {
    switch (_currentView) {
      case EMyRecipeViews.Recipes:
        return MyRecipesTab(
          search: _search,
        );
      case EMyRecipeViews.Books:
        return MyRecipeBooksTab(
          search: _search,
        );
    }
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
          return notification.depth >= 0;
        },
        title: CText(
          'My Recipes',
          textLevel: EText.title,
          weight: FontWeight.bold,
        ),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 12.0,
                ),
                child: SegmentedButton<EMyRecipeViews>(
                  segments: const <ButtonSegment<EMyRecipeViews>>[
                    ButtonSegment<EMyRecipeViews>(
                      value: EMyRecipeViews.Recipes,
                      label: CText(
                        'Recipes',
                        textLevel: EText.button,
                      ),
                    ),
                    ButtonSegment<EMyRecipeViews>(
                      value: EMyRecipeViews.Books,
                      label: CText(
                        'Recipe Books',
                        textLevel: EText.button,
                      ),
                    )
                  ],
                  selected: <EMyRecipeViews>{_currentView},
                  onSelectionChanged: (Set<EMyRecipeViews> newSelection) {
                    setState(() {
                      _currentView = newSelection.first;
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: buildView(),
    );
  }
}
