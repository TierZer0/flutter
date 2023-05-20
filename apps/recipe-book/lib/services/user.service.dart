import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/models/user.models.dart';
import 'package:recipe_book/services/recipes.service.dart';

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
    return _db
        .collection(collection)
        .doc(authService.user?.uid)
        .collection(userBookCollection)
        .withConverter(
          fromFirestore: RecipeBookModel.fromFirestore,
          toFirestore: (RecipeBookModel book, _) => book.toFirestore(),
        );
  }

  Future<RecipeBookModel> getRecipeBook(String id) async {
    final books = await recipeBooksRef;

    return (await books.doc(id).get()).data();
  }

  get categories async {
    final userSnap = await userRef.get();
    final user = userSnap.data();
    return user.categories;
  }

  get recipeBooks async {
    final snap = await _db
        .collection(collection)
        .doc(authService.user?.uid)
        .collection(userBookCollection)
        .get();
    return snap.docs.map((e) {
      var data = e.data();
      return RecipeBookModel(
        id: e.id,
        name: data['name'],
        category: data['category'],
        recipes: data['recipes'] is Iterable ? List<String>.from(data?['recipes']) : null,
        createdBy: data['createdBy'],
        likes: data['likes'],
      );
    }).toList();
  }

  Future<QuerySnapshot<RecipeModel>> likes() async {
    final userSnap = await userRef.get();
    final recipesRef = await recipesService.recipesRef;
    UserModel user = userSnap.data();

    return recipesRef.where(FieldPath.documentId, whereIn: user.likes).limit(5).get();
  }

  hasLiked(String recipeId) async {
    final userSnap = await userRef.get();

    UserModel user = userSnap.data();

    return user.likes!.contains(recipeId);
  }

  deleteRecipeBook(String id) {
    // Add check for recipes in book
    _db
        .collection(collection)
        .doc(authService.user?.uid)
        .collection(userBookCollection)
        .doc(id)
        .delete();
  }

  createRecipeBook(RecipeBookModel recipeBook) async {
    _db
        .collection(collection)
        .doc(authService.user?.uid)
        .collection(userBookCollection)
        .doc(recipeBook.id ?? null)
        .set(recipeBook.toFirestore());
  }

  deleteCategory(String category) {
    _db.collection(collection).doc(authService.user?.uid).update({
      'categories': FieldValue.arrayRemove([category]),
    });
  }

  createCategory({required String category, String? oldCategory = ''}) async {
    if (oldCategory != '') {
      deleteCategory(oldCategory!);
      //find and update references to old category
    }
    _db.collection(collection).doc(authService.user?.uid).update({
      'categories': FieldValue.arrayUnion([category])
    });
  }

  likeRecipe(String recipeId) async {
    if (await hasLiked(recipeId)) {
      await _db.collection(collection).doc(authService.user?.uid).update({
        'likes': FieldValue.arrayRemove(([recipeId]))
      });
    } else {
      await _db.collection(collection).doc(authService.user?.uid).update({
        'likes': FieldValue.arrayUnion(([recipeId]))
      });
    }
  }
}

final UserService userService = UserService();
