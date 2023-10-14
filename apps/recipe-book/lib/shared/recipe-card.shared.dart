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
    return CustomCard(
      card: cardType,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: SizedBox(
          width: 300,
          height: height,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(
              children: [
                useImage
                    ? CustomCard(
                        card: cardType,
                        child: Container(
                          width: 110,
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
                        ),
                      )
                    : SizedBox.shrink(),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 5.0,
                    top: 5.0,
                    bottom: 10.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CText(
                        recipe.title!,
                        textLevel: EText.title,
                        weight: FontWeight.bold,
                      ),
                      recipe.description != '' || recipe.description != null
                          ? CText(
                              recipe.description!,
                              textLevel: EText.title2,
                            )
                          : SizedBox.shrink(),
                      Expanded(child: SizedBox.shrink()),
                      CText(
                        recipe.likes.toString() + ' likes',
                        textLevel: EText.subtitle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
