import 'package:cloud_firestore/cloud_firestore.dart';

class LikesModel {
  String? recipeId;
  bool? hasMade;

  LikesModel({
    this.recipeId,
    this.hasMade = false,
  });

  factory LikesModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return LikesModel(
      recipeId: data?['recipeId'],
      hasMade: data?['hasMade'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "recipeId": recipeId,
      "hasMade": hasMade,
    };
  }

  List<LikesModel> fromFirestoreList(List<dynamic> likes) {
    return likes
        .map((like) => LikesModel(hasMade: like['hasMade'], recipeId: like['recipeId']))
        .toList();
  }
}
