import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/services/user/authentication.service.dart';
import 'package:recipe_book/services/user/recipe-books.service.dart';
import 'package:recipe_book/shared/items-grid.shared.dart';
import 'package:recipe_book/shared/table.shared.dart';
import 'package:recipe_book/views/recipe/tabs/recipe.tab.dart';
import 'package:recipe_book/views/recipe/tabs/reviews.tab.dart';
import 'package:recipe_book/services/user/recipes.service.dart';
import 'package:recipe_book/services/user/profile.service.dart';

import 'package:ui/ui.dart';

import '../../models/models.dart';

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
  RecipeModel? recipe;
  List<RecipeBookModel> recipeBooks = [];
  String userUid = authenticationService.userUid;
  late List<Widget> _recipeCards;

  // bool showAddReview = false;
  String fab = 'made';
  bool hasMade = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    profileService.hasLiked(widget.recipeId).then(
          (result) => setState(() {
            liked = result;
          }),
        );

    // profileService.hasMade(widget.recipeId).then(
    //       (result) => setState(() {
    //         hasMade = result;
    //         fab = result ? '' : 'made';
    //       }),
    //     );
    recipeBookService
        .getRecipeBooks()
        .then((result) => setState(() => recipeBooks = result.docs.map((e) {
              RecipeBookModel recipe = e.data();
              recipe.id = e.id;
              return recipe;
            }).toList()));

    getRecipe();
  }

  getRecipe() {
    bool _canEdit = false;
    recipesService.getRecipe(widget.recipeId).then((result) {
      print(result.recipeBook);
      if (result.createdBy == userUid) {
        _canEdit = true;
      } else {
        recipesService.incrementViews(widget.recipeId);
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
                onPressed: () => profileService.markRecipeAsMade(widget.recipeId),
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

  Future<void> _addDialogBuilder(BuildContext context) {
    FormGroup formGroup = FormGroup({
      'recipeBook': FormControl<String>(validators: [Validators.required])
    });
    print(recipeBooks);

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        var theme = Theme.of(context);
        return ReactiveForm(
          formGroup: formGroup,
          child: AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            title: CText(
              "Add to Recipe Book",
              textLevel: EText.title2,
            ),
            content: SizedBox(
              // height: 250,
              width: 300,
              child: ReactiveDropdownField(
                decoration: InputDecoration(
                  labelText: 'Recipe Book',
                  filled: true,
                ),
                formControlName: 'recipeBook',
                dropdownColor: theme.colorScheme.surface,
                selectedItemBuilder: (context) {
                  return recipeBooks
                      .map(
                        (e) => CText(
                          e.name!,
                          textLevel: EText.body,
                        ),
                      )
                      .toList();
                },
                items: recipeBooks
                    .map(
                      (e) => DropdownMenuItem(
                        value: e.id,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CText(
                              e.name!,
                              textLevel: EText.body,
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
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
              ReactiveFormConsumer(
                builder: (context, formGroup, child) {
                  return TextButton(
                    child: CText(
                      "Submit",
                      textLevel: EText.button,
                    ),
                    onPressed: formGroup.valid
                        ? () {
                            AbstractControl<dynamic> _form = formGroup;
                            recipeBookService.addRecipeToRecipeBook(
                                widget.recipeId, _form.value['recipeBook']);
                            Navigator.of(context).pop();
                          }
                        : null,
                  );
                },
              )
            ],
          ),
        );
      },
    );
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
                  createdBy: userUid,
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
    return ResponsiveWidget(
      desktopScreen: buildDesktop(context),
      mobileScreen: buildMobile(context),
    );
  }

  int _selectedIndex = 0;

  Widget buildDesktop(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: CText(
          recipe != null ? recipe!.title! : '',
          textLevel: EText.title,
        ),
        actions: [
          Wrap(
            spacing: 10.0,
            children: [
              IconButton(
                onPressed: () {
                  profileService.likeRecipe(widget.recipeId, !liked);
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
                      onPressed: () => _addDialogBuilder(context),
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
      ),
      floatingActionButton: buildFAB(),
      body: recipe != null
          ? Row(
              children: [
                NavigationRail(
                  labelType: NavigationRailLabelType.selected,
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (int index) {
                    var _fab = '';
                    switch (index) {
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
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget buildMobile(BuildContext context) {
    var theme = Theme.of(context);
    _recipeCards = [
      CustomCard(
        card: ECard.elevated,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CText(
              recipe!.description!,
              textLevel: EText.title,
            ),
            SizedBox(
              height: 150,
              child: FieldGridShared<RecipeModel>(
                fields: ['category', 'prepTime', 'cookTime'],
                data: new Map.from(recipe!.toFirestore()),
              ),
            )
          ],
        ),
      ),
      CustomCard(
        card: ECard.elevated,
        child: TableShared<IngredientModel>(
          fields: ['Item', 'Quantity', 'Unit'],
          data: recipe!.ingredients!,
        ),
      ),
      CustomCard(
        card: ECard.elevated,
        child: TableShared<InstructionModel>(
          fields: ['Title', 'Description'],
          data: recipe!.instructions!,
        ),
      ),
      CustomCard(
        card: ECard.elevated,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CText(
              'Reviews',
              textLevel: EText.title2,
            ),
            StreamBuilder(
              stream: recipesService.recipeReviews(widget.recipeId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!.data();

                  List<ReviewModel> reviews = [];
                  (data.reviews ?? []).forEach(
                    (e) => reviews.add(ReviewModel(
                      review: e.review,
                      stars: e.stars,
                    )),
                  );
                  return ListView(
                    children: reviews
                        .map(
                          (review) => ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0.0,
                              horizontal: 10.0,
                            ),
                            // tileColor: theme.colorScheme.surface,
                            title: CText(
                              review.review ?? '',
                              textLevel: EText.title2,
                              theme: theme,
                            ),
                            subtitle: review.stars! > 0
                                ? Wrap(
                                    spacing: 4,
                                    children: List<Widget>.generate(
                                      review.stars ?? 1,
                                      (index) => Icon(
                                        Icons.star_rate,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ).toList(),
                                  )
                                : null,
                          ),
                        )
                        .toList(),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
      )
    ];

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CText(
          recipe?.title ?? '',
          textLevel: EText.title2,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      floatingActionButton: FloatingActionButton.extended(
        // onPressed: () => profileService.markRecipeAsMade(widget.recipeId),
        onPressed: () => {},
        icon: Icon(Icons.soup_kitchen),
        label: CText(
          'Make',
          textLevel: EText.button,
        ),
        elevation: 1,
      ),
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 5.0,
          ),
          child: Wrap(
            children: [
              canEdit
                  ? SizedBox.shrink()
                  : IconButton(
                      onPressed: () => _addDialogBuilder(context),
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
              IconButton(
                onPressed: () => _reviewDialogBuilder(context),
                icon: Icon(Icons.message),
              ),
            ],
          ),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: CustomScrollView(
          slivers: [
            SliverAppBar.large(
              pinned: true,
              backgroundColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              collapsedHeight: 150,
              leading: SizedBox.shrink(),
              expandedHeight: MediaQuery.of(context).size.height * .35,
              flexibleSpace: AspectRatio(
                aspectRatio: 1.25,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withOpacity(0.5),
                        blurRadius: 4.0,
                        spreadRadius: 1.0,
                      ),
                    ],
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(
                        20.0,
                      ),
                      bottomRight: Radius.circular(
                        20.0,
                      ),
                    ),
                  ),
                  child: Image.network(
                    recipe!.image!,
                    fit: BoxFit.fitWidth,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null &&
                          loadingProgress?.cumulativeBytesLoaded ==
                              loadingProgress?.expectedTotalBytes) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                  ),
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _recipeCards[index];
                },
                childCount: _recipeCards.length,
              ),
            ),
          ],
        ),
      ),

      // body: SizedBox(
      //   height: MediaQuery.of(context).size.height,
      //   child: Stack(
      //     children: [
      //       AspectRatio(
      //         aspectRatio: 1.25,
      // child: Image.network(
      //   recipe!.image!,
      //   fit: BoxFit.fitWidth,
      //   loadingBuilder: (context, child, loadingProgress) {
      //     if (loadingProgress == null &&
      //         loadingProgress?.cumulativeBytesLoaded ==
      //             loadingProgress?.expectedTotalBytes) {
      //       return child;
      //     }
      //     return Center(
      //       child: CircularProgressIndicator(),
      //     );
      //   },
      // ),
      //       ),
      //       Positioned(
      //         top: 300,
      //         left: 0,
      //         right: 0,
      //         bottom: 0,
      //         child: Container(
      //           decoration: BoxDecoration(
      //             color: theme.colorScheme.surface,
      //             borderRadius: BorderRadius.only(
      //               topLeft: Radius.circular(
      //                 20.0,
      //               ),
      //               topRight: Radius.circular(
      //                 20.0,
      //               ),
      //             ),
      //             boxShadow: [
      //               BoxShadow(
      //                 color: theme.colorScheme.shadow.withOpacity(0.5),
      //                 blurRadius: 4.0,
      //                 spreadRadius: 1.0,
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     elevation: 0,
    //     toolbarHeight: 75,
    //     title: Column(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       children: [
    //         CText(
    //           recipe?.title ?? '',
    //           textLevel: EText.title,
    //         ),
    //         recipe?.description != ''
    //             ? CText(
    //                 recipe?.description ?? '',
    //                 textLevel: EText.subtitle,
    //               )
    //             : SizedBox.shrink()
    //       ],
    //     ),
    //     actions: [
    //       Wrap(
    //         spacing: 10.0,
    //         children: [
    //           IconButton(
    //             onPressed: () {
    //               profileService.likeRecipe(widget.recipeId, !liked);
    //               setState(() {
    //                 liked = !liked;
    //               });
    //             },
    //             icon: Icon(
    //               liked ? Icons.favorite : Icons.favorite_outline_outlined,
    //               fill: 1.0,
    //               color: theme.colorScheme.secondary,
    //             ),
    //           ),
    // canEdit
    //     ? SizedBox.shrink()
    //     : IconButton(
    //         onPressed: () => _addDialogBuilder(context),
    //         icon: Icon(Icons.add_outlined),
    //       ),
    // canEdit
    //     ? IconButton(
    //         onPressed: () => context.replace('/newRecipe/${widget.recipeId}'),
    //         icon: Icon(
    //           Icons.edit_outlined,
    //         ),
    //       )
    //     : SizedBox.shrink(),
    //         ],
    //       ),
    //     ],
    //     bottom: TabBar(
    //       indicatorColor: theme.colorScheme.primary,
    //       controller: _tabController,
    //       dividerColor: Colors.transparent,
    //       tabs: [
    //         Tab(
    //           text: "Recipe",
    //         ),
    //         Tab(
    //           text: "Reviews",
    //         ),
    //       ],
    //     ),
    //   ),
    //   floatingActionButton: buildFAB(),
    //   body: recipe != null
    //       ? TabBarView(
    //           controller: _tabController,
    //           children: [
    //             RecipeTab(
    //               recipe: recipe!,
    //             ),
    //             ReviewsTab(id: widget.recipeId),
    //             // SizedBox(),
    //           ],
    //         )
    //       : Center(
    //           child: CircularProgressIndicator(),
    //         ),
    // );
  }
}
