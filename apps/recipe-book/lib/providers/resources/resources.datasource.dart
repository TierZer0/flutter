import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/models/firebase/firebase_result.model.dart';
import 'package:recipe_book/models/resources/resources.model.dart';

class ResourcesDataSource {
  final FirebaseFirestore firebaseFirestore;
  final Ref ref;

  ResourcesDataSource({
    required this.firebaseFirestore,
    required this.ref,
  });

  get _resourcesRef => this.firebaseFirestore.collection('resources').withConverter(
        fromFirestore: ResourcesModel.fromFirestore,
        toFirestore: (ResourcesModel resource, _) => resource.toMap(),
      );

  // TODO: switch from List<dynamic> to List<String+>
  Future<FirestoreResult<List<dynamic>>> getCategories() async {
    try {
      final categories = (await _resourcesRef.get()).docs.map((e) => e.data().categories).toList();
      return FirestoreResult<List<dynamic>>(
        categories,
        success: true,
      );
    } catch (e) {
      return FirestoreResult(
        null,
        success: false,
        message: e.toString(),
      );
    }
  }
}
