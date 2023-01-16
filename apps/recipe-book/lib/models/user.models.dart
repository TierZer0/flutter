import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/models/recipe.models.dart';

class UserFB {
  String name;
  Timestamp lastSeen;
  bool darkTheme;
  List<dynamic> likes;

  UserFB(
    this.name,
    this.lastSeen,
    this.darkTheme,
    this.likes,
  );

  UserFB.fromJson(Map<String, dynamic> json)
      : this(
          json['name'],
          json['lastSeen'],
          json['darkTheme'],
          json['likes'] ?? [],
        );

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lastSeen': lastSeen,
      'darkTheme': darkTheme,
      'likes': likes,
    };
  }
}