import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/auth.service.dart';

class RecipesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String recipesCollection = 'recipes';
  String usersCollection = 'users';

  recipeRef(Recipe recipe) {
    return _db.collection(recipesCollection).doc(recipe.id).withConverter<Recipe>(
        fromFirestore: (snapshot, _) => Recipe.fromJson(snapshot.data()!),
        toFirestore: (recipe, _) => recipe.toMap());
  }

  get recipesRef {
    return _db.collection(recipesCollection).withConverter<Recipe>(
        fromFirestore: (snapshot, _) => Recipe.fromJson(snapshot.data()!),
        toFirestore: (recipe, _) => recipe.toMap());
  }

  upsertRecipe(Recipe recipe) async {
    //TODO
    //Handle editing existing

    final recipes = await recipesRef;
    var postResult = await recipes.add(recipe);
    _db
        .collection('users')
        .doc(authService.user.uid)
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

  RecipeBook recipeBook = RecipeBook('', '', '', [], authService.user.uid, 0);
}

final RecipesService recipesService = RecipesService();
