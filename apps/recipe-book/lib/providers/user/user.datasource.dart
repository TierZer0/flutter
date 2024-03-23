import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/models/models.dart';
import 'package:recipe_book/providers/recipes/recipes.providers.dart';

class UserDataSource {
  final FirebaseFirestore firebaseFirestore;
  final Ref ref;

  UserDataSource({
    required this.firebaseFirestore,
    required this.ref,
  });

  get _usersRef => this.firebaseFirestore.collection('users').withConverter(
        fromFirestore: UserModel.fromFirestore,
        toFirestore: (UserModel user, _) => user.toFirestore(),
      );

  Future<FirestoreResult<List<dynamic>>> getLikedRecipes(String uid) async {
    try {
      final likedIds = (await _usersRef.doc(uid).get()).data()!.likes;

      final likes = (await ref.read(recipesDataSource.notifier).state.getRecipesByIds(likedIds!)).payload;

      return FirestoreResult<List<dynamic>>(
        likes,
        success: true,
      );
    } catch (e) {
      return FirestoreResult(
        null,
        success: false,
        message: e.toString(),
      );
    }
  }
}
