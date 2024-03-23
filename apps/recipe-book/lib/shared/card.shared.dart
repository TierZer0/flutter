import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:recipe_book/models/recipe/recipe.model.dart';
import 'package:ui/general/card.custom.dart';

class CardShared extends StatelessWidget {
  final RecipeModel recipe;
  final VoidCallback onTap;
  final double? height;
  final double? width;
  final EdgeInsets margin;

  const CardShared({
    required this.recipe,
    required this.onTap,
    this.margin = EdgeInsets.zero,
    this.height,
    this.width,
  });

  const CardShared.small({
    required this.recipe,
    required this.onTap,
    this.margin = EdgeInsets.zero,
    this.height = 250,
    this.width = 150,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Material(
        borderRadius: BorderRadius.circular(10),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomCard(
                margin: EdgeInsets.zero,
                card: ECard.elevated,
                child: Container(
                  height: height,
                  width: width,
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
              Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        recipe.title!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                        textScaler: TextScaler.linear(1.2),
                      ),
                      Text(
                        recipe.description!,
                        textScaler: TextScaler.linear(1.0),
                      ),
                    ],
                  ),
                  // ElevatedButton(
                  //   onPressed: onTap,
                  //   child: Text('Save'),
                  // ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
