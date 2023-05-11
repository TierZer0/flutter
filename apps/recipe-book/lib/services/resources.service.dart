import 'package:cloud_firestore/cloud_firestore.dart';

class ResourcesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  String collection = 'resources';

  get units {
    return _db.collection(collection).doc('Recipes').get().then((value) => value.data());
  }
}

final ResourcesService resourcesService = ResourcesService();
