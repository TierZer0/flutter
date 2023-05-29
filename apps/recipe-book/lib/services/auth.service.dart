import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

import '../app_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  // AppModel appModel = AppModel();

  User? get user {
    return _auth.currentUser;
  }

  Future emailSignIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await updateUserData(user!);
      return user;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future emailCreateAccount(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await updateUserData(user!);
      return user;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future googleSSO() async {
    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth?.idToken,
      accessToken: googleAuth?.accessToken,
    );

    try {
      await _auth.signInWithCredential(credential);
      await updateUserData(user!);
      return user;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<bool> updateUserData(User user) async {
    final ref = _db.collection('users').doc(user?.uid);
    ref.update({
      'lastSeen': DateTime.now(),
    }).catchError((e) => {
          ref.set({
            'lastSeen': DateTime.now(),
            'name': user.displayName ?? user.email,
            'darkTheme': false,
          })
        });
    return true;
  }

  Future<bool> logout() async {
    await _auth.signOut();
    return true;
  }

  get hasUser {
    return authService.user != null ? true : false;
  }
}

final AuthService authService = AuthService();
