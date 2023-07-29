import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/models/user.models.dart';
import 'package:recipe_book/services/user/recipes.service.dart';
import 'package:recipe_book/services/user/profile.service.dart';
import 'package:recipe_book/shared/recipe-card.shared.dart';
import 'package:ui/ui.dart';

class CategoriesTab extends StatefulWidget {
  UserModel user;

  CategoriesTab({super.key, required this.user});

  CategoriesTabState createState() => CategoriesTabState();
}

class CategoriesTabState extends State<CategoriesTab> {
  final formGroup = FormGroup({
    'name': FormControl<String>(validators: [Validators.required]),
    'prevName': FormControl<String>(value: ''),
  });

  reload() {
    setState(() {});
  }

  int? _selectedCategory = null;
  _selectCategory(int index) {
    setState(() {
      _selectedCategory = _selectedCategory == index ? null : index;
    });
  }

  bool _largeScreen = false;

  Future<void> _categoryDialogBuilder({
    required BuildContext context,
    required UserModel user,
    int? index = null,
  }) {
    if (index != null) {
      formGroup.control('name').value = user.categories![index];
      formGroup.control('prevName').value = user.categories![index];
    } else {
      formGroup.reset();
    }

    return showDialog(
      context: context,
      builder: (context) {
        final width = MediaQuery.of(context).size.width;
        final theme = Theme.of(context);
        return AlertDialog(
          title: CText(
            'Add Category',
            textLevel: EText.title2,
          ),
          content: SizedBox(
            width: _largeScreen ? width * .25 : width,
            child: ReactiveForm(
              formGroup: formGroup,
              child: Wrap(
                children: [
                  CustomReactiveInput(
                    formName: 'name',
                    label: 'Category',
                    textColor: theme.colorScheme.onBackground,
                    inputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: CText(
                'Cancel',
                textLevel: EText.button,
              ),
            ),
            index != null
                ? FilledButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(theme.colorScheme.error),
                    ),
                    onPressed: () => {
                      profileService.deleteCategory(
                        formGroup.control('name').value,
                      ),
                      Navigator.of(context).pop(),
                      formGroup.reset(),
                      reload(),
                    },
                    child: CText(
                      'Delete',
                      theme: theme,
                      textLevel: EText.dangerbutton,
                    ),
                  )
                : SizedBox.shrink(),
            FilledButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(theme.colorScheme.secondary),
              ),
              onPressed: () async {
                if (formGroup.valid) {
                  await profileService.upsertCategory(
                    category: formGroup.control('name').value,
                    oldCategory: formGroup.control('prevName').value,
                  );
                  Navigator.of(context).pop();
                  formGroup.reset();
                  reload();
                }
              },
              child: CText(
                'Add',
                textLevel: EText.button,
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _mobileRecipesSheet(BuildContext context, String category) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return FutureBuilder(
          future: recipesService.myRecipesFuture(filters: {
            'category': category,
          }),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final recipes = snapshot.data!.docs;
              final _recipes = snapshot.data!.docs.map((e) => e.data()).toList();
              if (_recipes.length == 0) {
                return Center(
                  child: CText(
                    'No recipes found with this category',
                    textLevel: EText.title2,
                  ),
                );
              }
              return ListView.builder(
                padding: EdgeInsets.symmetric(
                  vertical: 20.0,
                ),
                itemCount: _recipes.length,
                itemBuilder: (context, index) {
                  final RecipeModel recipe = _recipes[index];
                  final String recipeId = recipes[index].id;
                  return ListTile(
                    style: ListTileStyle.drawer,
                    title: CText(
                      recipe.title!,
                      textLevel: EText.title,
                    ),
                    subtitle: CText(
                      recipe.description!,
                      textLevel: EText.caption,
                    ),
                    leading: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(
                            30.0,
                          ),
                        ),
                      ),
                      child: Image.network(
                        recipe.image!,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                    onTap: () => context.push('/recipe/${recipeId}'),
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      },
    ).then(
      (value) => setState(() {
        _selectedCategory = null;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 660) {
        _largeScreen = true;
        return buildDesktop(context);
      } else {
        _largeScreen = false;
        return buildMobile(context);
      }
    });
  }

  Widget buildDesktop(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: widget.user.categories!.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return DottedBorder(
                  dashPattern: [6, 6],
                  borderType: BorderType.RRect,
                  color: theme.colorScheme.onSurfaceVariant,
                  child: ListTile(
                    title: CText(
                      'New Category',
                      textLevel: EText.title2,
                    ),
                    trailing: Icon(Icons.add),
                    onTap: () => _categoryDialogBuilder(
                      context: context,
                      user: widget.user,
                    ),
                  ),
                );
              }
              index -= 1;
              return ListTile(
                title: CText(
                  widget.user.categories![index],
                  textLevel: EText.body,
                ),
                onTap: () => _selectCategory(index),
                selected: _selectedCategory == index,
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _categoryDialogBuilder(
                    context: context,
                    user: widget.user,
                    index: index,
                  ),
                ),
              );
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: _selectedCategory != null
              ? FutureBuilder(
                  future: recipesService.myRecipesFuture(filters: {
                    'category': widget.user.categories![_selectedCategory!],
                  }),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final recipes = snapshot.data!.docs;
                      final _recipes = snapshot.data!.docs.map((e) => e.data()).toList();
                      if (_recipes.length == 0) {
                        return Center(
                          child: CText(
                            'No recipes found with this category',
                            textLevel: EText.title2,
                          ),
                        );
                      }
                      return GridView.builder(
                        itemCount: _recipes.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          childAspectRatio: 3 / 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                        ),
                        itemBuilder: (context, index) {
                          final RecipeModel recipe = _recipes[index];
                          final String recipeId = recipes[index].id;
                          return RecipeCard(
                            recipe: recipe,
                            cardType: ECard.elevated,
                            onTap: () => context.push('/recipe/${recipeId}'),
                            useImage: true,
                          );
                        },
                      );
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                )
              : Center(
                  child: CText(
                    'Select a category to view recipes',
                    textLevel: EText.title2,
                  ),
                ),
        )
      ],
    );
  }

  Widget buildMobile(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      padding: EdgeInsets.all(10.0),
      itemCount: widget.user.categories!.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return DottedBorder(
            dashPattern: [6, 6],
            borderType: BorderType.RRect,
            color: theme.colorScheme.onSurfaceVariant,
            child: ListTile(
              title: CText(
                'New Category',
                textLevel: EText.title2,
              ),
              trailing: Icon(Icons.add),
              onTap: () => _categoryDialogBuilder(
                context: context,
                user: widget.user,
              ),
            ),
          );
        }
        index -= 1;
        return ListTile(
          title: CText(
            widget.user.categories![index],
            textLevel: EText.body,
          ),
          onTap: () {
            _selectCategory(index);
            _mobileRecipesSheet(context, widget.user.categories![index]);
          },
          selected: _selectedCategory == index,
          trailing: IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _categoryDialogBuilder(
              context: context,
              user: widget.user,
              index: index,
            ),
          ),
        );
      },
    );
  }
}
