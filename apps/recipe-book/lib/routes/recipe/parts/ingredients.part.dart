import 'package:flutter/material.dart';
import 'package:recipe_book/models/models.dart';

class RecipeIngredientsPart extends StatefulWidget {
  final List<Ingredient> ingredients;

  const RecipeIngredientsPart({
    Key? key,
    required this.ingredients,
  }) : super(key: key);

  @override
  _RecipeIngredientsPartState createState() => _RecipeIngredientsPartState();
}

class _RecipeIngredientsPartState extends State<RecipeIngredientsPart> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.ingredients.length,
            itemBuilder: (context, index) {
              final ingredient = widget.ingredients[index];
              return ListTile(
                dense: true,
                title: Text(
                  ingredient.item!,
                  textScaler: TextScaler.linear(
                    1.25,
                  ),
                ),
                subtitle: Text(
                  ingredient.quantity! + ' ' + ingredient.unit!,
                  textScaler: TextScaler.linear(
                    1.0,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
