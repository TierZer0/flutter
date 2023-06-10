import 'dart:math';

import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/shared/table.shared.dart';
import 'package:ui/general/card.custom.dart';

class DetailedRecipeCard extends StatelessWidget {
  final ECard cardType;
  final double elevation;

  final VoidCallback? onTap;

  final RecipeModel recipe;

  const DetailedRecipeCard({
    super.key,
    required this.recipe,
    this.cardType = ECard.filled,
    required this.onTap,
    this.elevation = 2,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return CustomCard(
      elevation: elevation,
      card: cardType,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: double.maxFinite,
                height: 295,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      5.0,
                    ),
                  ),
                ),
                child: Image(
                  image: NetworkImage(recipe.image!),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ),
            Positioned(
              top: 250,
              left: 0,
              right: 0,
              child: CustomCard(
                elevation: 1,
                card: ECard.elevated,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        recipe.title ?? '',
                        textScaleFactor: 1.5,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        recipe.description ?? '',
                        textScaleFactor: 1.25,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 330,
              left: 0,
              right: 0,
              child: Column(
                children: [
                  TableShared<IngredientModel>(
                    fields: ['Item', 'Quantity', 'Measurement'],
                    data: recipe.ingredients!,
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: MaterialButton(
                onPressed: onTap,
                child: Text(
                  'View Recipe',
                  textScaleFactor: 1.25,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
