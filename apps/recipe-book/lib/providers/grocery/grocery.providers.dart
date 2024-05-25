import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/models/firebase/firebase_result.model.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';
import 'package:recipe_book/providers/grocery/grocery.datasource.dart';

final groceryDataSource = StateProvider(
  (ref) => GroceryDataStore(
    ref: ref,
    firebaseFirestore: ref.read(firebaseFirestoreProvider),
    firebaseFunctions: ref.read(firebaseFunctionsProvider),
  ),
);

final searchGroceryAutocompleteProvider = FutureProvider.family(
  (ref, String query) async {
    var didDispose = false;
    ref.onDispose(() => didDispose = true);

    await Future<void>.delayed(const Duration(milliseconds: 500));

    if (didDispose) {
      return FirestoreResult<List<String>>(
        [],
        success: false,
        message: 'Disposed',
      );
    }

    return Future.value(ref.read(groceryDataSource.notifier).state.searchGroceryAutocomplete(query));
  },
);
