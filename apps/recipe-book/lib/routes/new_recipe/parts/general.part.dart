import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/models.dart';

class RecipeFormGeneralPart extends StatefulWidget {
  final RecipeModel? recipe;
  final FormGroup formGroup;
  final VoidCallback selectImage;
  final dynamic photo;

  RecipeFormGeneralPart({this.recipe, required this.formGroup, required this.selectImage, this.photo});

  @override
  _RecipeFormGeneralPartState createState() => _RecipeFormGeneralPartState();
}

class _RecipeFormGeneralPartState extends State<RecipeFormGeneralPart> {
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
            Text(
              'Recipe Details',
              textScaler: TextScaler.linear(
                1.3,
              ),
            ),
            ReactiveTextField(
              formControlName: 'title',
              decoration: InputDecoration(
                labelText: 'Title',
                filled: true,
              ),
            ),
            ReactiveTextField(
              formControlName: 'description',
              decoration: InputDecoration(
                labelText: 'Description',
                filled: true,
              ),
            ),
            ReactiveDropdownField(
              formControlName: 'category',
              items: [],
              decoration: InputDecoration(
                labelText: 'Category',
                filled: true,
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.45,
              child: ReactiveTextField(
                formControlName: 'servings',
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Servings',
                  filled: true,
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.45,
              child: ReactiveTextField(
                formControlName: 'prepTime',
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Prep Time (mins)',
                  filled: true,
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.45,
              child: ReactiveTextField(
                formControlName: 'cookTime',
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Cook Time (mins)',
                  filled: true,
                ),
              ),
            ),
            FractionallySizedBox(
              widthFactor: 0.45,
              child: ReactiveTextField(
                formControlName: 'totalTime',
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Total Time (mins)',
                  filled: true,
                ),
              ),
            ),
            DottedBorder(
              dashPattern: [6, 6],
              borderType: BorderType.RRect,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              strokeWidth: 1.5,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    widget.selectImage();
                    // imgFromGallery();
                  },
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          height: 200,
                          child: widget.photo?.path != null
                              ? kIsWeb
                                  ? Image.network(widget.photo!.path)
                                  : Image.file(widget.photo!)
                              : SizedBox.shrink(),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          "Add a photo",
                          textScaler: TextScaler.linear(1.2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Gap(10),
          ],
        ),
      ),
    );
  }
}
