import 'package:flutter/material.dart';
import 'package:recipe_book/models/models.dart';
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
      duration: Duration(milliseconds: 350),
      child: CustomCard(
        card: isExpanded ? ECard.filled : ECard.outlined,
        child: AnimatedSwitcher(
          switchInCurve: Curves.easeInToLinear,
          switchOutCurve: Curves.easeOut,
          duration: Duration(milliseconds: 500),
          child: isExpanded ? buildExpanded() : buildCollapsed(),
        ),
      ),
    );
  }

  Widget buildExpanded() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
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
                    flex: 3,
                    child: Wrap(
                      spacing: 10.0,
                      children: [
                        Column(
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
                        )
                      ],
                    ),
                  ),
                  const Expanded(
                    flex: 5,
                    child: SizedBox(),
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
            width: MediaQuery.of(context).size.width * .5,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
      ],
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
                      flex: 3,
                      child: Wrap(
                        spacing: 10.0,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(recipe.image!),
                          ),
                          Column(
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
                          )
                        ],
                      ),
                    ),
                    const Expanded(
                      flex: 5,
                      child: SizedBox(),
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
