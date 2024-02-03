import 'package:flutter/material.dart';
import 'package:recipe_book/shared/table.shared.dart';
import 'package:ui/ui.dart';

import '../../../models/models.dart';
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

  @override
  void initState() {
    super.initState();

    // getRecipeBook();
  }

  // getRecipeBook() async {
  //   print(widget.recipe.recipeBook!);
  //   await recipeBookService.getRecipeBook(widget.recipe.recipeBook!).then((result) {
  //     setState(() {
  //       recipeBook = result;
  //     });
  //   });
  // }

  Widget _buildContent(BuildContext context) {
    switch (_currentView) {
      case ERecipeTabs.Details:
        // if (recipeBook == null) return SizedBox.shrink();

        Map data = new Map.from(widget.recipe.toFirestore());
        return Container(
          height: 400,
          child: FieldGridShared<RecipeModel>(
            fields: ['category', 'prepTime', 'cookTime'],
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
    return ResponsiveWidget(
      desktopScreen: buildDesktop(context),
      mobileScreen: buildMobile(context),
    );
  }

  Widget buildDesktop(BuildContext context) {
    var recipe = widget.recipe;
    Map data = new Map.from(widget.recipe.toFirestore());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 5,
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    height: 400,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(
                      recipe.image!,
                      fit: BoxFit.fitWidth,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null && loadingProgress?.cumulativeBytesLoaded == loadingProgress?.expectedTotalBytes) {
                          return child;
                        }
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                  ),
                  child: CText(
                    recipe.description!,
                    textLevel: EText.title2,
                  ),
                ),
                Container(
                  height: 400,
                  child: FieldGridShared<RecipeModel>(
                    fields: ['category', 'prepTime', 'cookTime'],
                    data: data,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                TableShared<IngredientModel>(
                  fields: ['Item', 'Quantity', 'Unit'],
                  data: widget.recipe.ingredients!,
                ),
                TableShared<InstructionModel>(
                  fields: ['Title', 'Description'],
                  data: widget.recipe.instructions!,
                  useCheckbox: true,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildMobile(BuildContext context) {
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
                    if (loadingProgress == null && loadingProgress?.cumulativeBytesLoaded == loadingProgress?.expectedTotalBytes) {
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
