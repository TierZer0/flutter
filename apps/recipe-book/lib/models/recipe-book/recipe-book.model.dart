import 'package:cloud_firestore/cloud_firestore.dart';

class RecipeBookModel {
  String? id;
  String? name;
  String? description;
  List<String>? recipes;
  String? createdBy;
  int? likes;

  RecipeBookModel({
    this.id,
    this.name,
    this.description,
    this.recipes,
    this.createdBy,
    this.likes,
  });

  factory RecipeBookModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return RecipeBookModel(
      id: snapshot.id,
      name: data?['name'],
      description: data?['description'] ?? '',
      recipes: data?['recipes'] is Iterable ? List<String>.from(data?['recipes']) : null,
      createdBy: data?['createdBy'],
      likes: data?['likes'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (recipes != null) "recipes": recipes,
      if (createdBy != null) "createdBy": createdBy,
      if (likes != null) "likes": likes,
      if (description != null) "description": description,
      if (id != null) "id": id,
    };
  }
}
