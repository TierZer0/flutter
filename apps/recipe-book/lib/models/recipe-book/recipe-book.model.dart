import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_book/models/models.dart';

class RecipeBookModel {
  String? id;
  String? name;
  String? description;
  List<String>? recipeIds;
  List<dynamic>? recipes;
  String? createdBy;
  int? likes;

  RecipeBookModel({
    this.id,
    this.name,
    this.description,
    this.recipeIds,
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
      recipeIds: data?['recipeIds'] is Iterable ? List<String>.from(data?['recipeIds']) : [],
      createdBy: data?['createdBy'],
      likes: data?['likes'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (recipeIds != null) "recipeIds": recipeIds,
      if (createdBy != null) "createdBy": createdBy,
      if (likes != null) "likes": likes,
      if (description != null) "description": description,
      if (recipes != null) "recipes": recipes,
      if (id != null) "id": id,
    };
  }
}
