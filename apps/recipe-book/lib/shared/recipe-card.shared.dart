import 'package:flutter/material.dart';
import 'package:ui/general/card.custom.dart';
import 'package:ui/general/text.custom.dart';

import '../models/models.dart';

class RecipeCard extends StatelessWidget {
  final ECard cardType;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double? height;

  final RecipeModel recipe;

  final bool useImage;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.cardType = ECard.filled,
    required this.onTap,
    this.onLongPress = null,
    this.useImage = false,
    this.height = null,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            CustomCard(
              card: ECard.elevated,
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: new NetworkImage(
                      recipe.image!,
                    ),
                  ),
                ),
              ),
            ),
            CText(
              recipe.title!,
              textLevel: EText.title,
              weight: FontWeight.bold,
            ),
          ],
        ),
      ),
    );
  }
}
