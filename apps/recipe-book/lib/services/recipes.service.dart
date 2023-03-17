import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/auth.service.dart';

class RecipesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String recipesCollection = 'recipes';
  String usersCollection = 'users';

  get recipesRef {
    return _db.collection(recipesCollection).withConverter(
          fromFirestore: RecipeModel.fromFirestore,
          toFirestore: (RecipeModel recipe, _) => recipe.toFirestore(),
        );
  }

  upsertRecipe(RecipeModel recipe) async {
    final recipes = await recipesRef;
    var postResult = await recipes.add(recipe);
    _db
        .collection('users')
        .doc(authService.user?.uid)
        .collection('books')
        .doc(recipe.recipeBook)
        .update({
      'recipes': FieldValue.arrayUnion([postResult.id])
    });
  }

  Future<QuerySnapshot<RecipeModel>> getRecipesByFilter(String type) async {
    final recipes = await recipesRef;
    switch (type) {
      // case 'Trending':
      //   break;
      case 'New':
        return recipes.orderBy('created').get();
      default:
        return recipes.get();
    }
  }

  Future<QuerySnapshot<RecipeModel>> getRecipesByUser({
    required String userUid,
    String? category,
  }) async {
    final recipes = await recipesRef;
    return category != null
        ? recipes
            .where('createdBy', isEqualTo: userUid)
            .where('category', isEqualTo: category)
            .orderBy('likes')
            .get()
        : recipes.where('createdBy', isEqualTo: userUid).orderBy('likes').get();
  }
}

final RecipesService recipesService = RecipesService();
