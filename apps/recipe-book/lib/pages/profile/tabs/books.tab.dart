import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/services/recipes.service.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:recipe_book/shared/recipe-card.shared.dart';
import 'package:ui/general/text.custom.dart';
import 'package:ui/ui.dart';

class BooksTab extends StatefulWidget {
  BooksTab({super.key});

  @override
  State<BooksTab> createState() => _BooksTabState();
}

class _BooksTabState extends State<BooksTab> {
  late List<RecipeBookModel> _books;

  final form = FormGroup({
    'name': FormControl<String>(value: '', validators: [Validators.required]),
    'description': FormControl<String>(value: ''),
    'id': FormControl<String>(),
  });

  reload() {
    setState(() {});
  }

  Future<void> _recipeBookDialogBuilder(
      {required BuildContext context, required RecipeBookModel book, int? index = null}) {
    if (index != null) {
      form.control('name').value = book.name;
      form.control('description').value = book.description;
      form.control('id').value = book.id;
    } else {
      form.reset();
    }

    return showDialog(
      context: context,
      builder: (context) {
        final width = MediaQuery.of(context).size.width;
        final theme = Theme.of(context);
        return AlertDialog(
          title: CText(
            'Add Recipe Book',
            textLevel: EText.title2,
          ),
          content: SizedBox(
            width: _largeScreen ? width * 0.25 : width,
            child: ReactiveForm(
              formGroup: form,
              child: Wrap(
                runSpacing: 20.0,
                children: [
                  CustomReactiveInput(
                    formName: 'name',
                    label: 'Recipe Book Name',
                    textColor: theme.colorScheme.onBackground,
                    inputAction: TextInputAction.next,
                  ),
                  CustomReactiveInput(
                    formName: 'description',
                    label: 'Recipe Book Description',
                    textColor: theme.colorScheme.onBackground,
                    inputAction: TextInputAction.done,
                  )
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: CText('Cancel'),
            ),
            index != null
                ? FilledButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(theme.colorScheme.error),
                    ),
                    onPressed: () => {
                      userService.deleteRecipeBook(form.control('id').value),
                      Navigator.of(context).pop(),
                      form.reset(),
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
                if (form.valid) {
                  await userService.createRecipeBook(
                    RecipeBookModel(
                      id: form.control('id').value,
                      name: form.control('name').value,
                      recipes: [],
                      createdBy: authService.user!.uid,
                      likes: 0,
                    ),
                  );
                  Navigator.of(context).pop();
                  form.reset();
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

  Future<void> _mobileRecipesSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return FutureBuilder(
          future: recipesService.getRecipesInBookFuture(
            recipeIds: _selectedIndex != null ? _books[_selectedIndex!].recipes : [],
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final recipes = snapshot.data!.docs;
              final _recipes = recipes.map((e) => e.data()).toList();
              if (_recipes.length == 0) {
                return Center(
                  child: CText(
                    'No Recipe Book Selected',
                    textLevel: EText.title2,
                  ),
                );
              }
              return ListView.builder(
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
            if (snapshot.hasError) {
              return Center(
                child: CText(
                  snapshot.error.toString(),
                  textLevel: EText.title2,
                ),
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
        _selectedIndex = null;
      }),
    );
  }

  bool _largeScreen = false;
  int? _selectedIndex = null;

  _selectIndex(int index) {
    setState(() {
      _selectedIndex = _selectedIndex == index ? null : index;
    });
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
          child: FutureBuilder(
            future: userService.myRecipeBooks(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                var items = snapshot.data!.docs;
                _books = items.map((e) => e.data()).toList();
                return ListView.builder(
                  padding: EdgeInsets.all(10.0),
                  itemCount: items.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return DottedBorder(
                        dashPattern: [6, 6],
                        borderType: BorderType.RRect,
                        color: theme.colorScheme.onSurfaceVariant,
                        child: ListTile(
                          title: CText(
                            'New Recipe Book',
                            textLevel: EText.title2,
                          ),
                          trailing: Icon(Icons.add),
                          onTap: () => _recipeBookDialogBuilder(
                            context: context,
                            book: _books[index],
                          ),
                        ),
                      );
                    }
                    index -= 1;
                    return ListTile(
                      title: CText(
                        _books[index].name!,
                        textLevel: EText.title2,
                      ),
                      selected: _selectedIndex == index,
                      onTap: () => _selectIndex(index),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _recipeBookDialogBuilder(
                          context: context,
                          book: _books[index],
                          index: index,
                        ),
                      ),
                    );
                  },
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
        Expanded(
          flex: 2,
          child: FutureBuilder(
            future: recipesService.getRecipesInBookFuture(
              recipeIds: _selectedIndex != null ? _books[_selectedIndex!].recipes : [],
            ),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final recipes = snapshot.data!.docs;
                final _recipes = recipes.map((e) => e.data()).toList();
                if (_recipes.length == 0) {
                  return Center(
                    child: CText(
                      'No Recipe Book Selected',
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
              if (snapshot.hasError) {
                return Center(
                  child: CText(
                    snapshot.error.toString(),
                    textLevel: EText.title2,
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget buildMobile(BuildContext context) {
    final theme = Theme.of(context);
    return FutureBuilder(
      future: userService.myRecipeBooks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var items = snapshot.data!.docs;
          _books = items.map((e) => e.data()).toList();
          return ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: items.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return DottedBorder(
                  dashPattern: [6, 6],
                  borderType: BorderType.RRect,
                  color: theme.colorScheme.onSurfaceVariant,
                  child: ListTile(
                    title: CText(
                      'New Recipe Book',
                      textLevel: EText.title2,
                    ),
                    trailing: Icon(Icons.add),
                    onTap: () => _recipeBookDialogBuilder(
                      context: context,
                      book: _books[index],
                    ),
                  ),
                );
              }
              index -= 1;
              return ListTile(
                title: CText(
                  _books[index].name!,
                  textLevel: EText.title2,
                ),
                selected: _selectedIndex == index,
                onTap: () {
                  _selectIndex(index);
                  _mobileRecipesSheet(context);
                },
                trailing: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _recipeBookDialogBuilder(
                    context: context,
                    book: _books[index],
                    index: index,
                  ),
                ),
              );
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
