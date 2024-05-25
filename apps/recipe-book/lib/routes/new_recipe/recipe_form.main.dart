import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/models.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';
import 'package:recipe_book/providers/recipes/recipes.providers.dart';
import 'package:recipe_book/routes/new_recipe/parts/general.part.dart';
import 'package:recipe_book/routes/new_recipe/parts/ingredients.part.dart';
import 'package:recipe_book/routes/new_recipe/parts/instructions.part.dart';

class RecipeFormMain extends ConsumerStatefulWidget {
  final String? id;

  RecipeFormMain({this.id});

  @override
  _RecipeFormMainState createState() => _RecipeFormMainState();
}

class _RecipeFormMainState extends ConsumerState<RecipeFormMain> {
  late String? _id;

  @override
  void initState() {
    super.initState();

    _id = widget.id;
  }

  FormGroup _formGroup = FormGroup({
    'title': FormControl<String>(validators: [Validators.required]),
    'description': FormControl<String>(validators: [Validators.required]),
    'category': FormControl<String>(validators: [Validators.required]),
    'servings': FormControl<int>(validators: [Validators.required]),
    'prepTime': FormControl<int>(validators: [Validators.required]),
    'cookTime': FormControl<int>(validators: [Validators.required]),
    'totalTime': FormControl<int>(validators: [Validators.required]),
    'imageUrl': FormControl<String>(validators: [Validators.required]),
    'ingredients': FormGroup({
      'name': FormControl<String>(validators: [Validators.required]),
      'quantity': FormControl<int>(validators: [Validators.required]),
      'unit': FormControl<String>(validators: [Validators.required]),
      'items': FormControl<List<Ingredient>>(value: [], validators: [Validators.required]),
    }),
    'instructions': FormGroup({
      'title': FormControl<String>(validators: [Validators.required]),
      'order': FormControl<int>(validators: [Validators.required]),
      'description': FormControl<String>(validators: [Validators.required]),
      'items': FormControl<List<Instruction>>(value: [], validators: [Validators.required]),
    }),
  });

  File? _photo;
  XFile? _photoWeb;
  String? _name;
  imgFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        if (pickedFile.name.indexOf('.jpg') != -1 || pickedFile.name.indexOf('.png') != -1) {
          if (kIsWeb) {
            _photoWeb = pickedFile;
          } else {
            _photo = File(pickedFile.path);
          }
          // widget.photo = _photo;
          _name = pickedFile.name;
        } else {
          _photo = null;
        }
      } else {
        print('No image selected.');
      }
    });
  }

  submit() {
    Recipe recipeModel = Recipe(
      title: _formGroup.control('title').value,
      description: _formGroup.control('description').value,
      category: _formGroup.control('category').value,
      // recipeBook: _formGroup.control('recipeBook').value,
      servings: _formGroup.control('servings').value,
      prepTime: _formGroup.control('prepTime').value,
      cookTime: _formGroup.control('cookTime').value,
      totalTime: _formGroup.control('totalTime').value,
      ingredients: _formGroup.control('ingredients').value['items'],
      instructions: _formGroup.control('instructions').value['items'],
      createdBy: ref.read(firebaseAuthProvider).currentUser!.uid,
      isPublic: true,
      isShareable: false,
      likes: 0,
      reviews: [],
    );

    if (_id == null) {
      ref.read(setRecipeProvider(CreateRecipe(recipe: recipeModel, photo: _photo)));
    } else {
      ref.read(updateRecipeProvider(recipeModel));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReactiveFormBuilder(
      form: () => _formGroup,
      builder: (context, formGroup, child) {
        Recipe? recipe = null;
        if (_id != null) {
          ref.read(getRecipeProvider(_id!)).whenData((data) {
            recipe = data.payload;
          });
          _formGroup.markAsPristine();
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(
              '${_id == null ? 'New' : 'Edit'} Recipe',
              textScaler: TextScaler.linear(1.1),
              style: TextStyle(
                fontWeight: FontWeight.w400,
              ),
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 5.0,
                    ),
                    child: FilledButton(
                      onPressed: () {
                        submit();
                        // Navigator.pop(context);
                      },
                      child: Text(
                        'Save Recipe',
                        textScaler: TextScaler.linear(
                          1.1,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  RecipeFormGeneralPart(
                    formGroup: formGroup,
                    recipe: recipe,
                    selectImage: imgFromGallery,
                    photo: _photo,
                  ),
                  RecipeFormIngredientsPart(
                    formGroup: formGroup.control('ingredients') as FormGroup,
                    recipe: recipe,
                  ),
                  RecipeFormInstructionsPart(
                    formGroup: formGroup.control('instructions') as FormGroup,
                    recipe: recipe,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
