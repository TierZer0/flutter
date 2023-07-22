import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
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
    if (image == '') return null;
    final ref = _storage.ref().child('food/${authService.user?.uid}/${image}/file');
    return ref.getDownloadURL();
  }

  upsertRecipe(RecipeModel recipe, dynamic photo) async {
    final recipes = await recipesRef;
    var result = await uploadFile(photo);
    recipe.image = result;
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

  _buildFilterQuery(Query query, filters) {
    if (filters == null) return query;

    for (String key in filters.keys) {
      if (filters[key] != null && filters[key] != '') {
        var value;
        if (key.contains('Time')) {
          value = int.parse(filters[key]);
        } else {
          value = filters[key];
        }

        if (key.contains('ingredient')) {
          query = query.where('ingredientsList', arrayContains: value);
        } else {
          query = query.where(key, isEqualTo: value);
        }
      }
    }
    return query;
  }

  Stream<QuerySnapshot<RecipeModel>> getAllRecipes({filters, sort, search}) {
    Query<RecipeModel> query = recipesRef;

    if (filters != null) {
      query = _buildFilterQuery(query, filters);
    }

    if (sort != null) {
      query = query.orderBy(sort);
    } else {
      query = query.orderBy('created');
    }

    return query.snapshots();
  }

  Stream<QuerySnapshot<RecipeModel>> getRecipesInBook(List<dynamic> recipeIds) {
    if (recipeIds.isEmpty) return Stream.empty();
    return recipesRef.where(FieldPath.documentId, whereIn: recipeIds).snapshots();
  }

  Future<QuerySnapshot<RecipeModel>> getRecipesInBookFuture({List<String>? recipeIds = const []}) {
    print(recipeIds);

    if (recipeIds == null || recipeIds!.isEmpty)
      return Future.error(Exception('No recipes in book'));
    return recipesRef.where(FieldPath.documentId, whereIn: recipeIds).get();
  }

  Stream<QuerySnapshot<RecipeModel>> getMyRecipes({filters}) {
    Query<RecipeModel> query = _buildFilterQuery(recipesRef, filters);
    return query
        .where('createdBy', isEqualTo: authService.user?.uid)
        .orderBy('created')
        .snapshots();
  }

  Future<QuerySnapshot<RecipeModel>> getMyRecipesFuture({filters}) {
    Query<RecipeModel> query = _buildFilterQuery(recipesRef, filters);
    return query.where('createdBy', isEqualTo: authService.user?.uid).orderBy('created').get();
  }

  Stream<DocumentSnapshot<dynamic>> getRecipeReviews(id) {
    return _db.collection(recipesCollection).doc(id).snapshots();
  }

  addReview(ReviewModel review, String id) {
    _db.collection(recipesCollection).doc(id).update({
      'reviews': FieldValue.arrayUnion([review.toMap()])
    });
  }

  incrementView(String id) {
    _db.collection(recipesCollection).doc(id).update({'views': FieldValue.increment(1)});
  }

  Future<void> updateLikes(String id, bool liked) {
    if (liked) {
      return _db.collection(recipesCollection).doc(id).update({'likes': FieldValue.increment(1)});
    } else {
      return _db.collection(recipesCollection).doc(id).update({'likes': FieldValue.increment(-1)});
    }
  }

  Future<String> uploadFile(dynamic file) async {
    // check file type File or XFile
    if (file is File) {
      return _uploadFile(file);
    } else {
      return _uploadXFile(file);
    }
  }

  Future<String> _uploadFile(File file) async {
    final fileName = basename(file.path);
    final destination = 'food/${authService.user?.uid}/$fileName';

    try {
      final ref = _storage.ref(destination).child('file/');
      await ref.putFile(file);
      return ref.getDownloadURL();
    } catch (e) {
      print(e);
    }
    return '';
  }

  Future<String> _uploadXFile(XFile file) async {
    final fileName = basename(file.name);
    final destination = 'food/${authService.user?.uid}/$fileName';

    try {
      final ref = _storage.ref(destination).child('file/');
      Uint8List imageData = await XFile(file.path).readAsBytes();
      await ref.putData(
        imageData,
        SettableMetadata(contentType: 'image/png'),
      );
      return ref.getDownloadURL();
    } catch (e) {
      print(e);
    }
    return '';
  }
}

final RecipesService recipesService = RecipesService();
