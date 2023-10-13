import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/services/user/recipe-books.service.dart';
import 'package:recipe_book/services/user/recipes.service.dart';
import 'package:recipe_book/shared/recipe-book-card.shared.dart';
import 'package:recipe_book/shared/recipe-card.shared.dart';
import 'package:ui/general/card.custom.dart';
import 'package:ui/ui.dart';

import '../../../models/models.dart';

class MyRecipeBooksTab extends StatefulWidget {
  final search;

  const MyRecipeBooksTab({super.key, this.search = ''});

  @override
  State<MyRecipeBooksTab> createState() => _MyRecipeBooksTabState();
}

class _MyRecipeBooksTabState extends State<MyRecipeBooksTab> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktopScreen: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: content(),
      ),
      mobileScreen: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 0.0,
        ),
        child: content(),
      ),
    );
  }

  late List<dynamic> _recipeBooks = [];

  Widget content() {
    return StreamBuilder(
      stream: recipeBookService.recipeBooksStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var recipeBooks = snapshot.data!.docs;
          _recipeBooks = recipeBooks.map((e) {
            final data = e.data();
            return {
              ...data.toFirestore(),
              'expanded': _recipeBooks.isNotEmpty
                  ? _recipeBooks[recipeBooks.indexOf(e)]['expanded']
                  : false,
            };
          }).toList();

          final items = List<int>.generate(_recipeBooks.length, (index) => index);
          final colorScheme = Theme.of(context).colorScheme;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: ExpansionPanelList(
                elevation: 0,
                animationDuration: Duration(milliseconds: 500),
                dividerColor: Colors.transparent,
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _recipeBooks[index]['expanded'] = isExpanded;
                  });
                },
                children: items.map((index) {
                  // print(_recipeBooks[index]);
                  return ExpansionPanel(
                    // backgroundColor: colorScheme.surfaceVariant,
                    canTapOnHeader: true,
                    isExpanded: _recipeBooks[index]['expanded']!,
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        title: CText(
                          _recipeBooks[index]['name']!,
                          textLevel: EText.title2,
                        ),
                        subtitle: CText(
                          _recipeBooks[index]['recipes'].length.toString() + ' recipes',
                          textLevel: EText.subtitle,
                        ),
                      );
                    },
                    body: FutureBuilder(
                      future: recipeBookService.getRecipeBook(recipeBooks[index].id),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final recipeBook = snapshot.data;
                          return FutureBuilder(
                            future: recipesService.recipesInBookFuture(
                              recipeIds: recipeBook!.recipes!,
                            ),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final recipes = snapshot.data!.docs;
                                final _recipes = recipes.map((e) => e.data()).toList();
                                return SizedBox(
                                  height: 175,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      return RecipeCard(
                                        recipe: _recipes[index],
                                        cardType: ECard.none,
                                        useImage: true,
                                        onTap: () {
                                          context.push('/recipe/${recipes[index].id}');
                                        },
                                      );
                                    },
                                    itemCount: _recipes.length,
                                  ),
                                );
                              }
                              return SizedBox.shrink();
                            },
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  );
                }).toList(),
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
