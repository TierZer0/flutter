import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/views/recipe/tabs/recipe.tab.dart';
import 'package:recipe_book/views/recipe/tabs/reviews.tab.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/services/recipes.service.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:ui/ui.dart';

class RecipePage extends StatefulWidget {
  final String recipeId;
  // final String source;

  RecipePage({required this.recipeId});

  @override
  RecipePageState createState() => RecipePageState();
}

class RecipePageState extends State<RecipePage> with TickerProviderStateMixin {
  late TabController _tabController;
  bool canEdit = false;
  bool liked = false;
  RecipeModel? recipe = null;

  bool showAddReview = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    userService.hasLiked(widget.recipeId).then((result) => liked = result);

    getRecipe();
    trackView();
  }

  getRecipe() {
    bool _canEdit = false;
    recipesService.getRecipe(widget.recipeId).then((result) {
      if (result.createdBy == authService.user?.uid) {
        _canEdit = true;
      }
      setState(() {
        recipe = result;
        canEdit = _canEdit;
      });
    });
  }

  trackView() async {
    //   try {
    //     var instance = FirebaseFunctions.instance;
    //     FirebaseFunctions.
    //     // instance.useFunctionsEmulator('localhost', 5001);
    //     print(FirebaseAuth.instance.currentUser);
    //     final result = await instance.httpsCallable('viewOnRecipe').call([
    //       {"recipeId": widget.recipeId}
    //     ]);
    //   } on FirebaseFunctionsException catch (error) {
    //     print(error.code);
    //     print(error.details);
    //     print(error.message);
    //   }
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
          title: CustomText(
            text: "Review Recipe",
            fontSize: 20.0,
            fontFamily: "Lato",
            color: theme.colorScheme.onSurface,
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
                      label: CustomText(
                        text: "Rating",
                        fontSize: 20.0,
                        fontFamily: "Lato",
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                    formControlName: 'stars',
                    dropdownColor: theme.colorScheme.surface,
                    items: List<DropdownMenuItem>.generate(
                      6,
                      (index) => DropdownMenuItem(
                        child: CustomText(
                          text: "$index of 5 Stars",
                          fontSize: 20.0,
                          fontFamily: "Lato",
                          color: theme.colorScheme.onSurface,
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
    var theme = Theme.of(context);
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        setState(() {
          showAddReview = true;
        });
      } else {
        setState(() {
          showAddReview = false;
        });
      }
    });

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: Hero(
          tag: 'recipe-${widget.recipeId}',
          child: AppBar(
            shadowColor: Colors.black12,
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: recipe?.title ?? '',
                  fontSize: 35.0,
                  fontFamily: "Lato",
                  color: theme.colorScheme.onBackground,
                ),
                recipe?.description != ''
                    ? CustomText(
                        text: recipe?.description ?? '',
                        fontSize: 20.0,
                        fontFamily: "Lato",
                        color: theme.colorScheme.onBackground,
                      )
                    : SizedBox.shrink()
              ],
            ),
            actions: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 5.0,
                ),
                child: IconButton(
                  onPressed: () {
                    userService.likeRecipe(widget.recipeId);
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
              ),
              canEdit
                  ? Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.0,
                      ),
                      child: IconButton(
                        onPressed: () => context.replace('/newRecipe/${widget.recipeId}'),
                        icon: Icon(
                          Icons.edit_outlined,
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
            ],
            elevation: 0,
            toolbarHeight: 85.0,
            bottom: TabBar(
              indicatorColor: theme.colorScheme.primary,
              controller: _tabController,
              tabs: [
                Tab(
                  text: "Recipe",
                  icon: Icon(Icons.dinner_dining_outlined),
                ),
                Tab(
                  text: "Reviews",
                  icon: Icon(Icons.reviews_outlined),
                ),
                Tab(
                  text: 'Info',
                  icon: Icon(Icons.info_outline_rounded),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: showAddReview
          ? FloatingActionButton(
              onPressed: () => _reviewDialogBuilder(context),
              child: Icon(Icons.add_outlined),
            )
          : null,
      body: recipe != null
          ? TabBarView(
              controller: _tabController,
              children: [
                RecipeTab(
                  recipe: recipe!,
                ),
                ReviewsTab(id: widget.recipeId),
                SizedBox(),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
