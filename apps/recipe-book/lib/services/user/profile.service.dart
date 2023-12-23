import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/models/models.dart';
import 'package:recipe_book/services/db.service.dart';
import 'package:recipe_book/services/user/authentication.service.dart';
import 'package:recipe_book/services/recipes/recipes.service.dart';

class _ProfileService {
  final _userCollection = db.userCollection;
  final currentUser = authenticationService.userUid;

  get userCollectionRef => _userCollection.doc(currentUser).withConverter(
      fromFirestore: UserModel.fromFirestore,
      toFirestore: (UserModel user, _) => user.toFirestore());

  Future<dynamic> createUser(UserModel userModel, String id) {
    return _userCollection.doc(id).set(userModel.toFirestore());
  }

  setUserTheme(bool value) {
    _userCollection.doc(currentUser).set({'darkTheme': value}, SetOptions(merge: true));
  }

  Future<bool> get userTheme async {
    return (await userCollectionRef.get()).data().darkTheme!;
  }

  Future<UserModel> get userFuture async {
    return (await userCollectionRef.get()).data();
  }

  Stream<DocumentSnapshot> get userStream {
    return userCollectionRef.snapshots();
  }

  Future<List<String>> get myCategories async {
    final snapshot = await userCollectionRef.get();
    return snapshot.data()!.categories;
  }

  hasLiked(String recipeId) async {
    final user = await (await userCollectionRef.get()).data()!;
    return user.likes.any((element) => element.recipeId == recipeId);
  }

  Future<bool> hasMade(String recipeId) {
    return userCollectionRef.get().then((value) =>
        value.data()!.likes.any((element) => element.recipeId == recipeId && element.hasMade));
  }

  Future<QuerySnapshot<RecipeModel>> myLikes(bool hasMade) async {
    final snapshot = await userCollectionRef.get();
    final likes = snapshot.data()!.likes;
    final recipeIds =
        likes.where((element) => element.hasMade == hasMade).map((e) => e.recipeId).toList();
    return recipesService.recipesRef.where(FieldPath.documentId, whereIn: recipeIds).get();
  }

  Future<FirestoreResult<UserModel>> upsertCategory({
    required String category,
    String? oldCategory = '',
  }) {
    if (oldCategory != '' && oldCategory != null) deleteCategory(oldCategory);

    return userCollectionRef
        .set({
          'categories': FieldValue.arrayUnion([category])
        }, SetOptions(merge: true))
        .then((value) => FirestoreResult<UserModel>(null, success: true, message: 'Category Added'))
        .catchError(
            (error) => FirestoreResult<UserModel>(null, success: false, message: error.toString()));
  }

  Future<FirestoreResult<UserModel>> deleteCategory(String category) {
    return userCollectionRef
        .update({
          'categories': FieldValue.arrayRemove([category])
        })
        .then((value) => FirestoreResult<UserModel>(null, success: true, message: 'Category Added'))
        .catchError(
            (error) => FirestoreResult<UserModel>(null, success: false, message: error.toString()));
  }

  Future<FirestoreResult<UserModel>> markRecipeAsMade(String recipeId) async {
    List<LikesModel> likedRecipes = (await userCollectionRef.get()).data()!.likes;
    LikesModel like = likedRecipes.firstWhere((element) => element.recipeId == recipeId);
    like.hasMade = true;
    return userCollectionRef
        .update({'likes': likedRecipes.map((e) => e.toFirestore()).toList()})
        .then((value) =>
            FirestoreResult<UserModel>(null, success: true, message: 'Recipe Marked as Made'))
        .catchError(
            (error) => FirestoreResult<UserModel>(null, success: false, message: error.toString()));
  }

  Future<dynamic> likeRecipe(String recipeId, bool liked) {
    if (liked)
      return userCollectionRef
          .update({
            'likes': FieldValue.arrayRemove([LikesModel(recipeId: recipeId).toFirestore()])
          })
          .then(
              (value) => FirestoreResult<UserModel>(null, success: true, message: 'Recipe UnLiked'))
          .catchError((error) =>
              FirestoreResult<UserModel>(null, success: false, message: error.toString()));
    else
      return userCollectionRef
          .update({
            'likes': FieldValue.arrayUnion([LikesModel(recipeId: recipeId).toFirestore()])
          })
          .then((value) => FirestoreResult<UserModel>(null, success: true, message: 'Recipe Liked'))
          .catchError((error) =>
              FirestoreResult<UserModel>(null, success: false, message: error.toString()));
  }
}

final _ProfileService profileService = _ProfileService();
