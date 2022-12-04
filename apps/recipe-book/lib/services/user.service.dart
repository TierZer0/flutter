import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_book/services/auth.service.dart';

class UserService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String collection = 'users';

  setUserTheme(bool value) {
    _db
        .collection(collection)
        .doc(authService.user.uid)
        .set({'darkTheme': value}, SetOptions(merge: true));
  }

  get getUserTheme async {
    var snapshot =
        await _db.collection(collection).doc(authService.user.uid).get();
    return snapshot['darkTheme'];
  }

  get getUser {
    return _db.collection(collection).doc(authService.user.uid).get();
  }
}

final UserService userService = UserService();
