import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/shared/recipe-card.shared.dart';
import 'package:ui/general/card.custom.dart';

class SearchExpansionList extends ConsumerStatefulWidget {
  final List<dynamic> recipeBooks;

  const SearchExpansionList({
    required this.recipeBooks,
  });

  @override
  _SearchExpansionListState createState() => _SearchExpansionListState();
}

class _SearchExpansionListState extends ConsumerState<SearchExpansionList> {
  @override
  Widget build(BuildContext context) {
    final items = List<int>.generate(widget.recipeBooks.length, (index) => index);

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 0,
        ),
        child: ExpansionPanelList(
          dividerColor: Colors.transparent,
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              widget.recipeBooks[index]['expanded'] = isExpanded;
            });
          },
          children: items.map((index) {
            final recipeBook = widget.recipeBooks[index];
            return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                  title: Text(
                    recipeBook['name'],
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    textScaler: TextScaler.linear(
                      1.2,
                    ),
                  ),
                  subtitle: Text(
                    'Recipes: ${recipeBook['recipeIds']?.length}',
                    textScaler: TextScaler.linear(
                      1.0,
                    ),
                  ),
                );
              },
              body: SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final recipes = recipeBook['recipes'] ?? [];

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      child: RecipeCard.small(
                        recipe: recipes[index],
                        cardType: ECard.filled,
                        useImage: true,
                        onTap: () {
                          context.push('/recipe/${recipes[index].id}');
                        },
                      ),
                    );
                  },
                  itemCount: recipeBook['recipes'].length,
                ),
              ),
              isExpanded: recipeBook['expanded'],
            );
          }).toList(),
        ),
      ),
    );
  }
}
