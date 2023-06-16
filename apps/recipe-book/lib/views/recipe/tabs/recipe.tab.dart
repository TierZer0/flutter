import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:recipe_book/shared/table.shared.dart';
import 'package:ui/ui.dart';

import '../../../shared/items-grid.shared.dart';

class RecipeTab extends StatefulWidget {
  final RecipeModel recipe;

  const RecipeTab({super.key, required this.recipe});

  @override
  RecipeTabState createState() => RecipeTabState();
}

enum ERecipeTabs { Details, Ingredients, Instructions }

class RecipeTabState extends State<RecipeTab> {
  ERecipeTabs _currentView = ERecipeTabs.Details;
  RecipeBookModel? recipeBook;

  @override
  void initState() {
    super.initState();

    getRecipeBook();
  }

  getRecipeBook() async {
    await userService.getRecipeBook(widget.recipe.recipeBook!).then((result) {
      setState(() {
        recipeBook = result;
      });
    });
  }

  Widget _buildContent(BuildContext context) {
    switch (_currentView) {
      case ERecipeTabs.Details:
        if (recipeBook == null) return SizedBox.shrink();

        Map data = new Map.from(widget.recipe.toFirestore());
        data['recipeBook'] = recipeBook?.name ?? '';
        return Container(
          height: 400,
          child: FieldGridShared<RecipeModel>(
            fields: ['recipeBook', 'category', 'prepTime', 'cookTime'],
            data: data,
          ),
        );
      case ERecipeTabs.Ingredients:
        return TableShared<IngredientModel>(
          fields: ['Item', 'Quantity', 'Unit'],
          data: widget.recipe.ingredients!,
        );
      case ERecipeTabs.Instructions:
        return TableShared<InstructionModel>(
          fields: ['Title', 'Description'],
          data: widget.recipe.instructions!,
          useCheckbox: true,
        );
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    var recipe = widget.recipe;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: SingleChildScrollView(
        child: Wrap(
          runSpacing: 10.0,
          children: [
            Card(
              elevation: 5,
              clipBehavior: Clip.antiAlias,
              child: Container(
                height: 300,
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
            SizedBox(
              height: 5,
            ),
            SizedBox(
              width: double.maxFinite,
              child: SegmentedButton<ERecipeTabs>(
                segments: const <ButtonSegment<ERecipeTabs>>[
                  ButtonSegment<ERecipeTabs>(
                    value: ERecipeTabs.Details,
                    label: CText(
                      'Details',
                      textLevel: EText.button,
                    ),
                  ),
                  ButtonSegment<ERecipeTabs>(
                    value: ERecipeTabs.Ingredients,
                    label: CText(
                      'Ingredients',
                      textLevel: EText.button,
                    ),
                  ),
                  ButtonSegment<ERecipeTabs>(
                    value: ERecipeTabs.Instructions,
                    label: CText(
                      'Instructions',
                      textLevel: EText.button,
                    ),
                  ),
                ],
                selected: <ERecipeTabs>{_currentView},
                onSelectionChanged: (Set<ERecipeTabs> newSelection) {
                  setState(() {
                    _currentView = newSelection.first;
                  });
                },
              ),
            ),
            _buildContent(context),
          ],
        ),
      ),
    );
  }
}
