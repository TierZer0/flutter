import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'package:recipe_book/services/recipes.service.dart';
import 'package:recipe_book/services/user.service.dart';

import 'package:recipe_book/app_model.dart';

import 'package:ui/ui.dart';
import 'package:utils/functions/case.dart';

import '../models/recipe.models.dart';
import 'recipe/recipe.page.dart';

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

  Future<void> _filterDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        var theme = Theme.of(context);
        return AlertDialog(
          title: CustomText(
            text: 'Filter Recipes',
            fontSize: 20.0,
            fontFamily: "Lato",
            color: theme.colorScheme.onBackground,
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
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
              child: CustomText(
                text: "Cancel",
                fontSize: 15.0,
                fontFamily: "Lato",
                color: theme.colorScheme.onSurface,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: CustomText(
                text: "Submit",
                fontSize: 15.0,
                fontFamily: "Lato",
                color: theme.colorScheme.onSurface,
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

  Future<void> _sortDialog(BuildContext context) {
    List<String> _sortables = ['title', 'category', 'created', 'likes', 'prepTime', 'cookTime'];

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        var theme = Theme.of(context);
        return AlertDialog(
          title: CustomText(
            text: 'Sort Recipes',
            fontSize: 20.0,
            fontFamily: "Lato",
            color: theme.colorScheme.onBackground,
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            child: ReactiveForm(
              formGroup: formGroup,
              child: Wrap(
                runSpacing: 15.0,
                children: [
                  ReactiveDropdownField(
                    decoration: InputDecoration(
                      filled: true,
                    ),
                    hint: CustomText(
                      text: "Sort",
                      fontSize: 15.0,
                      fontFamily: "Lato",
                      color: theme.colorScheme.onSurface,
                    ),
                    items: _sortables
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: CustomText(
                              text: properCase(e),
                              fontSize: 20.0,
                              fontFamily: "Lato",
                              color: theme.colorScheme.onBackground,
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
              child: CustomText(
                text: "Cancel",
                fontSize: 15.0,
                fontFamily: "Lato",
                color: theme.colorScheme.onSurface,
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
              child: CustomText(
                text: "Submit",
                fontSize: 15.0,
                fontFamily: "Lato",
                color: theme.colorScheme.onSurface,
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

  Future<void> _previewDialog(BuildContext context, RecipeModel recipe, String recipeId) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        var theme = Theme.of(context);
        return AlertDialog(
          // title: CustomText(
          //   text: recipe.title,
          //   fontSize: 20.0,
          //   fontFamily: "Lato",
          //   color: theme.colorScheme.onBackground,
          // ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            // child: RecipePage(
            //   recipeId: recipeId,
            // ),
          ),
          actions: [
            TextButton(
              child: CustomText(
                text: "Close",
                fontSize: 15.0,
                fontFamily: "Lato",
                color: theme.colorScheme.onSurface,
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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
        elevation: 10,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: 'Welcome, ',
              fontSize: 35.0,
              fontFamily: "Lato",
              color: theme.colorScheme.onBackground,
            ),
            CustomText(
              text: 'What would you like to cook today?',
              fontSize: 25.0,
              fontFamily: "Lato",
              color: theme.colorScheme.onBackground,
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
          stream: recipesService.getRecipes(
            filters: filters,
            sort: formGroup.control('sort').value,
          ),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              var recipes = snapshot.data.docs;
              List<dynamic> _recipes = recipes.map((e) => e.data()).toList();
              _recipes = _recipes.where((element) => element.title!.contains(_search)).toList();
              return GridView.builder(
                itemCount: _recipes.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 300,
                  childAspectRatio: 2 / 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemBuilder: (context, index) {
                  final RecipeModel recipe = _recipes[index];
                  final String recipeId = recipes[index].id;
                  return CustomCard(
                    card: ECard.outlined,
                    child: InkWell(
                      splashColor: theme.colorScheme.primary.withOpacity(0.3),
                      onTap: () => context.push('/recipe/${recipeId}'),
                      onLongPress: () => _previewDialog(context, recipe, recipeId),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            FutureBuilder(
                              future: recipesService.getImage(recipe.image!),
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  final data = snapshot.data;
                                  return Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          5.0,
                                        ),
                                      ),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                          Colors.white.withOpacity(
                                            Theme.of(context).brightness == Brightness.light
                                                ? 0.5
                                                : 0.3,
                                          ),
                                          BlendMode.dstATop,
                                        ),
                                        image: new NetworkImage(
                                          data.toString(),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return SizedBox.shrink();
                              },
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomText(
                                    text: recipe.title,
                                    fontSize: 20.0,
                                    fontFamily: "Lato",
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onBackground,
                                  ),
                                  recipe.category != '' || recipe.description != ''
                                      ? CustomText(
                                          text: recipe.category ?? recipe.description,
                                          fontSize: 15.0,
                                          fontFamily: "Lato",
                                          color: theme.colorScheme.onBackground,
                                        )
                                      : SizedBox.shrink(),
                                ],
                              ),
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: CustomText(
                                text: recipe.likes.toString() + ' likes',
                                fontSize: 15.0,
                                fontFamily: "Lato",
                                color: theme.colorScheme.onBackground,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
