import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/models/user.models.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String collection = 'users';
  String userBookCollection = 'books';

  setUserTheme(bool value) {
    _db
        .collection(collection)
        .doc(authService.user.uid)
        .set({'darkTheme': value}, SetOptions(merge: true));
  }

  get getUserTheme async {
    var snapshot = await _db.collection(collection).doc(authService.user.uid).get();
    return snapshot['darkTheme'];
  }

  get getUser {
    return _db.collection(collection).doc(authService.user.uid).get();
  }

  Stream<QuerySnapshot> get userStream {
    return _db
        .collection('users')
        .doc(authService.user.uid)
        .collection(userBookCollection)
        .snapshots();
  }

  get userRef {
    return _db.collection(collection).doc(authService.user.uid).withConverter<UserFB>(
        fromFirestore: (snapshot, _) => UserFB.fromJson(snapshot.data()!),
        toFirestore: (user, _) => user.toMap());
  }

  createRecipeBook(RecipeBook recipeBook) async {
    _db
        .collection(collection)
        .doc(authService.user.uid)
        .collection(userBookCollection)
        .add(recipeBook.toMap());
  }
}

final UserService userService = UserService();
