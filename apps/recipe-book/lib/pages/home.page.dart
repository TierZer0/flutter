import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'package:recipe_book/services/recipes.service.dart';
import 'package:recipe_book/services/user.service.dart';

import 'package:recipe_book/app_model.dart';
import 'package:recipe_book/shared/recipe-card.shared.dart';

import 'package:ui/ui.dart';
import 'package:utils/functions/case.dart';

import '../models/recipe.models.dart';
import '../views/recipe/recipe.view.dart';

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
        var theme = Theme.of(context);
        return AlertDialog(
          title: CText(
            recipe.title!,
            textLevel: EText.title2,
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * (isMobile ? 0.9 : 0.4),
            // child: RecipePage(
            //   recipeId: recipeId,
            // ),
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
    var theme = Theme.of(context);
    userService.getUserTheme.then((theme) {
      context.read<AppModel>().theme = theme;
    }).catchError((e) => print(e));

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
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppBar(
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: SearchBar(
                backgroundColor: MaterialStatePropertyAll(theme.colorScheme.surfaceVariant),
                elevation: MaterialStatePropertyAll(2.0),
                leading: Icon(Icons.search),
                hintText: "Search Recipes",
                onChanged: (value) {
                  setState(() {
                    _search = value;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 0.0,
              ),
              child: StreamBuilder(
                stream: recipesService.getAllRecipes(
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
                        maxCrossAxisExtent: 300,
                        childAspectRatio: 3 / 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
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
          ),
        ],
      ),
    );
  }

  Widget buildMobile(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 85.0,
        elevation: 10,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CText(
              'Welcome, ',
              textLevel: EText.title,
            ),
            CText(
              'What would you like to cook today?',
              textLevel: EText.subtitle,
            ),
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.0,
            ),
            child: IconButton(
              onPressed: () => _filterDialog(context),
              icon: Icon(Icons.filter_alt_outlined),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 5.0,
            ),
            child: IconButton(
              onPressed: () => _sortDialog(context),
              icon: Icon(Icons.sort_outlined),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: SearchBar(
              // controller: searchController,
              elevation: MaterialStatePropertyAll(1.0),
              leading: Icon(Icons.search),
              hintText: "Search Recipes",
              onChanged: (value) {
                setState(() {
                  _search = value;
                });
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 0.0,
        ),
        child: StreamBuilder(
          stream: recipesService.getAllRecipes(
            filters: filters,
            sort: formGroup.control('sort').value,
          ),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              var recipes = snapshot.data.docs;
              List<dynamic> _recipes = recipes.map((e) => e.data()).toList();
              _recipes = _recipes
                  .where((element) => element.title!.toLowerCase().contains(_search.toLowerCase()))
                  .toList();
              return GridView.builder(
                itemCount: _recipes.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 3 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  final RecipeModel recipe = _recipes[index];
                  final String recipeId = recipes[index].id;
                  return RecipeCard(
                    recipe: recipe,
                    cardType: ECard.elevated,
                    onTap: () => context.push('/recipe/${recipeId}'),
                    onLongPress: () => _previewDialog(context, recipe, recipeId),
                    useImage: true,
                  );
                },
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}
