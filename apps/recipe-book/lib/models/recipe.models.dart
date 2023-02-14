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

class Recipe {
  String title;
  String category;
  String recipeBook;
  String description;
  List<Instruction> instructions;
  List<Ingredient> ingredients;
  int likes;
  String id;
  String createdBy;

  Recipe(
    this.title,
    this.category,
    this.recipeBook,
    this.description,
    this.ingredients,
    this.instructions,
    this.likes,
    this.id,
    this.createdBy,
  );

  Recipe.fromJson(Map<String, dynamic> json)
      : this(
          json['title'],
          json['category'],
          json['recipeBook'],
          json['description'],
          json['ingredients'],
          json['instructions'],
          json['likes'],
          json['id'],
          json['createdBy'],
        );

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> _instructions = [];
    for (var element in instructions) {
      _instructions.add(element.toMap());
    }

    List<Map<String, dynamic>> _ingredients = [];
    for (var element in ingredients) {
      _ingredients.add(element.toMap());
    }

    return {
      'title': title,
      'category': category,
      'recipeBook': recipeBook,
      'description': description,
      'instrunctions': _instructions,
      'ingredients': _ingredients,
      'likes': likes,
      'createdBy': createdBy
    };
  }

  @override
  String toString() {
    return '$title - $description';
  }

  List<Widget> listSteps(Color textColor) {
    return instructions
        .map<Widget>(
          (Instruction item) => CustomText(
            text: item.toString(),
            fontSize: 20.0,
            fontFamily: "Lato",
            color: textColor,
          ),
        )
        .toList();
  }

  List<Widget> listIngredients(Color textColor) {
    return ingredients
        .map<Widget>(
          (Ingredient item) => CustomText(
            text: item.toString(),
            fontSize: 20.0,
            fontFamily: "Lato",
            color: textColor,
          ),
        )
        .toList();
  }
}

class Instruction {
  String title;
  int order;
  String description;

  Instruction(this.title, this.order, this.description);

  Map<String, dynamic> toMap() {
    return {'title': title, 'order': order, 'description': description};
  }

  @override
  String toString() {
    return 'Step $order: $title - $description';
  }
}

class Ingredient {
  String item;
  String quanity;
  String unit;

  Ingredient(this.item, this.quanity, this.unit);

  Map<String, dynamic> toMap() {
    return {'item': item, 'quantity': quanity, 'unit': unit};
  }

  @override
  String toString() {
    return '$item ($quanity $unit)';
  }
}
