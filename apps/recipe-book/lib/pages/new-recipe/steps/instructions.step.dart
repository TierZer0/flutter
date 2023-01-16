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
          textColor: (theme.textTheme.titleLarge?.color)!,
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
          textColor: (theme.textTheme.titleLarge?.color)!,
          validationMessages: {
            ValidationMessage.required: (_) => 'The Instruction description must not be empty',
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
            steps.add(
                Instruction(group.value['title'], steps.length + 1, group.value['description']));
            formGroup.control('instructions').patchValue({'steps': steps});
          },
          label: "Add Instruction",
          externalPadding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * .5, top: 10.0, bottom: 10.0),
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
    );
  }
}
