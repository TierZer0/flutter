import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:ui/general/card.custom.dart';
import 'package:ui/general/text.custom.dart';

class RecipeCard extends StatelessWidget {
  final ECard cardType;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  final RecipeModel recipe;

  final bool useImage;

  const RecipeCard({
    super.key,
    required this.recipe,
    this.cardType = ECard.filled,
    required this.onTap,
    this.onLongPress = null,
    this.useImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      card: cardType,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CText(
                recipe.title!,
                textLevel: EText.title,
                weight: FontWeight.bold,
              ),
              useImage
                  ? Container(
                      height: 125,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            5.0,
                          ),
                        ),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: new NetworkImage(
                            recipe.image!,
                          ),
                        ),
                      ),
                    )
                  : SizedBox.shrink(),
              recipe.category != '' || recipe.description != ''
                  ? CText(
                      recipe.category ?? recipe.description!,
                      textLevel: EText.title2,
                    )
                  : SizedBox.shrink(),
              CText(
                recipe.likes.toString() + ' likes',
                textLevel: EText.subtitle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
