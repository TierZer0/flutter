import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';
import 'package:recipe_book/providers/storage/storage.datasource.dart';

final storageDataSource = StateProvider((ref) => StorageDataSource(ref: ref, firebaseStorage: ref.read(firebaseStorageProvider)));

final uploadFileProvider = FutureProvider.family<String, dynamic>((ref, file) {
  return Future.value(ref.read(storageDataSource.notifier).state.uploadFile(file));
});
