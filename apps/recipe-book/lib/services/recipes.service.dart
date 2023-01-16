import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/models/user.models.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/services/user.service.dart';

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
    _db.collection(recipesCollection).withConverter<Recipe>(
        fromFirestore: (snapshot, _) => Recipe.fromJson(snapshot.data()!),
        toFirestore: (recipe, _) => recipe.toMap());
  }

  upsertRecipe(Recipe recipe) async {
    //TODO
    //Handle editing existing

    final recipes = recipesRef;
    //ADD TO RECIPES COLLECTION
    var postResult = await recipes.add(recipe);
    // var postResult = await _db.collection(recipesCollection).add(recipe.toMap());
    print(postResult.id);

    //TO DO
    //Add recipeid to current users collection
    final userRef = await userService.userRef;
    UserFB user = await userRef.get().then((snapshot) => snapshot.data()!);
    for (var element in user.books) {
      if (element.id == recipe.recipeBook) {
        element.recipes.add(postResult.id);
      }
    }
    userRef.set(user, SetOptions(merge: true));
  }
}

final RecipesService recipesService = RecipesService();
