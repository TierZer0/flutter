import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/main.dart';
import 'package:recipe_book/pages/community/sections/category.section.dart';
import 'package:recipe_book/pages/community/sections/popular.section.dart';
import 'package:recipe_book/providers/recipes/recipes.providers.dart' show getRecipesProvider;
import 'package:recipe_book/providers/resources/resources.providers.dart';

import 'package:recipe_book/services/recipes/recipes.service.dart';

import 'package:recipe_book/shared/recipe-card.shared.dart';

import 'package:ui/ui.dart';

import '../../models/models.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

const generalFilters = [
  'Trending',
  'Most Recent',
  'New',
];

class HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  final PageController recipeCtrl = PageController(viewportFraction: 0.7);
  int currentItem = 0;

  bool categoryActive = false;

  // TextEditingController searchController = TextEditingController();
  final formGroup = FormGroup({
    'filter': FormGroup({
      'category': FormControl<String>(),
      'prepTime': FormControl<String>(),
      'cookTime': FormControl<String>(),
      'ingredient': FormControl<String>(),
    }),
    'sort': FormControl<String>(),
  });

  dynamic filters;
  String sort = '';
  String _search = '';

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    setState(() {});
    ref.refresh(getCategoriesProvider);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktopScreen: buildDesktop(context),
      mobileScreen: buildMobile(context),
    );
  }

  Widget buildDesktop(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        notificationPredicate: (notification) {
          return notification.depth != 0;
        },
        backgroundColor: Colors.transparent,
        title: CText(
          'Welcome, What would you like to cook today?',
          textLevel: EText.title,
          weight: FontWeight.bold,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: IconButton(
              onPressed: () => {},
              icon: Icon(Icons.filter_alt_outlined),
              iconSize: 30.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: IconButton(
              onPressed: () => {},
              icon: Icon(Icons.sort_outlined),
              iconSize: 30.0,
            ),
          ),
        ],
      ),
      body: CustomCard(
        card: ECard.filled,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBar(
                // backgroundColor: MaterialStatePropertyAll(theme.colorScheme.),
                elevation: MaterialStatePropertyAll(2.0),
                leading: Icon(Icons.search),
                hintText: "Search Recipes",
                onChanged: (value) {
                  setState(() {
                    _search = value;
                  });
                },
              ),
              SizedBox(height: 10.0),
              Expanded(
                child: StreamBuilder(
                  stream: recipesService.getRecipesStream(
                    filters: filters,
                    sort: formGroup.control('sort').value,
                  ),
                  builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      var recipes = snapshot.data.docs;
                      List<dynamic> _recipes = recipes.map((e) => e.data()).toList();
                      _recipes = _recipes.where((element) => element.title!.toLowerCase().contains(_search.toLowerCase())).toList();
                      return GridView.builder(
                        itemCount: _recipes.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 450,
                          childAspectRatio: 4 / 1.5,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 10,
                        ),
                        itemBuilder: (context, index) {
                          final RecipeModel recipe = _recipes[index];
                          final String recipeId = recipes[index].id;
                          return RecipeCard(
                            recipe: recipe,
                            cardType: ECard.elevated,
                            onTap: () => context.push('/recipe/${recipeId}'),
                            onLongPress: () => {},
                            useImage: true,
                          );
                        },
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMobile(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SmartRefresher(
      controller: _refreshController,
      enablePullDown: true,
      onLoading: _onLoading,
      onRefresh: _onRefresh,
      header: WaterDropMaterialHeader(
        backgroundColor: seed,
        color: colorScheme.onPrimary,
      ),
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            leading: null,
            automaticallyImplyLeading: false,
            pinned: true,
            title: CText(
              'Welcome, \n What would you like to cook today?',
              textLevel: EText.body,
              weight: FontWeight.bold,
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(80.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SearchAnchor.bar(
                  isFullScreen: false,
                  barElevation: MaterialStateProperty.all(2.0),
                  viewElevation: 2.0,
                  viewConstraints: BoxConstraints(maxHeight: 400.0),
                  barHintText: 'Search Recipes',
                  suggestionsBuilder: (context, controller) async {
                    final recipesProvider = ref.read(getRecipesProvider);

                    return recipesProvider.when(
                      data: (result) {
                        switch (result.success) {
                          case true:
                            return result.payload!
                                .where((element) => element.title!.toLowerCase().contains(controller.text.toLowerCase()))
                                .map((recipe) {
                              return ListTile(
                                leading: CircleAvatar(
                                  maxRadius: 40,
                                  foregroundImage: NetworkImage(recipe.image!),
                                ),
                                title: CText(recipe.title!),
                                subtitle: CText(recipe.description!),
                                onTap: () => context.push('/recipe/${recipe.id}'),
                              );
                            }).toList();
                          default:
                            debugPrint('Error: ${result.message}');
                            return [ListTile(title: CText('Error: ${result.message}'))];
                        }
                      },
                      loading: () => [ListTile(title: CText('Loading...'))],
                      error: (error, stackTrace) => [ListTile(title: CText('Error: $error'))],
                    );
                  },
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 150.0,
              child: ByCategorySection(),
            ),
          ),
          SliverToBoxAdapter(child: Gap(15)),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 400.0,
              child: ByPopularitySection(),
            ),
          )
        ],
      ),
    );
  }
}
