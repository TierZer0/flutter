import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/models/resources/resources.model.dart';
import 'package:recipe_book/services/db.service.dart';

class ResourcesService {
  get resourcesRef => db.resourcesCollection.doc('Recipes').withConverter(
        fromFirestore: ResourcesModel.fromFirestore,
        toFirestore: (ResourcesModel resources, _) => resources.toMap(),
      );

  get units {
    return resourcesRef.get().then((value) => value.data()['units']);
  }

  getCategories({dynamic filter = null}) {
    return resourcesRef.get().then((value) => ((value.data() as ResourcesModel).categories));
  }
}

final ResourcesService resourcesService = ResourcesService();
