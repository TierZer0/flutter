import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';
import 'package:recipe_book/providers/resources/resources.datasource.dart';

final resourcesDataSourceProvider = StateProvider<ResourcesDataSource>(
  (ref) => ResourcesDataSource(
    firebaseFirestore: ref.read(firebaseFirestoreProvider),
    ref: ref,
  ),
);
