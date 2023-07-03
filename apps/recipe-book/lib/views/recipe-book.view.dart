import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/recipes.service.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:recipe_book/shared/detailed-recipe-card.shared.dart';
import 'package:recipe_book/shared/recipe-card.shared.dart';
import 'package:ui/ui.dart';

class RecipeBookPage extends StatefulWidget {
  final String recipeBookId;

  const RecipeBookPage({
    super.key,
    required this.recipeBookId,
  });

  @override
  State<RecipeBookPage> createState() => _RecipeBookPageState();
}

class _RecipeBookPageState extends State<RecipeBookPage> {
  RecipeBookModel recipeBook = RecipeBookModel();

  final PageController recipeCtrl = PageController(viewportFraction: 0.85);
  int currentItem = 0;

  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    getRecipeBook();
  }

  getRecipeBook() {
    userService.getRecipeBook(widget.recipeBookId).then((result) {
      setState(() {
        recipeBook = result;
      });
    });
  }

  Future<void> _addRecipeDialogBuilder(BuildContext context, RecipeBookModel recipeBook) {
    FormGroup formGroup = FormGroup({
      'recipe': FormControl<String>(validators: [Validators.required]),
    });

    return showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return ReactiveForm(
          formGroup: formGroup,
          child: AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            title: CText(
              'Add Recipe to Book',
              textLevel: EText.title2,
            ),
            content: FutureBuilder(
              future: recipesService.getMyRecipesFuture(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!.docs;
                  var recipes = data.map((e) => e.data()).toList();
                  return ReactiveDropdownField(
                    hint: Text('Select Recipe'),
                    items: List<DropdownMenuItem>.generate(recipes.length, (index) {
                      final RecipeModel item = recipes[index];
                      final id = data[index].id;
                      return DropdownMenuItem(
                        value: id,
                        child: Text(
                          item.title!,
                        ),
                      );
                    }),
                    formControlName: 'recipe',
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
            actions: [
              TextButton(
                child: CText(
                  "Cancel",
                  textLevel: EText.button,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: CText(
                  "Submit",
                  textLevel: EText.button,
                ),
                onPressed: () {
                  setState(() {
                    recipeBook.recipes!.add(formGroup.control('recipe').value);
                    // userService.updateRecipeBook(widget.recipeBookId, recipeBook);
                    userService.addRecipeToRecipeBook(
                        formGroup.control('recipe').value, widget.recipeBookId);
                  });

                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CText(
              recipeBook.name ?? '',
              textLevel: EText.title,
            ),
          ],
        ),
        elevation: 5,
        toolbarHeight: 100,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () => {
                setState(() {
                  isEditing = !isEditing;
                })
              },
              icon: Icon(
                isEditing ? Icons.check : Icons.edit,
              ),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: recipesService.getRecipesInBook(recipeBook.recipes ?? []),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var recipes = snapshot.data!.docs;
            List<dynamic> _recipes = recipes.map((e) => e.data()).toList();

            if (isEditing) {
              return ListView.builder(
                itemCount: _recipes.length + 1,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    // _recipes.add(null);
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 5.0,
                      ),
                      child: DottedBorder(
                        dashPattern: [6, 6],
                        borderType: BorderType.RRect,
                        color: theme.colorScheme.onSurfaceVariant,
                        strokeWidth: 1.5,
                        child: ListTile(
                          title: CText(
                            'Add Recipe',
                            textLevel: EText.title2,
                          ),
                          trailing: IconButton(
                            onPressed: () => _addRecipeDialogBuilder(context, recipeBook),
                            icon: Icon(
                              Icons.add,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  index -= 1;
                  final RecipeModel recipe = _recipes[index]!;
                  final String recipeId = recipes[index].id;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                    ),
                    child: ListTile(
                      isThreeLine: true,
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(recipe.image!),
                      ),
                      title: CText(
                        recipe.title!,
                        textLevel: EText.title,
                      ),
                      subtitle: CText(
                        recipe.description! + '\n' + recipe.category!,
                        textLevel: EText.subtitle,
                      ),
                      tileColor: theme.colorScheme.surfaceVariant.withOpacity(0.2),
                      trailing: IconButton(
                        onPressed: () => {
                          setState(() {
                            recipeBook.recipes!.remove(recipeId);
                            userService.updateRecipeBook(widget.recipeBookId, recipeBook);
                          })
                        },
                        icon: Icon(
                          Icons.delete,
                          color: theme.colorScheme.error,
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return PageView.builder(
                itemCount: _recipes.length,
                onPageChanged: (next) {
                  if (currentItem != next) {
                    setState(() {
                      currentItem = next;
                    });
                  }
                },
                controller: recipeCtrl,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int currentIndex) {
                  bool active = currentIndex == currentItem;
                  return Center(
                    child: AnimatedContainer(
                      height: MediaQuery.of(context).size.height * (active ? 0.8 : 0.6),
                      color: Colors.transparent,
                      duration: Duration(milliseconds: 300),
                      child: DetailedRecipeCard(
                        elevation: active ? 5 : 1,
                        cardType: ECard.elevated,
                        recipe: _recipes[currentIndex],
                        onTap: () => context.push('/recipe/${recipes[currentIndex].id}'),
                      ),
                    ),
                  );
                },
              );
            }
          } else if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
                  child: DottedBorder(
                    dashPattern: [6, 6],
                    borderType: BorderType.RRect,
                    color: theme.colorScheme.onSurfaceVariant,
                    strokeWidth: 1.5,
                    child: ListTile(
                      title: CText(
                        'Add Recipe',
                        textLevel: EText.title,
                      ),
                      trailing: IconButton(
                        onPressed: () => _addRecipeDialogBuilder(context, recipeBook),
                        icon: Icon(
                          Icons.add,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
                CText(
                  'No Recipes in this book',
                  textLevel: EText.title2,
                ),
              ],
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
