import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/recipes.service.dart';
import 'package:ui/ui.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SaveStep extends StatefulWidget {
  final RecipeModel recipe;

  SaveStep({super.key, required this.recipe});

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
        _photo = File(pickedFile.path);
        recipesService.uploadFile(_photo!);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: widget.recipe.toString(),
          fontSize: 25.0,
          fontWeight: FontWeight.w700,
          fontFamily: "Lato",
          color: theme.colorScheme.onBackground,
        ),
        const SizedBox(
          height: 25.0,
        ),
        CustomText(
          text: 'Ingredients',
          fontSize: 20.0,
          fontWeight: FontWeight.w700,
          fontFamily: "Lato",
          color: theme.colorScheme.onBackground,
        ),
        SizedBox(
          height: 100.0,
          child: ListView(
            children: widget.recipe.listIngredients(
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
          color: theme.colorScheme.onBackground,
        ),
        SizedBox(
          height: 100.0,
          child: ListView(
            children: widget.recipe.listSteps(
              (theme.textTheme.titleLarge?.color)!,
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            imgFromGallery();
          },
          child: Text('Select Image'),
        ),
      ],
    );
  }
}
