import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/shared/table.shared.dart';
import 'package:recipe_book/services/recipes.service.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:ui/ui.dart';

class RecipeTab extends StatefulWidget {
  final RecipeModel recipe;

  const RecipeTab({super.key, required this.recipe});

  @override
  RecipeTabState createState() => RecipeTabState();
}

class RecipeTabState extends State<RecipeTab> {
  List<String> _views = ['Details', 'Ingredients', 'Instructions'];
  String? _currentView = 'Details';
  currentView(String view) {
    setState(() {
      _currentView = view;
    });
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var recipe = widget.recipe;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // FutureBuilder(
            //   future: recipesService.getImage(recipe!.image!),
            //   builder: (context, snapshot) {
            //     if (snapshot.hasData) {
            //       final data = snapshot.data;
            //       return Card(
            //         elevation: 5,
            //         clipBehavior: Clip.antiAlias,
            //         child: Container(
            //           height: 300,
            //           width: MediaQuery.of(context).size.width,
            //           child: Image.network(
            //             data.toString(),
            //             fit: BoxFit.fitWidth,
            //             loadingBuilder: (context, child, loadingProgress) {
            //               if (loadingProgress == null &&
            //                   loadingProgress?.cumulativeBytesLoaded ==
            //                       loadingProgress?.expectedTotalBytes) {
            //                 return child;
            //               }
            //               return Center(
            //                 child: CircularProgressIndicator(),
            //               );
            //             },
            //           ),
            //         ),
            //       );
            //     }

            //     return SkeletonLoader(
            //       items: 1,
            //       period: Duration(seconds: 4),
            //       baseColor: theme.colorScheme.surface,
            //       highlightColor: theme.colorScheme.primary,
            //       direction: SkeletonDirection.ltr,
            //       builder: Card(
            //         margin: EdgeInsets.only(right: 10.0, bottom: 15.0, left: 20.0),
            //         child: SizedBox(
            //           height: 300,
            //           width: 300,
            //         ),
            //       ),
            //     );
            //   },
            // ),
            SizedBox(
              height: 5,
            ),
            Center(
              child: Wrap(
                spacing: 20.0,
                children: _views
                    .map((view) => ChoiceChip(
                          label: CText(
                            view,
                            textLevel: EText.button,
                          ),
                          selected: view == _currentView,
                          onSelected: (selected) {
                            if (view == _currentView) {
                              return;
                            }
                            setState(() {
                              _currentView = selected ? view : null;
                            });
                          },
                        ))
                    .toList(),
              ),
            ),
            _currentView == 'Ingredients'
                ? TableShared<IngredientModel>(
                    fields: ['Item', 'Quantity', 'Unit'],
                    data: recipe.ingredients!,
                  )
                : SizedBox.shrink(),
            _currentView == 'Instructions'
                ? TableShared<InstructionModel>(
                    fields: ['Title', 'Decription'],
                    data: recipe.instructions!,
                    useCheckbox: true,
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
