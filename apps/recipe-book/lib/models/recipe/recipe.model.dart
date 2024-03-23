import 'package:cloud_firestore/cloud_firestore.dart';

import 'ingredient.model.dart';
import 'instruction.model.dart';
import 'review.model.dart';

class RecipeModel {
  String? title;
  String? category;
  String? description;
  List<InstructionModel>? instructions;
  List<IngredientModel>? ingredients;
  int? likes;
  String? id;
  String? createdBy;
  String? image;
  List<ReviewModel>? reviews;
  bool? isPublic;
  bool? isShareable;
  int? prepTime;
  int? cookTime;
  int? servings;

  RecipeModel({
    this.title,
    this.category,
    this.description,
    this.instructions,
    this.ingredients,
    this.likes,
    this.id,
    this.createdBy,
    this.image,
    this.reviews,
    this.isPublic,
    this.isShareable,
    this.prepTime,
    this.cookTime,
    this.servings,
  });

  factory RecipeModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return RecipeModel(
      title: data?['title'],
      category: data?['category'],
      description: data?['description'],
      instructions: data?['instructions'] is Iterable ? InstructionModel().fromMap(data?['instructions']) : null,
      ingredients: data?['ingredients'] is Iterable ? IngredientModel().fromMap(data?['ingredients']) : null,
      likes: data?['likes'] < 0 ? 0 : data?['likes'],
      id: snapshot.id,
      createdBy: data?['createdBy'],
      image: data?['image'] ?? '',
      reviews: data?['reviews'] is Iterable ? ReviewModel().fromMap(data?['reviews']) : null,
      isPublic: data?['isPublic'],
      isShareable: data?['isShareable'],
      prepTime: data?['prepTime'],
      cookTime: data?['cookTime'],
      servings: data?['servings'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (title != null) "title": title,
      if (category != null) "category": category,
      if (description != null) "description": description,
      if (instructions != null) "instructions": instructions!.map((instruction) => instruction.toJson()),
      if (ingredients != null) "ingredients": ingredients!.map((ingredient) => ingredient.toJson()),
      if (likes != null) "likes": likes,
      if (createdBy != null) "createdBy": createdBy,
      if (image != null) "image": image,
      if (reviews != null) "reviews": reviews!.map((review) => review.toMap()),
      if (isPublic != null) "isPublic": isPublic,
      if (isShareable != null) "isShareable": isShareable,
      if (prepTime != null) "prepTime": prepTime,
      if (cookTime != null) "cookTime": cookTime,
      if (servings != null) "servings": servings,
    };
  }

  @override
  String toString() {
    return '$title - $id';
  }
}
