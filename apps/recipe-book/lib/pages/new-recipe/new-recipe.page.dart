import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/app_model.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/pages/new-recipe/steps/details.step.dart';
import 'package:recipe_book/pages/new-recipe/steps/ingredients.step.dart';
import 'package:recipe_book/pages/new-recipe/steps/instructions.step.dart';
import 'package:recipe_book/pages/new-recipe/steps/save.step.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/services/recipes.service.dart';
import 'package:ui/ui.dart';

import '../../styles.dart';

class NewPage extends StatefulWidget {
  const NewPage({super.key});

  @override
  NewPageState createState() => NewPageState();
}

class NewPageState extends State<NewPage> {
  @override
  void initState() {
    super.initState();
  }

  int _stepIndex = 0;

  FormGroup buildForm() => fb.group(
        <String, Object>{
          'details': FormGroup(
            {
              'name': FormControl<String>(validators: [Validators.required]),
              'description': FormControl<String>(),
              'category': FormControl<String>(),
              'book': FormControl<String>(),
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
          )
        },
      );

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
    final appModel = Provider.of<AppModel>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: CustomText(
          text: "Create A New Recipe",
          fontSize: 25.0,
          fontWeight: FontWeight.w500,
          color: theme.colorScheme.onBackground,
        ),
        leading: CustomIconButton(
          icon: const Icon(
            Icons.arrow_back_outlined,
            size: 30,
          ),
          onPressed: () => context.go('/'),
          color: theme.colorScheme.onBackground,
        ),
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: ReactiveFormBuilder(
          form: buildForm,
          builder: (context, formGroup, child) {
            AbstractControl<dynamic> details = formGroup.control('details');
            AbstractControl<dynamic> ingredients = formGroup.control('ingredients');
            AbstractControl<dynamic> instructions = formGroup.control('instructions');

            if (appModel.recipeBook.name != '' &&
                details.value['book'] != appModel.recipeBook.name) {
              details.patchValue({'book': appModel.recipeBook.name});
            }

            return Stepper(
              type: StepperType.horizontal,
              currentStep: _stepIndex,
              onStepCancel: () {
                if (_stepIndex > 0) {
                  setState(() {
                    _stepIndex -= 1;
                  });
                }
              },
              onStepTapped: (index) {
                if (index > _stepIndex) return;

                setState(() {
                  _stepIndex = index;
                });
              },
              onStepContinue: () {
                formGroup.markAsUntouched();
                var increase = 1;
                switch (_stepIndex) {
                  case 0:
                    if (formGroup.control('details').invalid) {
                      increase = 0;
                      formGroup.control('details').markAllAsTouched();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: tertiaryColor,
                          content: Text(
                            'Fill out the login form',
                            style: TextStyle(
                              color: darkThemeTextColor,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      );
                    }
                    break;
                  case 1:
                    if (formGroup.control('ingredients').value['items'].length <= 0) {
                      increase = 0;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: tertiaryColor,
                          content: Text(
                            'Atleast one ingredient is required',
                            style: TextStyle(
                              color: darkThemeTextColor,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      );
                    }
                    break;
                  case 2:
                    if (formGroup.control('instructions').value['steps'].length <= 0) {
                      increase = 0;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: tertiaryColor,
                          content: Text(
                            'Atleast one instruction step is required',
                            style: TextStyle(
                              color: darkThemeTextColor,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
                      );
                    }
                    recipe = RecipeModel(
                      title: details.value['name'],
                      category: details.value['category'] ?? '',
                      recipeBook: appModel.recipeBook.id!,
                      description: details.value['description'] ?? '',
                      ingredients: ingredients.value['items'],
                      instructions: instructions.value['steps'],
                      likes: 0,
                      createdBy: authService.user!.uid,
                    );
                    break;
                  case 3:
                    increase = 0;
                    recipesService.upsertRecipe(recipe);
                    appModel.recipeBook = RecipeBookModel(
                      name: '',
                      category: '',
                      recipes: [],
                      createdBy: authService.user?.uid,
                      likes: 0,
                    );
                    context.go('/');
                    break;
                }
                setState(() {
                  _stepIndex += increase;
                });
              },
              steps: [
                Step(
                  title: CustomText(
                    text: "Details",
                    fontSize: 20.0,
                    fontFamily: "Lato",
                    color: theme.colorScheme.onBackground,
                  ),
                  content: DetailsStep(),
                ),
                Step(
                  title: CustomText(
                    text: "Ingredients",
                    fontSize: 20.0,
                    fontFamily: "Lato",
                    color: theme.colorScheme.onBackground,
                  ),
                  content: IngredientsStep(formGroup),
                ),
                Step(
                  title: CustomText(
                    text: "Instructions",
                    fontSize: 20.0,
                    fontFamily: "Lato",
                    color: theme.colorScheme.onBackground,
                  ),
                  content: InstructionsStep(formGroup),
                ),
                Step(
                  title: CustomText(
                    text: "Save",
                    fontSize: 20.0,
                    fontFamily: "Lato",
                    color: theme.colorScheme.onBackground,
                  ),
                  content: Align(
                    alignment: Alignment.topLeft,
                    child: SaveStep(
                      recipe,
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
