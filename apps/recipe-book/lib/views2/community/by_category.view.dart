import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/providers/recipes/recipes.providers.dart';
import 'package:recipe_book/shared/recipe-accordion.shared.dart';

class ByCategoryCommunityView extends ConsumerWidget {
  final String category;

  const ByCategoryCommunityView({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    final getRecipesByCategory = ref.watch(getRecipesByCategoryProvider(category));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
        child: Hero(
          tag: category,
          child: AppBar(
            backgroundColor: colorScheme.tertiaryContainer,
            title: Text(category),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(20),
              ),
            ),
          ),
        ),
      ),
      body: switch (getRecipesByCategory) {
        AsyncData(:final value) => Builder(
            builder: (context) {
              final recipes = value.payload;
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 125.0,
                  ),
                  child: Column(
                    children: List.generate(
                      recipes.length,
                      (index) {
                        return RecipeAccordion(
                          recipe: recipes[index],
                          id: recipes[index].id,
                          expandedSizes: [
                            80,
                            340,
                          ],
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        AsyncLoading() => Center(
            child: CircularProgressIndicator(),
          ),
        _ => Center(
            child: Text('Error loading recipes.'),
          ),
      },
    );

    // return Scaffold(
    //   extendBodyBehindAppBar: true,
    // appBar: PreferredSize(
    //   preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
    //   child: Hero(
    //     tag: category,
    //     child: AppBar(
    //       backgroundColor: colorScheme.tertiaryContainer,
    //       title: Text(category),
    //       elevation: 4,
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.vertical(
    //           bottom: Radius.circular(20),
    //         ),
    //       ),
    //     ),
    //   ),
    // ),
    //   body: StreamBuilder(
    //     stream: recipesService.getRecipesStream(filters: {'category': category}),
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         final recipes = snapshot.data!.docs;
    //         List<dynamic> _recipes = recipes.map((e) => e.data()).toList();
    //         return SingleChildScrollView(
    //           child: Padding(
    //             padding: const EdgeInsets.only(
    //               top: 125.0,
    //             ),
    //             child: Column(
    //               children: List.generate(
    //                 _recipes.length,
    //                 (index) {
    //                   return RecipeAccordion(
    //                     recipe: _recipes[index],
    //                     id: recipes[index].id,
    //                     expandedSizes: [
    //                       80,
    //                       600,
    //                     ],
    //                   );
    //                 },
    //               ),
    //             ),
    //           ),
    //         );
    //       }
    //       if (snapshot.hasError) {
    //         return Center(
    //           child: Text(snapshot.error.toString()),
    //         );
    //       }
    //       return Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     },
    //   ),
    // );
  }
}
