import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/styles.dart';
import 'package:ui/ui.dart';

class InstructionsStep extends StatelessWidget {
  FormGroup formGroup;

  InstructionsStep(this.formGroup);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        CustomReactiveInput(
          formName: 'instructions.title',
          inputAction: TextInputAction.next,
          label: 'Title',
          textColor: theme.colorScheme.onBackground,
          validationMessages: {
            ValidationMessage.required: (_) => 'The Instruction title must not be empty',
          },
        ),
        const SizedBox(
          height: 25.0,
        ),
        CustomReactiveInput(
          formName: 'instructions.description',
          inputAction: TextInputAction.next,
          label: 'Description',
          textColor: theme.colorScheme.onBackground,
          validationMessages: {
            ValidationMessage.required: (_) => 'The Instruction description must not be empty',
          },
        ),
        SizedBox(
          height: 15.0,
        ),
        ReactiveFormConsumer(
          builder: (context, form, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: form.control('instructions').invalid
                      ? null
                      : () {
                          form.markAsUntouched();
                          AbstractControl<dynamic> group = form.control('instructions');
                          if (group.invalid) {
                            group.markAllAsTouched();
                            return;
                          }
                          List<InstructionModel> steps = group.value['steps'] ?? [];

                          steps.add(
                            InstructionModel(
                              title: group.value['title'],
                              order: steps.length + 1,
                              description: group.value['description'],
                            ),
                          );
                          group.patchValue({'title': null, 'order': null, 'description': null});
                          form.control('instructions').patchValue({'steps': steps});
                        },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                    child: CustomText(
                      text: "Add Instruction",
                      fontSize: 20.0,
                      fontFamily: "Lato",
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                ),
                SizedBox(
                  height: 25.0,
                ),
                SizedBox(
                  height: 200.0,
                  child: ListView(
                    children: form
                        .control('instructions')
                        .value['steps']
                        .map<Widget>(
                          (InstructionModel item) => CustomText(
                            text: item.toString(),
                            fontSize: 20.0,
                            fontFamily: "Lato",
                            color: theme.colorScheme.onBackground,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
