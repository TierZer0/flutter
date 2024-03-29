import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/shared/table.shared.dart';
import 'package:ui/ui.dart';

import '../../../models/models.dart';

class InstructionsStep extends StatefulWidget {
  FormGroup formGroup;

  InstructionsStep({required this.formGroup});

  @override
  _InstructionsStepState createState() => _InstructionsStepState();
}

class _InstructionsStepState extends State<InstructionsStep> {
  List<InstructionModel> _instructions = [];

  final fields = ['Title', 'Description', 'Order'];

  @override
  void initState() {
    super.initState();

    setState(() {
      _instructions = widget.formGroup.control('instructions.steps').value;
    });
  }

  Future<void> _addInstructionDialogBuilder(BuildContext context) {
    widget.formGroup.control('instructions.title').reset();
    widget.formGroup.control('instructions.description').reset();
    return showDialog(
      context: context,
      builder: (context) {
        var theme = Theme.of(context);
        return ReactiveForm(
          formGroup: widget.formGroup,
          child: AlertDialog(
            backgroundColor: theme.colorScheme.surface,
            title: CText(
              "Add Instruction",
              textLevel: EText.subtitle,
            ),
            content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Wrap(
                spacing: 15.0,
                runSpacing: 20.0,
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
                  CustomReactiveInput(
                    formName: 'instructions.description',
                    inputAction: TextInputAction.next,
                    label: 'Description',
                    textColor: theme.colorScheme.onBackground,
                    validationMessages: {
                      ValidationMessage.required: (_) =>
                          'The Instruction description must not be empty',
                    },
                  ),
                ],
              ),
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
              ReactiveFormConsumer(
                builder: (context, formGroup, child) {
                  return FilledButton(
                    child: CText(
                      "Submit",
                      textLevel: EText.button,
                    ),
                    onPressed: formGroup.control('instructions').invalid
                        ? null
                        : () {
                            final value = formGroup.control('instructions').value;
                            setState(() {
                              _instructions.add(InstructionModel(
                                title: value['title'],
                                description: value['description'],
                                order: _instructions.length + 1,
                              ));
                              widget.formGroup
                                  .control('instructions.steps')
                                  .patchValue(_instructions);
                            });
                            Navigator.of(context).pop();
                          },
                  );
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
    return ResponsiveWidget(
      desktopScreen: buildDesktop(context),
      mobileScreen: buildMobile(context),
    );
  }

  Widget buildDesktop(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 15.0,
        vertical: 15.0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CText(
                  "Add Instruction",
                  textLevel: EText.title,
                ),
                SizedBox(height: 20.0),
                CustomReactiveInput(
                  formName: 'instructions.title',
                  inputAction: TextInputAction.next,
                  label: 'Title',
                  textColor: theme.colorScheme.onBackground,
                  validationMessages: {
                    ValidationMessage.required: (_) => 'The Instruction title must not be empty',
                  },
                ),
                SizedBox(height: 40.0),
                CustomReactiveInput(
                  formName: 'instructions.description',
                  inputAction: TextInputAction.next,
                  label: 'Description',
                  textColor: theme.colorScheme.onBackground,
                  validationMessages: {
                    ValidationMessage.required: (_) =>
                        'The Instruction description must not be empty',
                  },
                ),
                SizedBox(height: 40.0),
                ReactiveFormConsumer(
                  builder: (context, formGroup, child) {
                    return FilledButton(
                      child: CText(
                        "Submit",
                        textLevel: EText.button,
                      ),
                      onPressed: formGroup.control('instructions').invalid
                          ? null
                          : () {
                              final value = formGroup.control('instructions').value;
                              setState(() {
                                _instructions.add(InstructionModel(
                                  title: value['title'],
                                  description: value['description'],
                                  order: _instructions.length + 1,
                                ));
                                widget.formGroup
                                    .control('instructions.steps')
                                    .patchValue(_instructions);
                              });
                              widget.formGroup.control('instructions.title').reset();
                              widget.formGroup.control('instructions.description').reset();
                            },
                    );
                  },
                )
              ],
            ),
          ),
          SizedBox(width: 40.0),
          Expanded(
            flex: 2,
            child: TableShared<InstructionModel>(fields: fields, data: _instructions),
          )
        ],
      ),
    );
  }

  Widget buildMobile(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.75,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            TableShared<InstructionModel>(fields: fields, data: _instructions),
            Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton.extended(
                onPressed: () => _addInstructionDialogBuilder(context),
                elevation: 3,
                icon: Icon(
                  Icons.playlist_add,
                  size: 30,
                ),
                label: CText(
                  "Add Instruction",
                  textLevel: EText.button,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
