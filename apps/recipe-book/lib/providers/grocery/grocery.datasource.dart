import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/models/firebase/firebase_result.model.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';

class GroceryDataStore {
  final FirebaseFunctions firebaseFunctions;
  final FirebaseFirestore firebaseFirestore;
  final Ref ref;

  var authProvider;
  GroceryDataStore({
    required this.firebaseFirestore,
    required this.firebaseFunctions,
    required this.ref,
  }) {
    authProvider = ref.read(firebaseAuthProvider);
  }

  Future<FirestoreResult<List<String>>> searchGroceryAutocomplete(String query) async {
    try {
      final results = await FirebaseFunctions.instance.httpsCallable('searchGroceryAutoComplete').call({
        'query': query,
      });

      List<String> data = [];
      for (final item in results.data) {
        data.add(item.toString());
      }
      return FirestoreResult<List<String>>(
        data,
        success: true,
      );
    } catch (e) {
      print(e);
      return FirestoreResult(
        [],
        success: false,
        message: e.toString(),
      );
    }
  }
}
