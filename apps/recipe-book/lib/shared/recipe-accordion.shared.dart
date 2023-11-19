import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/models/models.dart';
import 'package:recipe_book/shared/items-grid.shared.dart';
import 'package:ui/general/card.custom.dart';
import 'package:ui/general/text.custom.dart';

class RecipeAccordion extends StatefulWidget {
  // final String title;
  // final String? subtitle;
  // final Widget? leading;
  final RecipeModel recipe;
  final String id;

  /// The expanded and collapsed sizes of the accordion.
  /// [0] is the collapsed size.
  /// [1] is the expanded size.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  final List<double> expandedSizes;

  const RecipeAccordion({
    super.key,
    required this.recipe,
    required this.id,
    this.expandedSizes = const [80, 250],
  });

  @override
  State<RecipeAccordion> createState() => _RecipeAccordionState();
}

class _RecipeAccordionState extends State<RecipeAccordion> with TickerProviderStateMixin {
  bool isExpanded = false;
  late RecipeModel recipe;

  @override
  initState() {
    super.initState();
    recipe = widget.recipe;
  }

  _handleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: double.maxFinite,
      height: isExpanded ? widget.expandedSizes[1] : widget.expandedSizes[0],
      duration: Duration(milliseconds: 450),
      child: CustomCard(
        margin: EdgeInsets.symmetric(
          horizontal: 5.0,
          vertical: isExpanded ? 5.0 : 0.0,
        ),
        card: isExpanded ? ECard.elevated : ECard.filled,
        child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: AnimatedSwitcher(
            switchInCurve: Curves.easeInToLinear,
            switchOutCurve: Curves.easeOut,
            duration: Duration(milliseconds: 500),
            child: isExpanded ? buildExpanded() : buildCollapsed(),
          ),
        ),
      ),
    );
  }

  Widget buildExpanded() {
    return SizedBox(
      height: widget.expandedSizes[1],
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            InkWell(
              onTap: _handleExpand,
              child: SizedBox(
                height: widget.expandedSizes[0] - 10,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 11,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * .6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CText(
                                recipe.title!,
                                textLevel: EText.title,
                              ),
                              CText(
                                recipe.description!,
                                textLevel: EText.title2,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Icon(
                          isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CustomCard(
              card: ECard.elevated,
              child: Image.network(
                recipe.image!,
                width: MediaQuery.of(context).size.width * .9,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 150,
              child: FieldGridShared(
                fields: ['category', 'prepTime', 'cookTime'],
                data: new Map.from(recipe.toFirestore()),
              ),
            ),
            Expanded(child: SizedBox()),
            Align(
              alignment: Alignment.bottomCenter,
              child: FilledButton(
                onPressed: () => context.push('/recipe/${widget.id}'),
                child: CText(
                  'View Recipe',
                  textLevel: EText.button,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildCollapsed() {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: _handleExpand,
            child: SizedBox(
              height: widget.expandedSizes[0] - 10,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 11,
                      child: Wrap(
                        spacing: 10.0,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(recipe.image!),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .6,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CText(
                                  recipe.title!,
                                  textLevel: EText.title,
                                ),
                                CText(
                                  recipe.description!,
                                  textLevel: EText.title2,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        size: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
