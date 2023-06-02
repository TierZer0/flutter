import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/recipes.service.dart';
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
    var theme = Theme.of(context);
    return CustomCard(
      card: cardType,
      child: InkWell(
        splashColor: theme.colorScheme.primary.withOpacity(0.3),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              useImage
                  ? FutureBuilder(
                      future: recipesService.getImage(recipe.image!),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data;
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  5.0,
                                ),
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                  Colors.white.withOpacity(
                                    Theme.of(context).brightness == Brightness.light ? 0.5 : 0.3,
                                  ),
                                  BlendMode.dstATop,
                                ),
                                image: new NetworkImage(
                                  data.toString(),
                                ),
                              ),
                            ),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    )
                  : SizedBox.shrink(),
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: recipe.title,
                      fontSize: 20.0,
                      fontFamily: "Lato",
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onBackground,
                    ),
                    recipe.category != '' || recipe.description != ''
                        ? CustomText(
                            text: recipe.category ?? recipe.description,
                            fontSize: 15.0,
                            fontFamily: "Lato",
                            color: theme.colorScheme.onBackground,
                          )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: CustomText(
                  text: recipe.likes.toString() + ' likes',
                  fontSize: 15.0,
                  fontFamily: "Lato",
                  color: theme.colorScheme.onBackground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
