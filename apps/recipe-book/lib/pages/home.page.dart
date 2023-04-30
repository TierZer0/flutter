import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/services/recipes.service.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:ui/ui.dart';

import 'package:recipe_book/app_model.dart';

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
    userService.categories.then((result) => setState(() => _categories.addAll(result)));
  }

  final PageController recipeCtrl = PageController(viewportFraction: 0.7);
  int currentItem = 0;

  bool categoryActive = false;

  final formGroup = FormGroup({
    'search': FormControl<String>(),
  });

  final List<String> _generalFilters = <String>['Trending', 'New'];
  String? _generalFilter = 'Trending';

  List<String> _categories = ['All'];
  String? _categoryFilter = 'All';

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    userService.getUserTheme.then((theme) {
      context.read<AppModel>().theme = theme;
    }).catchError((e) => print(e));
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 60.0,
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
              text: 'What do you want to cook today?',
              fontSize: 25.0,
              fontFamily: "Lato",
              color: theme.colorScheme.onBackground,
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100.0),
          child: ReactiveForm(
              formGroup: formGroup,
              child: Container(
                padding: EdgeInsets.only(
                  left: 20.0,
                  right: 20.0,
                  bottom: 20.0,
                ),
                child: CustomReactiveInput(
                  inputAction: TextInputAction.done,
                  formName: 'search',
                  label: 'Search',
                  textColor: theme.colorScheme.onSurface,
                ),
              )),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 0.0,
          vertical: 15.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
              ),
              child: Wrap(
                spacing: 10.0,
                children: _generalFilters
                    .map(
                      (filter) => ChoiceChip(
                        label: CustomText(
                          text: filter,
                          fontSize: 18.0,
                          fontFamily: "Lato",
                          color: _generalFilter == filter
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onBackground,
                        ),
                        selected: _generalFilter == filter,
                        onSelected: (bool selected) {
                          setState(() {
                            _generalFilter = selected ? filter : null;
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(
              height: 250,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: FutureBuilder(
                  future: recipesService.getRecipesByFilter(_generalFilter!),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final docs = snapshot.data!.docs;
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: docs.map((doc) {
                          final recipe = doc.data();
                          return Hero(
                            tag: 'recipe-${doc.id}-general',
                            child: Card(
                              margin: EdgeInsets.only(
                                right: 5.0,
                                bottom: 15.0,
                                left: 20.0,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () => context.push('/recipe/${doc.id}/general'),
                                child: SizedBox(
                                  width: 200,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 10.0,
                                    ),
                                    child: Column(
                                      children: [
                                        CustomText(
                                          text: recipe.title,
                                          fontSize: 18.0,
                                          fontFamily: "Lato",
                                          color: theme.colorScheme.onSurface,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
              ),
              child: Wrap(
                spacing: 10.0,
                children: _categories
                    .map(
                      (filter) => ChoiceChip(
                        label: CustomText(
                          text: filter,
                          fontSize: 18.0,
                          fontFamily: "Lato",
                          color: _categoryFilter == filter
                              ? theme.colorScheme.onPrimary
                              : theme.colorScheme.onBackground,
                        ),
                        selected: _categoryFilter == filter,
                        onSelected: (bool selected) {
                          setState(() {
                            _categoryFilter = selected ? filter : null;
                          });
                        },
                      ),
                    )
                    .toList(),
              ),
            ),
            SizedBox(
              height: 300,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                child: FutureBuilder(
                  future: recipesService.getRecipesByUser(
                    userUid: authService.user!.uid,
                    category: _categoryFilter != 'All' ? _categoryFilter : null,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final docs = snapshot.data!.docs;
                      return ListView(
                        scrollDirection: Axis.horizontal,
                        children: docs.map((doc) {
                          final recipe = doc.data();
                          return Hero(
                            tag: 'recipe-${doc.id}-user',
                            child: Card(
                              margin: EdgeInsets.only(
                                right: 5.0,
                                bottom: 15.0,
                                left: 20.0,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () => context.push('/recipe/${doc.id}/user'),
                                child: SizedBox(
                                  width: 200,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10.0,
                                      horizontal: 10.0,
                                    ),
                                    child: Column(
                                      children: [
                                        CustomText(
                                          text: recipe.title,
                                          fontSize: 18.0,
                                          fontFamily: "Lato",
                                          color: theme.colorScheme.onSurface,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
