import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/recipe/instruction.model.dart';
import 'package:recipe_book/models/recipe/recipe.model.dart';

class RecipeFormInstructionsPart extends StatefulWidget {
  final RecipeModel? recipe;
  final FormGroup formGroup;

  RecipeFormInstructionsPart({this.recipe, required this.formGroup});

  @override
  _RecipeFormInstructionsPartState createState() => _RecipeFormInstructionsPartState();
}

class _RecipeFormInstructionsPartState extends State<RecipeFormInstructionsPart> {
  late RecipeModel? _recipe;
  late FormGroup _formGroup;

  @override
  void initState() {
    super.initState();

    _recipe = widget.recipe;
    _formGroup = widget.formGroup;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        child: Wrap(
          spacing: 38,
          runSpacing: 25,
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              child: Text(
                'Instructions',
                textScaler: TextScaler.linear(
                  1.3,
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: .6,
              child: ReactiveTextField(
                formControlName: 'instructions.title',
                decoration: InputDecoration(
                  labelText: 'Title',
                  filled: true,
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: .3,
              child: ReactiveTextField(
                formControlName: 'instructions.order',
                decoration: InputDecoration(
                  labelText: 'Order',
                  filled: true,
                ),
                keyboardType: TextInputType.number,
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: ReactiveTextField(
                formControlName: 'instructions.description',
                decoration: InputDecoration(
                  labelText: 'Description',
                  filled: true,
                ),
              ),
            ),
            ReactiveFormConsumer(
              builder: (context, form, child) {
                final FormGroup _form = form.control('instructions') as FormGroup;

                _form.control('order').value = _form.control('items').value.length + 1;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FilledButton(
                      onPressed: () {
                        if (_form.valid) {
                          _form.control('items').value.add(
                                InstructionModel(
                                  title: _form.control('title').value,
                                  order: _form.control('order').value,
                                  description: _form.control('description').value,
                                ),
                              );

                          _form.control('title').reset();
                          _form.control('order').reset();
                          _form.control('description').reset();
                        } else {
                          _form.markAllAsTouched();
                        }
                      },
                      child: Text('Add Instruction'),
                    ),
                    SizedBox(
                      height: 250,
                      child: ListView.builder(
                        itemCount: _form.control('items').value.length,
                        itemBuilder: (context, index) {
                          final InstructionModel instruction = _form.control('items').value[index] as InstructionModel;

                          return ListTile(
                            title: Text(instruction.title!),
                            subtitle: Text(instruction.description!),
                            trailing: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                setState(() {
                                  _form.control('items').value.removeAt(index);
                                });
                              },
                            ),
                          );
                        },
                      ),
                    )
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
