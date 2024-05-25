import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recipe_book/models/recipe/ingredient/ingredient.dart';
import 'package:recipe_book/models/recipe/instruction/instruction.dart';
import 'package:recipe_book/models/recipe/review/review.dart';

part 'recipe.freezed.dart';

@freezed
class Recipe with _$Recipe {
  const Recipe._();

  const factory Recipe({
    String? title,
    String? category,
    String? description,
    List<Instruction>? instructions,
    List<Ingredient>? ingredients,
    int? likes,
    String? id,
    String? createdBy,
    String? image,
    List<Review>? reviews,
    bool? isPublic,
    bool? isShareable,
    int? prepTime,
    int? cookTime,
    int? totalTime,
    int? servings,
  }) = _Recipe;

  factory Recipe.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Recipe(
      title: data?['title'],
      category: data?['category'],
      description: data?['description'],
      instructions: data?['instructions'] is Iterable ? Instruction().fromMap(data?['instructions']) : null,
      ingredients: data?['ingredients'] is Iterable ? Ingredient().fromMap(data?['ingredients']) : null,
      likes: data?['likes'] < 0 ? 0 : data?['likes'],
      id: snapshot.id,
      createdBy: data?['createdBy'],
      image: data?['image'] ?? '',
      reviews: data?['reviews'] is Iterable ? Review().fromMap(data?['reviews']) : null,
      isPublic: data?['isPublic'],
      isShareable: data?['isShareable'],
      prepTime: data?['prepTime'],
      cookTime: data?['cookTime'],
      totalTime: data?['totalTime'],
      servings: data?['servings'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (title != null) "title": title,
      if (category != null) "category": category,
      if (description != null) "description": description,
      if (instructions != null) "instructions": instructions!.map((instruction) => instruction.toMap()),
      if (ingredients != null) "ingredients": ingredients!.map((ingredient) => ingredient.toMap()),
      if (likes != null) "likes": likes,
      if (createdBy != null) "createdBy": createdBy,
      if (image != null) "image": image,
      if (reviews != null) "reviews": reviews!.map((review) => review.toMap()),
      if (isPublic != null) "isPublic": isPublic,
      if (isShareable != null) "isShareable": isShareable,
      if (prepTime != null) "prepTime": prepTime,
      if (cookTime != null) "cookTime": cookTime,
      if (totalTime != null) "totalTime": totalTime,
      if (servings != null) "servings": servings,
    };
  }

  @override
  String toString() {
    return '$title - $id';
  }
}
