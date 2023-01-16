import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/models/recipe.models.dart';

class UserFB {
  String name;
  Timestamp lastSeen;
  bool darkTheme;
  List<RecipeBook> books;
  List<String> likes;

  UserFB(
    this.name,
    this.lastSeen,
    this.darkTheme,
    this.books,
    this.likes,
  );

  UserFB.fromJson(Map<String, dynamic> json)
      : this(
          json['name'],
          json['lastSeen'],
          json['darkTheme'],
          json['books'] ?? [],
          json['likes'] ?? [],
        );

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> _books = [];
    for (var element in books) {
      _books.add(element.toMap());
    }

    return {
      'name': name,
      'lastSeen': lastSeen,
      'darkTheme': darkTheme,
      'books': _books,
      'likes': likes
    };
  }
}
