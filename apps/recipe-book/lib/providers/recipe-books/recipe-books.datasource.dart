import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/models/firebase/firebase_result.model.dart';
import 'package:recipe_book/models/recipe-book/recipe-book.model.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';

class RecipeBooksDataSource {
  final FirebaseFirestore firebaseFirestore;
  final Ref ref;

  var authProvider;
  RecipeBooksDataSource({
    required this.firebaseFirestore,
    required this.ref,
  }) {
    authProvider = ref.read(firebaseAuthProvider);
  }

  get _recipeBooksRef => this.firebaseFirestore.collection('users').doc(authProvider.currentUser!.uid).collection('books').withConverter(
        fromFirestore: RecipeBookModel.fromFirestore,
        toFirestore: (RecipeBookModel recipeBook, _) => recipeBook.toFirestore(),
      );

  Future<FirestoreResult<dynamic>> getRecipeBooks() async {
    try {
      final recipeBooks = (await _recipeBooksRef.get()).docs.map((e) => e.data()).toList();
      return Future.value(FirestoreResult<dynamic>(
        recipeBooks,
        success: true,
      ));
    } catch (e) {
      return Future.value(FirestoreResult(
        null,
        success: false,
        message: e.toString(),
      ));
    }
  }
}
