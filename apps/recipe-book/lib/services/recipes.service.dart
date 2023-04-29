import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/auth.service.dart';

class RecipesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String recipesCollection = 'recipes';
  String usersCollection = 'users';

  get recipesRef {
    return _db.collection(recipesCollection).withConverter(
          fromFirestore: RecipeModel.fromFirestore,
          toFirestore: (RecipeModel recipe, _) => recipe.toFirestore(),
        );
  }

  Future<RecipeModel> getRecipe(String id) async {
    final recipes = await recipesRef;
    return (await recipes.doc(id).get()).data();
  }

  getImage(String image) {
    final ref = _storage.ref().child('food/${authService.user?.uid}/${image}/file');
    return ref.getDownloadURL();
    // return url;
  }

  upsertRecipe(RecipeModel recipe, File photo) async {
    final recipes = await recipesRef;
    await uploadFile(photo);
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

  Stream<DocumentSnapshot<dynamic?>> getRecipeReviews(id) {
    return _db.collection(recipesCollection).doc(id).snapshots();
  }

  addReview(ReviewModel review, String id) {
    _db.collection(recipesCollection).doc(id).update({
      'reviews': FieldValue.arrayUnion([review.toMap()])
    });
  }

  uploadFile(File file) async {
    final fileName = basename(file!.path);
    final destination = 'food/${authService.user?.uid}/$fileName';

    try {
      final ref = _storage.ref(destination).child('file/');
      return await ref.putFile(file);
    } catch (e) {}
  }
}

final RecipesService recipesService = RecipesService();
