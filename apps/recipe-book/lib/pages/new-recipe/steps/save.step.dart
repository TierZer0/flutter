import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:ui/ui.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SaveStep extends StatefulWidget {
  FormGroup formGroup;
  final RecipeModel recipe;
  VoidCallback tapBack;
  Function tapForward;

  SaveStep({
    super.key,
    required this.recipe,
    required this.tapBack,
    required this.tapForward,
    required this.formGroup,
  });

  @override
  SaveStepState createState() => SaveStepState();
}

class SaveStepState extends State<SaveStep> {
  @override
  void initState() {
    super.initState();
  }

  File? _photo;

  imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        if (pickedFile.name.indexOf('.jpg') != -1 || pickedFile.name.indexOf('.png') != -1) {
          _photo = File(pickedFile.path);
          widget.recipe.image = pickedFile.name;
        } else {
          _photo = null;
        }
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SizedBox(
      height: height,
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                child: ReactiveForm(
                  formGroup: widget.formGroup,
                  child: Wrap(
                    spacing: 20.0,
                    runSpacing: 20.0,
                    children: [
                      CustomText(
                        text: "Recipe Settings",
                        fontSize: 30.0,
                        fontFamily: "Lato",
                        color: theme.colorScheme.onBackground,
                      ),
                      SizedBox(
                        width: width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Public - Viewable by anyone",
                              fontSize: 20.0,
                              fontFamily: "Lato",
                              color: theme.colorScheme.onBackground,
                            ),
                            ReactiveSwitch(
                              formControlName: 'settings.isPublic',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomText(
                              text: "Shareable - Can be saved to other recipe books",
                              fontSize: 20.0,
                              fontFamily: "Lato",
                              color: theme.colorScheme.onBackground,
                            ),
                            ReactiveSwitch(
                              formControlName: 'settings.isShareable',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: width,
                        height: 250,
                        child: DottedBorder(
                          dashPattern: [6, 6],
                          borderType: BorderType.RRect,
                          color: theme.colorScheme.onSurfaceVariant,
                          strokeWidth: 1.5,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                imgFromGallery();
                              },
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.topCenter,
                                    child: SizedBox(
                                      height: 200,
                                      // width: width,
                                      child: _photo?.path != null
                                          ? Image.file(_photo!)
                                          : SizedBox.shrink(),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: CustomText(
                                      text: "Add a photo",
                                      fontSize: 20.0,
                                      fontFamily: "Lato",
                                      color: theme.colorScheme.onBackground,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            ReactiveFormConsumer(
              builder: (context, form, child) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: Wrap(
                    spacing: 30.0,
                    children: [
                      ElevatedButton(
                        onPressed: widget.tapBack,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                          child: CustomText(
                            text: "Edit Recipe",
                            fontSize: 20.0,
                            fontFamily: "Lato",
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () => widget.tapForward(_photo),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                          child: CustomText(
                            text: "Save Recipe",
                            fontSize: 20.0,
                            fontFamily: "Lato",
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
