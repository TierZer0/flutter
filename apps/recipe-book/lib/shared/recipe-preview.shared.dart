import 'package:flutter/material.dart';
import 'package:ui/general/text.custom.dart';

import '../models/recipe.models.dart';
import 'items-grid.shared.dart';

class RecipePreviewShared extends StatelessWidget {
  final RecipeModel recipe;

  const RecipePreviewShared({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: width >= 1200 ? width * 0.4 : width,
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: [
          CText(
            recipe.description!,
            textLevel: EText.title2,
          ),
          Card(
            elevation: 5,
            clipBehavior: Clip.antiAlias,
            child: Container(
              height: 175,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                recipe.image!,
                fit: BoxFit.fitWidth,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null &&
                      loadingProgress?.cumulativeBytesLoaded ==
                          loadingProgress?.expectedTotalBytes) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ),
          Container(
            height: 150,
            width: double.maxFinite,
            child: FieldGridShared<RecipeModel>(
              fields: ['category', 'prepTime', 'cookTime'],
              data: new Map.from(recipe.toFirestore()),
            ),
          ),
        ],
      ),
    );
  }
}
