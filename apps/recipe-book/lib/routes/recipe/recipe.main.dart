import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/main.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';
import 'package:recipe_book/providers/recipes/recipes.providers.dart';
import 'package:recipe_book/providers/user/user.providers.dart';
import 'package:recipe_book/routes/recipe/parts/ingredients.part.dart';
import 'package:recipe_book/routes/recipe/parts/instructions.part.dart';
import 'package:recipe_book/routes/recipe/parts/reviews.part.dart';
import 'package:recipe_book/routes/recipe/sheets/review.sheet.dart';

class RecipeMain extends ConsumerStatefulWidget {
  final String recipeId;

  RecipeMain({
    required this.recipeId,
  });

  @override
  _RecipeMainState createState() => _RecipeMainState();
}

class _RecipeMainState extends ConsumerState<RecipeMain> with TickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final recipeProvider = ref.watch(getRecipeProvider(widget.recipeId));

    return recipeProvider.when(
      error: (error, stackTrace) {
        return Scaffold(
          body: Center(
            child: Text('Error: $error'),
          ),
        );
      },
      loading: () {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
      data: (data) {
        final recipe = data.payload!;
        final bool myRecipe = ref.read(firebaseAuthProvider).currentUser!.uid == recipe.createdBy;
        final hasLiked = ref.read(getHasUserLikedRecipeProvider(recipe.id!));

        return Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            centerTitle: false,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title!,
                  textScaler: TextScaler.linear(1.1),
                ),
                Text(
                  recipe.description!,
                  textScaler: TextScaler.linear(0.7),
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            actions: [
              myRecipe
                  ? IconButton(
                      icon: Icon(Icons.edit_outlined),
                      onPressed: () => context.replace('/edit/${recipe.id}'),
                    )
                  : SizedBox.shrink(),
              !myRecipe
                  ? IconButton(
                      onPressed: () {
                        ref.read(setUserLikedRecipeProvider(recipe.id!));
                        ref.invalidate(getRecipeProvider);
                        return ref.refresh(getHasUserLikedRecipeProvider(recipe.id!));
                      },
                      icon: hasLiked.when(
                        error: (_, __) => Icon(Icons.favorite_border),
                        loading: () => Icon(Icons.favorite_border),
                        data: (data) => data.payload!
                            ? Icon(
                                Icons.favorite,
                                color: primary,
                              )
                            : Icon(Icons.favorite_border),
                      ),
                    )
                  : SizedBox.shrink(),
              !myRecipe
                  ? IconButton(
                      onPressed: () => showModalBottomSheet(
                        context: context,
                        builder: (context) => RecipeReviewSheet(
                          recipeId: recipe.id!,
                        ),
                      ),
                      icon: Icon(
                        Icons.reviews_outlined,
                      ),
                    )
                  : SizedBox.shrink(),
              Gap(10),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 5,
                  clipBehavior: Clip.antiAlias,
                  child: Image.network(
                    recipe.image!,
                    fit: BoxFit.cover,
                    height: 250,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 50,
                  child: TabBar(
                    controller: _tabController,
                    tabs: [
                      Tab(
                        child: Text(
                          'Ingredients',
                          textScaler: TextScaler.linear(1.1),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Instructions',
                          textScaler: TextScaler.linear(1.1),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Reviews',
                          textScaler: TextScaler.linear(1.1),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      RecipeIngredientsPart(
                        ingredients: recipe.ingredients!,
                      ),
                      RecipeInstructionsPart(
                        instructions: recipe.instructions!,
                      ),
                      RecipeReviewsPart(
                        reviews: recipe.reviews ?? [],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
