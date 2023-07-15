import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/views/recipe/tabs/recipe.tab.dart';
import 'package:recipe_book/views/recipe/tabs/reviews.tab.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/services/recipes.service.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:ui/ui.dart';

class RecipePage extends StatefulWidget {
  final String recipeId;

  RecipePage({required this.recipeId});

  @override
  RecipePageState createState() => RecipePageState();
}

class RecipePageState extends State<RecipePage> with TickerProviderStateMixin {
  late TabController _tabController;
  bool canEdit = false;
  bool liked = false;
  RecipeModel? recipe = null;

  // bool showAddReview = false;
  String fab = 'made';
  bool hasMade = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    userService.hasLiked(widget.recipeId).then(
          (result) => setState(() {
            liked = result;
          }),
        );

    userService.hasMade(widget.recipeId).then(
          (result) => setState(() {
            hasMade = result;
            fab = result ? '' : 'made';
          }),
        );

    getRecipe();
  }

  getRecipe() {
    bool _canEdit = false;
    recipesService.getRecipe(widget.recipeId).then((result) {
      if (result.createdBy == authService.user?.uid) {
        _canEdit = true;
      } else {
        recipesService.incrementView(widget.recipeId);
      }
      setState(() {
        recipe = result;
        canEdit = _canEdit;
      });
    });
  }

  Widget? buildFAB() {
    switch (fab) {
      case 'review':
        return FloatingActionButton.extended(
          onPressed: () => _reviewDialogBuilder(context),
          icon: Icon(Icons.add_outlined),
          label: CText(
            'Add Review',
            textLevel: EText.button,
          ),
        );
      case 'made':
        return hasMade
            ? null
            : FloatingActionButton.extended(
                onPressed: () => userService.madeRecipe(widget.recipeId),
                icon: Icon(Icons.check),
                label: CText(
                  'Made Recipe',
                  textLevel: EText.button,
                ),
              );
      default:
        return null;
    }
  }

  Future<void> _reviewDialogBuilder(BuildContext context) {
    FormGroup formGroup = FormGroup({
      'review': FormControl(validators: [Validators.required]),
      'stars': FormControl(value: 0, validators: [Validators.required])
    });

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        var theme = Theme.of(context);
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          title: CText(
            "Review Recipe",
            textLevel: EText.title2,
          ),
          content: SizedBox(
            height: 250,
            width: 300,
            child: ReactiveForm(
              formGroup: formGroup,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CustomReactiveInput(
                    maxLines: 3,
                    inputAction: TextInputAction.done,
                    formName: 'review',
                    label: 'Review',
                    textColor: theme.colorScheme.onSurface,
                  ),
                  SizedBox(
                    height: 25.0,
                  ),
                  ReactiveDropdownField(
                    decoration: InputDecoration(
                      labelText: 'Rating',
                      filled: true,
                    ),
                    formControlName: 'stars',
                    dropdownColor: theme.colorScheme.surface,
                    items: List<DropdownMenuItem>.generate(
                      5,
                      (index) => DropdownMenuItem(
                        child: CText(
                          "${index + 1} of 5 Stars",
                          textLevel: EText.body,
                        ),
                        value: index,
                      ),
                    ).toList(),
                  )
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: CText(
                "Cancel",
                textLevel: EText.button,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: CText(
                "Submit",
                textLevel: EText.button,
              ),
              onPressed: () {
                AbstractControl<dynamic> _form = formGroup;
                ReviewModel review = ReviewModel(
                  review: _form.value['review'],
                  stars: _form.value['stars'],
                  createdBy: authService.user!.uid,
                );
                recipesService.addReview(review, widget.recipeId);
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
    _tabController.addListener(() {
      var _fab = '';
      switch (_tabController.index) {
        case 0:
          _fab = 'made';
          break;
        case 1:
          _fab = 'review';
          break;
        default:
          _fab = '';
          break;
      }
      setState(() {
        fab = _fab;
      });
    });

    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1200) {
        return buildDesktop(context);
        // } else if (constraints.maxWidth > 800 && constraints.maxWidth < 1200) {
        //   return buildTablet(context);
        // } else {
      } else {
        return buildMobile(context);
      }
    });
  }

  int _selectedIndex = 0;

  Widget buildDesktop(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CText(
          recipe?.title ?? '',
          textLevel: EText.title,
        ),
      ),
      body: Row(
        children: [
          NavigationRail(
            labelType: NavigationRailLabelType.selected,
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            destinations: <NavigationRailDestination>[
              NavigationRailDestination(
                icon: Icon(Icons.restaurant_outlined),
                label: CText(
                  'Recipe',
                  textLevel: EText.title,
                ),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.reviews_outlined),
                label: CText(
                  'Reviews',
                  textLevel: EText.title,
                ),
              ),
            ],
          ),
          Expanded(
            child: recipe != null
                ? CustomCard(
                    card: ECard.filled,
                    child: [
                      RecipeTab(recipe: recipe!),
                      ReviewsTab(id: widget.recipeId),
                    ][_selectedIndex])
                : Center(child: CircularProgressIndicator()),
          )
        ],
      ),
    );
  }

  Widget buildMobile(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        toolbarHeight: 75,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CText(
              recipe?.title ?? '',
              textLevel: EText.title,
            ),
            recipe?.description != ''
                ? CText(
                    recipe?.description ?? '',
                    textLevel: EText.subtitle,
                  )
                : SizedBox.shrink()
          ],
        ),
        actions: [
          Wrap(
            spacing: 10.0,
            children: [
              IconButton(
                onPressed: () {
                  userService.likeRecipe(widget.recipeId, !liked);
                  setState(() {
                    liked = !liked;
                  });
                },
                icon: Icon(
                  liked ? Icons.favorite : Icons.favorite_outline_outlined,
                  fill: 1.0,
                  color: theme.colorScheme.secondary,
                ),
              ),
              canEdit
                  ? SizedBox.shrink()
                  : IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.add_outlined),
                    ),
              canEdit
                  ? IconButton(
                      onPressed: () => context.replace('/newRecipe/${widget.recipeId}'),
                      icon: Icon(
                        Icons.edit_outlined,
                      ),
                    )
                  : SizedBox.shrink(),
            ],
          ),
        ],
        bottom: TabBar(
          indicatorColor: theme.colorScheme.primary,
          controller: _tabController,
          tabs: [
            Tab(
              text: "Recipe",
            ),
            Tab(
              text: "Reviews",
            ),
            // Tab(
            //   text: 'Info',
            // )
          ],
        ),
      ),
      floatingActionButton: buildFAB(),
      body: recipe != null
          ? TabBarView(
              controller: _tabController,
              children: [
                RecipeTab(
                  recipe: recipe!,
                ),
                ReviewsTab(id: widget.recipeId),
                // SizedBox(),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
