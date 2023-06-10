import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/app_model.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/views/new-recipe/steps/details.step.dart';
import 'package:recipe_book/views/new-recipe/steps/ingredients.step.dart';
import 'package:recipe_book/views/new-recipe/steps/instructions.step.dart';
import 'package:recipe_book/views/new-recipe/steps/save.step.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/services/recipes.service.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:ui/ui.dart';

class NewPage extends StatefulWidget {
  final String? id;

  const NewPage({super.key, this.id});

  @override
  NewPageState createState() => NewPageState();
}

class NewPageState extends State<NewPage> with TickerProviderStateMixin {
  late TabController _tabController;
  bool loading = false;
  @override
  void initState() {
    super.initState();

    if (widget.id != null) {
      loading = true;
      getRecipe();
    }
    _tabController = TabController(length: 4, vsync: this);
  }

  getRecipe() {
    recipesService.getRecipe(widget.id!).then((recipe) {
      userService.getRecipeBook(recipe.recipeBook!).then((book) {
        _formGroup.patchValue({
          'details': {
            'name': recipe.title,
            'description': recipe.description,
            'category': recipe.category,
          }
        });
        setState(() {
          context.read<AppModel>().recipeBook = book;
          loading = false;
        });
      });
    });
  }

  late FormGroup _formGroup;
  FormGroup buildForm() => fb.group(
        <String, Object>{
          'details': FormGroup(
            {
              'name': FormControl<String>(validators: [Validators.required]),
              'description': FormControl<String>(validators: [Validators.required]),
              'category': FormControl<String>(),
              'book': FormControl<String>(),
              'cookTime': FormControl<int>(validators: [Validators.required]),
              'prepTime': FormControl<int>(validators: [Validators.required]),
              'servings': FormControl<int>(validators: [Validators.required]),
            },
          ),
          'ingredients': FormGroup(
            {
              'item': FormControl<String>(validators: [Validators.required]),
              'quantity': FormControl<String>(validators: [Validators.required]),
              'unit': FormControl<String>(validators: [Validators.required]),
              'items': FormControl<List<IngredientModel>>(value: []),
            },
          ),
          'instructions': FormGroup(
            {
              'title': FormControl<String>(validators: [Validators.required]),
              'order': FormControl<int>(),
              'description': FormControl<String>(),
              'steps': FormControl<List<InstructionModel>>(value: []),
            },
          ),
          'settings': FormGroup({
            'isPublic': FormControl<bool>(value: true),
            'isShareable': FormControl<bool>(value: false),
          }),
        },
      );

  List<bool> completedSteps = [false, false, false, false];

  RecipeModel recipe = RecipeModel(
    title: '',
    category: '',
    recipeBook: '',
    description: '',
    instructions: [],
    ingredients: [],
    likes: 0,
    createdBy: authService.user!.uid,
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // _tabController.index = 2;

    return ReactiveFormBuilder(
      form: buildForm,
      builder: (context, formGroup, child) {
        AbstractControl<dynamic> details = formGroup.control('details') as FormGroup;
        AbstractControl<dynamic> ingredients = formGroup.control('ingredients') as FormGroup;
        AbstractControl<dynamic> instructions = formGroup.control('instructions') as FormGroup;
        AbstractControl<dynamic> settings = formGroup.control('settings') as FormGroup;
        _formGroup = formGroup;

        onTap(curr, goTo) {
          final steps = ['details', 'ingredients', 'instructions'];

          return () {
            if (curr == 2) {}

            var update = false;
            switch (curr) {
              case 0:
                if (details.valid) {
                  update = true;
                }
                break;
              case 1:
                if (ingredients.value['items'].length > 0) {
                  update = true;
                }
                break;
              case 2:
                if (instructions.value['steps'].length > 0) {
                  update = true;
                }
                break;
            }
            setState(() {
              completedSteps[curr] = update;
            });

            return _tabController.animateTo(goTo);
          };
        }

        submit(File photo, String imageName) {
          recipe = RecipeModel(
            title: details.value['name'],
            category: details.value['category'] ?? '',
            recipeBook: details.value['book'] ?? '',
            description: details.value['description'] ?? '',
            ingredients: ingredients.value['items'],
            instructions: instructions.value['steps'],
            likes: 0,
            createdBy: authService.user!.uid,
            isPublic: settings.value['isPublic'],
            isShareable: settings.value['isShareable'],
            prepTime: details.value['prepTime'],
            cookTime: details.value['cookTime'],
            servings: details.value['servings'],
          );
          recipesService.upsertRecipe(recipe, photo);
          context.read<AppModel>().recipeBook = RecipeBookModel(
            name: '',
            category: '',
            recipes: [],
            createdBy: authService.user?.uid,
            likes: 0,
          );
          context.go('/');
        }

        if (context.read<AppModel>().recipeBook.name != '' &&
            details.value['book'] != context.read<AppModel>().recipeBook.name) {
          details.patchValue({'book': context.read<AppModel>().recipeBook.name});
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.colorScheme.surface,
            elevation: 10,
            title: CText(
              widget.id == null ? "Create A New Recipe" : "Edit Recipe",
              textLevel: EText.title,
              weight: FontWeight.bold,
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(85.0),
              child: IgnorePointer(
                child: TabBar(
                  indicatorColor: theme.colorScheme.primary,
                  controller: _tabController,
                  physics: NeverScrollableScrollPhysics(),
                  tabs: [
                    Tab(
                      text: '1: Details',
                      icon: completedSteps[0]
                          ? Icon(Icons.check_outlined)
                          : Icon(Icons.edit_outlined),
                    ),
                    Tab(
                      text: '2: Ingredients',
                      icon: completedSteps[1]
                          ? Icon(Icons.check_outlined)
                          : Icon(Icons.edit_outlined),
                    ),
                    Tab(
                      text: '3: Instructions',
                      icon: completedSteps[2]
                          ? Icon(Icons.check_outlined)
                          : Icon(Icons.edit_outlined),
                    ),
                    Tab(
                      text: '4: Save',
                      icon: completedSteps[0] && completedSteps[1] && completedSteps[2]
                          ? Icon(Icons.check_outlined)
                          : Icon(Icons.edit_outlined),
                    )
                  ],
                ),
              ),
            ),
          ),
          body: loading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Container(
                  color: theme.scaffoldBackgroundColor,
                  child: TabBarView(
                    controller: _tabController,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      DetailsStep(
                        onTap: onTap(0, 1),
                      ),
                      IngredientsStep(
                        formGroup: formGroup,
                        tapBack: onTap(1, 0),
                        tapForward: onTap(1, 2),
                      ),
                      InstructionsStep(
                        formGroup: formGroup,
                        tapBack: onTap(2, 1),
                        tapForward: onTap(2, 3),
                      ),
                      SaveStep(
                        formGroup: formGroup,
                        recipe: recipe,
                        tapBack: onTap(3, 2),
                        tapForward: (photo, name) {
                          submit(photo!, name!);
                        },
                      )
                    ],
                  ),
                ),
        );
      },
    );
  }
}
