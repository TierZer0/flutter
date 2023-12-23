import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/main.dart';
import 'package:recipe_book/pages/community/sections/category.section.dart';
import 'package:recipe_book/pages/community/sections/popular.section.dart';

import 'package:recipe_book/services/recipes/recipes.service.dart';

import 'package:recipe_book/app_model.dart';
import 'package:recipe_book/services/user/profile.service.dart';
import 'package:recipe_book/shared/recipe-accordion.shared.dart';
import 'package:recipe_book/shared/recipe-card.shared.dart';

import 'package:ui/ui.dart';
import 'package:utils/functions/case.dart';

import '../../models/models.dart';
import '../../shared/recipe-preview.shared.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

const generalFilters = [
  'Trending',
  'Most Recent',
  'New',
];

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    // userService.categories.then((result) => setState(() => _categories.addAll(result)));
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
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // setState(() {});
    _refreshController.loadComplete();
  }

  Future<void> _filterDialog(BuildContext context, {bool isMobile = true}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        var theme = Theme.of(context);
        return AlertDialog(
          title: CText(
            'Filter Recipes',
            textLevel: EText.subtitle,
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * (isMobile ? 0.9 : 0.4),
            child: ReactiveForm(
              formGroup: formGroup.control('filter') as FormGroup,
              child: Wrap(
                runSpacing: 15.0,
                children: [
                  CustomReactiveInput(
                    formName: 'category',
                    inputAction: TextInputAction.next,
                    label: 'Category',
                    textColor: theme.colorScheme.onBackground,
                  ),
                  CustomReactiveInput(
                    formName: 'prepTime',
                    inputAction: TextInputAction.next,
                    label: 'Prep Time',
                    keyboardType: TextInputType.number,
                    textColor: theme.colorScheme.onBackground,
                  ),
                  CustomReactiveInput(
                    formName: 'cookTime',
                    inputAction: TextInputAction.next,
                    label: 'Cook Time',
                    keyboardType: TextInputType.number,
                    textColor: theme.colorScheme.onBackground,
                  ),
                  CustomReactiveInput(
                    formName: 'ingredient',
                    inputAction: TextInputAction.next,
                    label: 'Ingredient',
                    textColor: theme.colorScheme.onBackground,
                  )
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: CText(
                'Cancel',
                textLevel: EText.button,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: CText(
                'Submit',
                textLevel: EText.button,
              ),
              onPressed: () {
                setState(() {
                  filters = formGroup.control('filter').value;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _sortDialog(BuildContext context, {bool isMobile = true}) {
    List<String> _sortables = ['title', 'category', 'created', 'likes', 'prepTime', 'cookTime'];

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        var theme = Theme.of(context);
        return AlertDialog(
          title: CText(
            'Sort Recipes',
            textLevel: EText.subtitle,
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * (isMobile ? 0.9 : 0.4),
            child: ReactiveForm(
              formGroup: formGroup,
              child: Wrap(
                runSpacing: 15.0,
                children: [
                  ReactiveDropdownField(
                    decoration: InputDecoration(
                      labelText: 'Sort',
                      filled: true,
                    ),
                    items: _sortables
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: CText(
                              properCase(e),
                              textLevel: EText.body,
                            ),
                          ),
                        )
                        .toList(),
                    formControlName: 'sort',
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: CText(
                'Cancel',
                textLevel: EText.button,
              ),
              onPressed: () {
                formGroup.control('sort').reset();
                setState(() {
                  sort = '';
                });
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: CText(
                'Submit',
                textLevel: EText.button,
              ),
              onPressed: () {
                setState(() {
                  sort = formGroup.control('sort').value;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _previewDialog(BuildContext context, RecipeModel recipe, String recipeId,
      {bool isMobile = true}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CText(
            recipe.title!,
            textLevel: EText.title2,
          ),
          content: RecipePreviewShared(
            recipe: recipe,
          ),
          actions: [
            TextButton(
              child: CText(
                'Close',
                textLevel: EText.button,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // profileService.userTheme.then((theme) => context.read<AppModel>().theme = theme);

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
              onPressed: () => _filterDialog(context, isMobile: false),
              icon: Icon(Icons.filter_alt_outlined),
              iconSize: 30.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: IconButton(
              onPressed: () => _sortDialog(context, isMobile: false),
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
                      _recipes = _recipes
                          .where((element) =>
                              element.title!.toLowerCase().contains(_search.toLowerCase()))
                          .toList();
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
                            onLongPress: () =>
                                _previewDialog(context, recipe, recipeId, isMobile: false),
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
                    final recipes = (await recipesService.getRecipesFuture()).docs.where(
                        (element) => element
                            .data()
                            .title!
                            .toLowerCase()
                            .contains(controller.text.toLowerCase()));
                    final _recipes = recipes.map((e) => e.data()).toList();

                    return _recipes.map((recipe) {
                      return ListTile(
                        leading: CircleAvatar(
                          maxRadius: 40,
                          foregroundImage: NetworkImage(recipe.image!),
                        ),
                        title: CText(recipe.title!),
                        subtitle: CText(recipe.description!),
                        onTap: () => context.push(
                            '/recipe/${recipes.where((element) => element.data().title == recipe.title).first.id}'),
                      );
                    }).toList();
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
