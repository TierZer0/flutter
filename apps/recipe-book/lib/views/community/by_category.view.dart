import 'package:flutter/material.dart';
import 'package:recipe_book/services/recipes/recipes.service.dart';
import 'package:recipe_book/shared/recipe-accordion.shared.dart';

class ByCategoryCommunityView extends StatelessWidget {
  final String category;

  const ByCategoryCommunityView({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
      body: StreamBuilder(
        stream: recipesService.getRecipesStream(filters: {'category': category}),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final recipes = snapshot.data!.docs;
            List<dynamic> _recipes = recipes.map((e) => e.data()).toList();
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 125.0,
                ),
                child: Column(
                  children: List.generate(
                    _recipes.length,
                    (index) {
                      return RecipeAccordion(
                        recipe: _recipes[index],
                        id: recipes[index].id,
                        expandedSizes: [
                          80,
                          600,
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
