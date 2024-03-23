import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipe_book/providers/recipes/recipes.providers.dart';
import 'package:ui/general/text.custom.dart';

class SearchWidget extends ConsumerStatefulWidget {
  const SearchWidget({Key? key}) : super(key: key);

  @override
  SearchWidgetState createState() => SearchWidgetState();
}

class SearchWidgetState extends ConsumerState<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: SearchAnchor.bar(
        isFullScreen: false,
        barLeading: FaIcon(
          FontAwesomeIcons.magnifyingGlass,
          color: Theme.of(context).colorScheme.onSurface,
          size: 15,
        ),
        viewElevation: 2.0,
        viewConstraints: BoxConstraints(maxHeight: 400.0),
        barHintText: 'Search Recipes',
        suggestionsBuilder: (context, controller) async {
          final recipesProvider = ref.read(getRecipesProvider);

          return recipesProvider.when(
            data: (result) {
              switch (result.success) {
                case true:
                  return result.payload!.where((element) => element.title!.toLowerCase().contains(controller.text.toLowerCase())).map((recipe) {
                    return ListTile(
                      leading: CircleAvatar(
                        maxRadius: 40,
                        foregroundImage: NetworkImage(recipe.image!),
                      ),
                      title: CText(
                        recipe.title!,
                      ),
                      subtitle: CText(
                        recipe.description!,
                      ),
                      // onTap: () => context.push('/recipe/${recipe.id}'),
                    );
                  }).toList();
                default:
                  debugPrint('Error: ${result.message}');
                  return [ListTile(title: CText('Error: ${result.message}'))];
              }
            },
            loading: () => [ListTile(title: CText('Loading...'))],
            error: (error, stackTrace) => [ListTile(title: CText('Error: $error'))],
          );
        },
      ),
    );
  }
}
