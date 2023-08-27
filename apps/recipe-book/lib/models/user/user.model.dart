import 'package:cloud_firestore/cloud_firestore.dart';

import 'likes.model.dart';

class UserModel {
  String? name;
  Timestamp? lastSeen;
  bool? darkTheme;
  List<LikesModel>? likes;
  List<dynamic>? categories;

  UserModel({
    this.name,
    this.lastSeen,
    this.darkTheme,
    this.likes,
    this.categories,
  });

  factory UserModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return UserModel(
      name: data?['name'],
      lastSeen: data?['lastSeen'],
      darkTheme: data?['darkTheme'] ?? false,
      likes: data?['likes'] is Iterable ? LikesModel().fromFirestoreList(data?['likes']) : null,
      categories: data?['categories'] is Iterable ? data!['categories'] : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      "name": name,
      "lastSeen": lastSeen,
      "darkTheme": darkTheme,
      "likes": likes?.map((like) => like.toFirestore()).toList(),
      "categories": categories,
    };
  }
}
