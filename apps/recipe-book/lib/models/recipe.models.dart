import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class RecipeBookModel {
  String? id;
  String? name;
  String? category;
  List<dynamic>? recipes;
  String? createdBy;
  int? likes;

  RecipeBookModel({
    this.id,
    this.name,
    this.category,
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
      id: data?['id'],
      name: data?['name'],
      category: data?['category'],
      recipes: data?['recipes'] is Iterable ? List<String>.from(data?['recipes']) : null,
      createdBy: data?['createdBy'],
      likes: data?['likes'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (category != null) "category": category,
      if (recipes != null) "recipes": recipes,
      if (createdBy != null) "createdBy": createdBy,
      if (likes != null) "likes": likes,
    };
  }
}

class RecipeModel {
  String? title;
  String? category;
  String? recipeBook;
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
    this.recipeBook,
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
      recipeBook: data?['recipeBook'],
      description: data?['description'],
      instructions: data?['instructions'] is Iterable
          ? InstructionModel().fromMap(data?['instructions'])
          : null,
      ingredients:
          data?['ingredients'] is Iterable ? IngredientModel().fromMap(data?['ingredients']) : null,
      likes: data?['likes'],
      id: data?['id'],
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
      if (recipeBook != null) "recipeBook": recipeBook,
      if (description != null) "description": description,
      if (instructions != null)
        "instructions": instructions!.map((instruction) => instruction.toJson()),
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

  List<Widget> listSteps(Color textColor) {
    return instructions!
        .map<Widget>(
          (InstructionModel item) => CustomText(
            text: item.toString(),
            fontSize: 20.0,
            fontFamily: "Lato",
            color: textColor,
          ),
        )
        .toList();
  }

  List<Widget> listIngredients(Color textColor) {
    return ingredients!
        .map<Widget>(
          (IngredientModel item) => CustomText(
            text: item.toString(),
            fontSize: 20.0,
            fontFamily: "Lato",
            color: textColor,
          ),
        )
        .toList();
  }
}

class InstructionModel {
  String? title;
  int? order;
  String? description;

  InstructionModel({
    this.title,
    this.order,
    this.description,
  });

  List<InstructionModel> fromMap(List<dynamic> instructions) {
    return instructions
        .map(
          (instruction) => InstructionModel(
            title: instruction['title'],
            order: instruction['order'],
            description: instruction['description'],
          ),
        )
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (order != null) 'order': order,
      if (description != null) 'description': description
    };
  }

  @override
  String toString() {
    return 'Step $order: $title - $description';
  }
}

class IngredientModel {
  String? item;
  String? quantity;
  String? unit;

  IngredientModel({
    this.item,
    this.quantity,
    this.unit,
  });

  List<IngredientModel> fromMap(List<dynamic> ingredients) {
    return ingredients
        .map(
          (ingredient) => IngredientModel(
            item: ingredient['item'],
            quantity: ingredient['quantity'],
            unit: ingredient['unit'],
          ),
        )
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      if (item != null) 'item': item,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
    };
  }

  @override
  String toString() {
    return '$item ($quantity $unit)';
  }
}

class ReviewModel {
  String? review;
  String? createdBy;
  int? stars;

  ReviewModel({
    this.review,
    this.createdBy,
    this.stars,
  });

  List<ReviewModel> fromMap(List<dynamic> reviews) {
    return reviews
        .map(
          (review) => ReviewModel(
            review: review['review'],
            createdBy: review['createdBy'],
            stars: review['stars'],
          ),
        )
        .toList();
  }

  Map<String, dynamic> toMap() {
    return {
      if (review != null) 'review': review,
      if (createdBy != null) 'createdBy': createdBy,
      if (stars != null) 'stars': stars,
    };
  }
}
