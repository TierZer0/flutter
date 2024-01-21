import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/providers/recipe-books/recipe-books.providers.dart' show getRecipeBooks;
import 'package:recipe_book/providers/recipes/recipes.providers.dart';
import 'package:recipe_book/services/user/recipe-books.service.dart';
import 'package:recipe_book/services/recipes/recipes.service.dart';
import 'package:recipe_book/shared/recipe-card.shared.dart';
import 'package:ui/ui.dart';

import 'dart:math' as math;

import '../../../models/models.dart';

class MyRecipeBooksTab extends ConsumerStatefulWidget {
  final search;

  const MyRecipeBooksTab({super.key, this.search = ''});

  @override
  _MyRecipeBooksTabState createState() => _MyRecipeBooksTabState();
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight || minHeight != oldDelegate.minHeight || child != oldDelegate.child;
  }
}

class _MyRecipeBooksTabState extends ConsumerState<MyRecipeBooksTab> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktopScreen: buildDesktop(context),
      mobileScreen: buildMobile(context),
    );
  }

  late List<dynamic> _recipeBooks = [];

  Widget buildDesktop(BuildContext context) {
    return StreamBuilder(
      stream: recipeBookService.recipeBooksStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var recipeBooks = snapshot.data!.docs;
          _recipeBooks = recipeBooks.map((e) {
            final data = e.data();
            return {
              ...data.toFirestore(),
              'expanded': _recipeBooks.isNotEmpty ? _recipeBooks[recipeBooks.indexOf(e)]['expanded'] : false,
            };
          }).toList();

          final items = List<int>.generate(_recipeBooks.length, (index) => index);
          return CustomScrollView(
            slivers: items
                .map(
                  (index) {
                    return [
                      SliverPersistentHeader(
                        pinned: true,
                        delegate: _SliverAppBarDelegate(
                          maxHeight: 50,
                          minHeight: 50,
                          child: Material(
                            elevation: 3,
                            color: Theme.of(context).colorScheme.secondaryContainer,
                            child: Center(
                              child: CText(
                                "${_recipeBooks[index]['name']!}" + ' Recipe Book',
                                textLevel: EText.title,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: FutureBuilder(
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
                                    final recipeIndexes = List<int>.generate(_recipes.length, (index) => index);
                                    return Wrap(
                                      spacing: 10.0,
                                      runSpacing: 20.0,
                                      children: recipeIndexes.map((index) {
                                        index = 0;
                                        final RecipeModel recipe = _recipes[index];
                                        final String recipeId = recipes[index].id;
                                        return RecipeCard(
                                          recipe: recipe,
                                          height: 125,
                                          cardType: ECard.elevated,
                                          onTap: () => context.push('/recipe/${recipeId}'),
                                          // onLongPress: () => _previewDialog(context, recipe, recipeId, isMobile: false),
                                          useImage: true,
                                        );
                                      }).toList(),
                                    );
                                  }
                                  if (snapshot.data == null) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 20.0,
                                      ),
                                      child: Center(
                                        child: CText(
                                          'No recipes in this book',
                                          textLevel: EText.title2,
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
                            return SizedBox.shrink();
                          },
                        ),
                      ),
                    ];
                  },
                )
                .expand(
                  (element) => element,
                )
                .toList(),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget buildMobile(BuildContext context) {
    final recipeBooksProvider = ref.watch(getRecipeBooks);

    return switch (recipeBooksProvider) {
      AsyncData(:final value) => Builder(
          builder: (context) {
            final recipeBooks = value.payload ?? [];
            _recipeBooks = recipeBooks.map((e) {
              return {
                ...e.toFirestore(),
                'expanded': _recipeBooks.isNotEmpty ? _recipeBooks[recipeBooks.indexOf(e)]['expanded'] : false,
              };
            }).toList();
            final items = List<int>.generate(_recipeBooks.length, (index) => index);

            return SingleChildScrollView(
              child: ExpansionPanelList(
                elevation: 2,
                animationDuration: Duration(milliseconds: 500),
                dividerColor: Colors.transparent,
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _recipeBooks[index]['expanded'] = isExpanded;
                  });
                },
                children: items.map((index) {
                  final recipeBook = _recipeBooks[index];
                  final recipesInBookProvider = ref.watch(getRecipesInBookProvider(recipeBook['id']));

                  return ExpansionPanel(
                    canTapOnHeader: true,
                    isExpanded: recipeBook['expanded']!,
                    headerBuilder: (context, isExpanded) {
                      return ListTile(
                        title: CText(
                          recipeBook['name']!,
                          textLevel: EText.title2,
                        ),
                        subtitle: CText(
                          recipeBook['recipes'].length.toString() + ' recipes',
                          textLevel: EText.subtitle,
                        ),
                      );
                    },
                    body: switch (recipesInBookProvider) {
                      AsyncData(:final value) => SizedBox(
                          height: 175,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              final recipes = value.payload ?? [];

                              return RecipeCard(
                                recipe: recipes[index],
                                cardType: ECard.none,
                                useImage: true,
                                onTap: () {
                                  context.push('/recipe/${recipes[index].id}');
                                },
                              );
                            },
                            itemCount: value.payload.length,
                          ),
                        ),
                      AsyncLoading() => Center(
                          child: CircularProgressIndicator(),
                        ),
                      _ => Center(
                          child: CText('No Recipes in book'),
                        ),
                    },
                  );
                }).toList(),
              ),
            );
          },
        ),
      AsyncLoading() => Center(
          child: CircularProgressIndicator(),
        ),
      _ => Center(
          child: CText('No Recipe Books'),
        ),
    };
  }
}
