import 'package:flutter/material.dart';
import 'package:ui/general/card.custom.dart';
import 'package:ui/general/text.custom.dart';

import '../models/models.dart';

class RecipeBookCard extends StatelessWidget {
  final ECard cardType;
  final VoidCallback? onTap;

  final RecipeBook recipeBook;

  const RecipeBookCard({
    super.key,
    required this.recipeBook,
    this.cardType = ECard.filled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return CustomCard(
      card: cardType,
      child: InkWell(
        splashColor: theme.colorScheme.primary.withOpacity(0.3),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  recipeBook.name!,
                  textScaleFactor: 1.6,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              CText(
                '${recipeBook.recipeIds!.length.toString()} Recipes',
                textLevel: EText.caption,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
