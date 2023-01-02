import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/app_model.dart';
import 'package:recipe_book/models/models.dart';
import 'package:ui/ui.dart';

import '../styles.dart';

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

  List<String> units = ['oz', 'grams', 'lb', 'count', 'tbls', 'tsp', 'cup', 'gallon'];
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
              'items': FormControl<List<Ingredient>>(value: []),
            },
          ),
          'instructions': FormGroup(
            {
              'title': FormControl<String>(validators: [Validators.required]),
              'order': FormControl<int>(),
              'description': FormControl<String>(validators: [Validators.required]),
              'steps': FormControl<List<Instruction>>(value: []),
            },
          )
        },
      );
  Recipe recipe = Recipe('', '', '', [], [], 0);

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: CustomText(
          text: "Create A New Recipe",
          fontSize: 25.0,
          fontWeight: FontWeight.w500,
          color: (theme.textTheme.titleLarge?.color)!,
        ),
        leading: CustomIconButton(
          icon: const Icon(
            Icons.arrow_back_outlined,
            size: 30,
          ),
          onPressed: () => context.go('/'),
          color: (theme.textTheme.titleLarge?.color)!,
        ),
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: SingleChildScrollView(
          child: ReactiveFormBuilder(
            form: buildForm,
            builder: (context, formGroup, child) {
              AbstractControl<dynamic> details = formGroup.control('details');
              AbstractControl<dynamic> ingredients = formGroup.control('ingredients');
              AbstractControl<dynamic> instructions = formGroup.control('instructions');

              return Stepper(
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
                      recipe = Recipe(
                        details.value['name'],
                        '',
                        details.value['description'] ?? '',
                        ingredients.value['items'],
                        instructions.value['steps'],
                        0,
                      );
                      break;
                    case 3:
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
                      color: (theme.textTheme.titleLarge?.color)!,
                    ),
                    content: Column(
                      children: [
                        CustomReactiveInput<String>(
                          inputAction: TextInputAction.next,
                          formName: 'details.name',
                          label: 'Name',
                          textColor: (theme.textTheme.titleLarge?.color)!,
                          validationMessages: {
                            ValidationMessage.required: (_) => 'The name must not be empty',
                          },
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        CustomReactiveInput(
                          inputAction: TextInputAction.next,
                          formName: 'details.description',
                          label: 'Description',
                          textColor: (theme.textTheme.titleLarge?.color)!,
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        CustomReactiveAutocomplete(
                          formName: 'details.category',
                          optionsBuilder: (TextEditingValue value) {
                            return [];
                            // return _options.where((String option) {
                            //   return option.contains(value.text.toLowerCase());
                            // });
                          },
                          backgroundColor: theme.backgroundColor,
                          textColor: (theme.textTheme.titleLarge?.color)!,
                          label: "Category",
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        CustomReactiveAutocomplete(
                          formName: 'details.book',
                          optionsBuilder: (TextEditingValue value) {
                            return [];
                            // return _options.where((String option) {
                            //   return option.contains(value.text.toLowerCase());
                            // });
                          },
                          backgroundColor: theme.backgroundColor,
                          textColor: (theme.textTheme.titleLarge?.color)!,
                          label: "Recipe Book",
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: CustomText(
                      text: "Ingredients",
                      fontSize: 20.0,
                      fontFamily: "Lato",
                      color: (theme.textTheme.titleLarge?.color)!,
                    ),
                    content: Column(
                      children: [
                        CustomReactiveInput(
                          formName: 'ingredients.item',
                          inputAction: TextInputAction.next,
                          label: 'Ingredient',
                          textColor: (theme.textTheme.titleLarge?.color)!,
                          validationMessages: {
                            ValidationMessage.required: (_) => 'The Ingredient must not be empty',
                          },
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              height: 75.0,
                              width: MediaQuery.of(context).size.width * .45,
                              child: CustomReactiveInput(
                                formName: 'ingredients.quantity',
                                inputAction: TextInputAction.next,
                                label: 'Quanity',
                                textColor: (theme.textTheme.titleLarge?.color)!,
                                validationMessages: {
                                  ValidationMessage.required: (_) =>
                                      'The Quantity must not be empty',
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            SizedBox(
                              height: 80.0,
                              width: MediaQuery.of(context).size.width * .35,
                              child: ReactiveDropdownField(
                                decoration: InputDecoration(
                                  label: CustomText(
                                    text: "Unit",
                                    fontSize: 20.0,
                                    fontFamily: "Lato",
                                    color: (theme.textTheme.titleLarge?.color)!,
                                  ),
                                ),
                                formControlName: 'ingredients.unit',
                                dropdownColor: theme.backgroundColor,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0),
                                ),
                                elevation: 2,
                                items: units
                                    .map(
                                      (item) => DropdownMenuItem(
                                        value: item,
                                        child: CustomText(
                                          text: item,
                                          fontSize: 20.0,
                                          fontFamily: "Lato",
                                          color: (theme.textTheme.titleLarge?.color)!,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                        CustomButton(
                          buttonColor: primaryColor,
                          onTap: () {
                            formGroup.markAsUntouched();
                            AbstractControl<dynamic> group = formGroup.control('ingredients');
                            if (group.invalid) {
                              group.markAllAsTouched();
                              return;
                            }
                            List<Ingredient> items = group.value['items'] ?? [];
                            items.add(Ingredient(
                                group.value['item'], group.value['quantity'], group.value['unit']));
                            formGroup.control('ingredients').patchValue({'items': items});
                          },
                          label: "Add Ingredient",
                          externalPadding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * .5,
                              top: 10.0,
                              bottom: 10.0),
                          internalPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 15.0,
                          ),
                          textStyle: GoogleFonts.lato(
                            color: darkThemeTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(
                          height: 200.0,
                          child: ListView(
                            children: formGroup
                                .control('ingredients')
                                .value['items']
                                .map<Widget>(
                                  (Ingredient item) => CustomText(
                                    text: item.toString(),
                                    fontSize: 20.0,
                                    fontFamily: "Lato",
                                    color: (theme.textTheme.titleLarge?.color)!,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: CustomText(
                      text: "Instructions",
                      fontSize: 20.0,
                      fontFamily: "Lato",
                      color: (theme.textTheme.titleLarge?.color)!,
                    ),
                    content: Column(
                      children: [
                        CustomReactiveInput(
                          formName: 'instructions.title',
                          inputAction: TextInputAction.next,
                          label: 'Title',
                          textColor: (theme.textTheme.titleLarge?.color)!,
                          validationMessages: {
                            ValidationMessage.required: (_) =>
                                'The Instruction title must not be empty',
                          },
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        CustomReactiveInput(
                          formName: 'instructions.description',
                          inputAction: TextInputAction.next,
                          label: 'Description',
                          textColor: (theme.textTheme.titleLarge?.color)!,
                          validationMessages: {
                            ValidationMessage.required: (_) =>
                                'The Instruction description must not be empty',
                          },
                        ),
                        CustomButton(
                          buttonColor: primaryColor,
                          onTap: () {
                            formGroup.markAsUntouched();
                            AbstractControl<dynamic> group = formGroup.control('instructions');
                            if (group.invalid) {
                              group.markAllAsTouched();
                              return;
                            }
                            List<Instruction> steps = group.value['steps'] ?? [];
                            steps.add(Instruction(group.value['title'], steps.length + 1,
                                group.value['description']));
                            formGroup.control('instructions').patchValue({'steps': steps});
                          },
                          label: "Add Instruction",
                          externalPadding: EdgeInsets.only(
                              right: MediaQuery.of(context).size.width * .5,
                              top: 10.0,
                              bottom: 10.0),
                          internalPadding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                            vertical: 15.0,
                          ),
                          textStyle: GoogleFonts.lato(
                            color: darkThemeTextColor,
                            fontWeight: FontWeight.w500,
                            fontSize: 18.0,
                          ),
                        ),
                        SizedBox(
                          height: 200.0,
                          child: ListView(
                            children: formGroup
                                .control('instructions')
                                .value['steps']
                                .map<Widget>(
                                  (Instruction item) => CustomText(
                                    text: item.toString(),
                                    fontSize: 20.0,
                                    fontFamily: "Lato",
                                    color: (theme.textTheme.titleLarge?.color)!,
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: CustomText(
                      text: "Save",
                      fontSize: 20.0,
                      fontFamily: "Lato",
                      color: (theme.textTheme.titleLarge?.color)!,
                    ),
                    content: Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: recipe.toString(),
                            fontSize: 25.0,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Lato",
                            color: (theme.textTheme.titleLarge?.color)!,
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          CustomText(
                            text: 'Ingredients',
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Lato",
                            color: (theme.textTheme.titleLarge?.color)!,
                          ),
                          SizedBox(
                            height: 100.0,
                            child: ListView(
                              children: recipe.listIngredients(
                                (theme.textTheme.titleLarge?.color)!,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          CustomText(
                            text: 'Steps',
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Lato",
                            color: (theme.textTheme.titleLarge?.color)!,
                          ),
                          SizedBox(
                            height: 100.0,
                            child: ListView(
                              children: recipe.listSteps(
                                (theme.textTheme.titleLarge?.color)!,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
