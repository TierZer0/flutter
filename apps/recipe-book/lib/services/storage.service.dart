import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:recipe_book/services/db.service.dart';
import 'package:recipe_book/services/user/authentication.service.dart';

class _FirebaseStorageService {
  Future<String> uploadFile(dynamic file) async {
    // check file type File or XFile
    if (file is File) {
      return _uploadFile(file);
    } else {
      return _uploadXFile(file);
    }
  }

  Future<String> _uploadFile(File file) async {
    final fileName = basename(file.path);
    final destination = 'food/${authenticationService.userUid}/$fileName';

    try {
      final ref = db.storage.ref(destination).child('file/');
      await ref.putFile(file);
      return ref.getDownloadURL();
    } catch (e) {
      print(e);
    }
    return '';
  }

  Future<String> _uploadXFile(XFile file) async {
    final fileName = basename(file.name);
    final destination = 'food/${authenticationService.userUid}/$fileName';

    try {
      final ref = db.storage.ref(destination).child('file/');
      Uint8List imageData = await XFile(file.path).readAsBytes();
      await ref.putData(
        imageData,
        SettableMetadata(contentType: 'image/png'),
      );
      return ref.getDownloadURL();
    } catch (e) {
      print(e);
    }
    return '';
  }
}

final _FirebaseStorageService firebaseStorageService = _FirebaseStorageService();
