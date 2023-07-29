import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recipe_book/services/user/authentication.service.dart';

class FirestoreResult<T> {
  bool success;
  String? message;
  T? payload;

  FirestoreResult(
    this.payload, {
    required this.success,
    this.message,
  });
}

class _DbService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  get firestore => _firestore;
  get storage => _storage;

  CollectionReference<Map<String, dynamic>> get userCollection => _firestore.collection('users');
  CollectionReference<Map<String, dynamic>> get userRecipeBookCollection =>
      firestore.collection('users').doc(authenticationService.userUid).collection('books');
  CollectionReference<Map<String, dynamic>> get recipeCollection =>
      _firestore.collection('recipes');
}

final _DbService db = _DbService();
