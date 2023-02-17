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
    //TODO
    //Handle editing existing

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

  getRecipesByUser(String userUid) {
    return _db
        .collection(recipesCollection)
        .where('createdBy', isEqualTo: userUid)
        .orderBy('likes')
        .get();
  }
}

final RecipesService recipesService = RecipesService();
