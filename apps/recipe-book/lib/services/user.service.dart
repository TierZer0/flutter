import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_book/services/auth.service.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  User user = authService.user;
  String collection = 'users';

  setUserTheme(bool value) {
    _db
        .collection(collection)
        .doc(user.uid)
        .set({'darkTheme': value}, SetOptions(merge: true));
  }

  get getUserTheme async {
    var snapshot = await _db.collection(collection).doc(user.uid).get();
    return snapshot['darkTheme'];
  }
}

final UserService userService = UserService();
