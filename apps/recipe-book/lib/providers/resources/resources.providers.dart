import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';
import 'package:recipe_book/providers/resources/resources.datasource.dart';

final resourcesDataSource = StateProvider((ref) => ResourcesDataSource(ref: ref, firebaseFirestore: ref.read(firebaseFirestoreProvider)));

final getCategoriesProvider = FutureProvider((ref) {
  return Future.value(ref.read(resourcesDataSource.notifier).state.getCategories());
});
