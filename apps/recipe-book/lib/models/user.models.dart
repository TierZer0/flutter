import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? name;
  Timestamp? lastSeen;
  bool? darkTheme;
  List<dynamic>? likes;
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
      likes: data?['likes'] is Iterable ? List<String>.from(data?['likes']) : null,
      categories: data?['categories'] is Iterable ? List<String>.from(data?['categories']) : null,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (lastSeen != null) "lastSeen": lastSeen,
      if (darkTheme != null) "darkTheme": darkTheme,
      if (likes != null) "likes": likes,
      if (categories != null) "categories": categories,
    };
  }
}
