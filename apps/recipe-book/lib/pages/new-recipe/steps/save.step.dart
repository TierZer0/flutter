import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:ui/ui.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SaveStep extends StatefulWidget {
  final RecipeModel recipe;
  VoidCallback tapBack;
  Function tapForward;

  SaveStep({super.key, required this.recipe, required this.tapBack, required this.tapForward});

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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 25.0,
      ),
      child: Column(
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
          _photo?.path != null
              ? SizedBox(height: 200, child: Image.file(_photo!))
              : SizedBox.shrink(),
          ElevatedButton(
            onPressed: () {
              imgFromGallery();
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: CustomText(
                text: "Select Image",
                fontSize: 15.0,
                fontFamily: "Lato",
                color: theme.colorScheme.onBackground,
              ),
            ),
          ),
          const SizedBox(
            height: 25.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: widget.tapBack,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
                  child: CustomText(
                    text: "Prior Step",
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
          )
        ],
      ),
    );
  }
}
