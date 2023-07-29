import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/recipe.models.dart';
import '../db.service.dart';

class _RecipeBookService {
  get recipeBookRef => db.userRecipeBookCollection.withConverter(
        fromFirestore: RecipeBookModel.fromFirestore,
        toFirestore: (RecipeBookModel book, _) => book.toFirestore(),
      );

  Stream<QuerySnapshot<RecipeBookModel>> get recipeBooksStream {
    return recipeBookRef.snapshots();
  }

  Future<QuerySnapshot<RecipeBookModel>> getRecipeBooks() async {
    return recipeBookRef.get();
  }

  Future<RecipeBookModel> getRecipeBook(String id) async {
    return (await recipeBookRef.doc(id).get()).data();
  }

  Future<void> updateRecipeBook(String id, RecipeBookModel recipeBook) {
    return recipeBookRef.doc(id).update(recipeBook.toFirestore());
  }

  Future<void> deleteRecipeBook(String id) {
    return recipeBookRef.doc(id).delete();
  }

  Future<void> createRecipeBook(RecipeBookModel recipeBook) {
    return recipeBookRef.add(recipeBook);
  }

  Future<void> addRecipeToRecipeBook(String id, String recipeBookId) {
    return db.userRecipeBookCollection.doc(recipeBookId).update(
      {
        'recipes': FieldValue.arrayUnion([id])
      },
    );
  }
}

final _RecipeBookService recipeBookService = _RecipeBookService();
