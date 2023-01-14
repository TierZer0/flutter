import 'package:flutter/material.dart';
import 'package:recipe_book/models/models.dart';
import 'package:ui/ui.dart';

class SaveStep extends StatelessWidget {
  Recipe recipe;

  SaveStep(this.recipe);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: recipe.toString(),
          fontSize: 25.0,
          fontWeight: FontWeight.w700,
          fontFamily: "Lato",
          color: (theme.textTheme.titleLarge?.color)!,
        ),
        const SizedBox(
          height: 25.0,
        ),
        CustomText(
          text: 'Ingredients',
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          fontFamily: "Lato",
          color: (theme.textTheme.titleLarge?.color)!,
        ),
        SizedBox(
          height: 100.0,
          child: ListView(
            children: recipe.listIngredients(
              (theme.textTheme.titleLarge?.color)!,
            ),
          ),
        ),
        const SizedBox(
          height: 25.0,
        ),
        CustomText(
          text: 'Steps',
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          fontFamily: "Lato",
          color: (theme.textTheme.titleLarge?.color)!,
        ),
        SizedBox(
          height: 100.0,
          child: ListView(
            children: recipe.listSteps(
              (theme.textTheme.titleLarge?.color)!,
            ),
          ),
        ),
      ],
    );
  }
}
