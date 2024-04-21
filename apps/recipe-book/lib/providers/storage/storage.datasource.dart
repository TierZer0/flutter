import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';

class StorageDataSource {
  final Ref ref;
  final FirebaseStorage firebaseStorage;

  StorageDataSource({
    required this.ref,
    required this.firebaseStorage,
  });

  Future<String> uploadFile(dynamic file) {
    if (file is File) {
      return _uploadFile(file);
    } else {
      return _uploadWebFile(file);
    }
  }

  Future<String> _uploadFile(File file) async {
    final fileName = basename(file.path);
    final destination = 'food/${ref.read(firebaseAuthProvider).currentUser!.uid}/$fileName';

    try {
      final storageRef = await firebaseStorage.ref(destination).child('file/');
      await storageRef.putFile(file);
      return storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
    }
    return '';
  }

  Future<String> _uploadWebFile(XFile file) async {
    final fileName = basename(file.name);
    final destination = 'food/${ref.read(firebaseAuthProvider).currentUser!.uid}/$fileName';

    try {
      final storageRef = await firebaseStorage.ref(destination).child('file/');
      await storageRef.putData(await XFile(file.path).readAsBytes());
      return storageRef.getDownloadURL();
    } catch (e) {
      print('Error uploading file: $e');
    }
    return '';
  }
}
