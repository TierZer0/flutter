import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class RecipeBook {}

class Recipe {
  String title;
  String category;
  String description;
  List<Instruction> steps;
  List<Ingredient> ingredients;
  int likes;

  Recipe(this.title, this.category, this.description, this.ingredients, this.steps, this.likes);

  @override
  String toString() {
    return '$title - $description';
  }

  List<Widget> listSteps(Color textColor) {
    return steps
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

  @override
  String toString() {
    return '$item ($quanity $unit)';
  }
}
