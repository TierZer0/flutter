import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/models/user.models.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String collection = 'users';
  String userBookCollection = 'books';

  setUserTheme(bool value) {
    if (!authService.hasUser) {
      return;
    }
    _db
        .collection(collection)
        .doc(authService.user?.uid)
        .set({'darkTheme': value}, SetOptions(merge: true));
  }

  get getUserTheme async {
    var snapshot = await _db.collection(collection).doc(authService.user?.uid).get();
    return snapshot['darkTheme'];
  }

  get getUser {
    return _db.collection(collection).doc(authService.user?.uid).get();
  }

  Stream<QuerySnapshot> get userBooksStream {
    return _db
        .collection('users')
        .doc(authService.user?.uid)
        .collection(userBookCollection)
        .snapshots();
  }

  get userRef {
    return _db.collection(collection).doc(authService.user?.uid).withConverter(
          fromFirestore: UserModel.fromFirestore,
          toFirestore: (UserModel user, _) => user.toFirestore(),
        );
  }

  get recipeBooksRef {
    return _db.collection(collection).doc(authService.user?.uid).collection('books').withConverter(
          fromFirestore: RecipeBookModel.fromFirestore,
          toFirestore: (RecipeBookModel book, _) => book.toFirestore(),
        );
  }

  get categories async {
    final userSnap = await userRef.get();
    final user = userSnap.data();
    return user.categories;
  }

  createRecipeBook(RecipeBookModel recipeBook) async {
    _db
        .collection(collection)
        .doc(authService.user?.uid)
        .collection(userBookCollection)
        .add(recipeBook.toFirestore());
  }

  createCategory(String category) async {
    _db.collection(collection).doc(authService.user?.uid).update({
      'categories': FieldValue.arrayUnion([category])
    });
  }
}

final UserService userService = UserService();
