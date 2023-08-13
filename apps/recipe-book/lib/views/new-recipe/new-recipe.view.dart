import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/app_model.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/user/authentication.service.dart';
import 'package:recipe_book/services/user/recipe-books.service.dart';
import 'package:recipe_book/views/new-recipe/steps/details.step.dart';
import 'package:recipe_book/views/new-recipe/steps/ingredients.step.dart';
import 'package:recipe_book/views/new-recipe/steps/instructions.step.dart';
import 'package:recipe_book/views/new-recipe/steps/save.step.dart';
import 'package:recipe_book/services/user/recipes.service.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ui/ui.dart';

class NewPage extends StatefulWidget {
  final String? id;

  const NewPage({super.key, this.id});

  @override
  NewPageState createState() => NewPageState();
}

class NewPageState extends State<NewPage> {
  bool loading = false;
  String userUid = authenticationService.userUid;

  @override
  void initState() {
    super.initState();

    if (widget.id != null) {
      loading = true;
      getRecipe();
    }
  }

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

  getRecipe() {
    recipesService.getRecipe(widget.id!).then((recipe) {
      print(recipe.recipeBook);
      recipeBookService.getRecipeBook(recipe.recipeBook!).then((book) {
        _formGroup.patchValue({
          'details': {
            'name': recipe.title,
            'description': recipe.description,
            'category': recipe.category,
            'book': recipe.recipeBook!,
            'cookTime': recipe.cookTime,
            'prepTime': recipe.prepTime,
            'servings': recipe.servings,
          },
          'ingredients': {
            'items': recipe.ingredients,
          },
          'instructions': {
            'steps': recipe.instructions,
          },
          'settings': {
            'isPublic': recipe.isPublic ?? false,
            'isShareable': recipe.isShareable ?? false,
          },
        });
        setState(() {
          context.read<AppModel>().recipeBook = book;
          loading = false;
        });
      });
    });
  }

  late FormGroup _formGroup;
  FormGroup buildForm() => fb.group(
        <String, Object>{
          'details': FormGroup(
            {
              'name': FormControl<String>(validators: [Validators.required]),
              'description': FormControl<String>(validators: [Validators.required]),
              'category': FormControl<String>(),
              'book': FormControl<String>(),
              'cookTime': FormControl<int>(validators: [Validators.required]),
              'prepTime': FormControl<int>(validators: [Validators.required]),
              'servings': FormControl<int>(validators: [Validators.required]),
            },
          ),
          'ingredients': FormGroup(
            {
              'item': FormControl<String>(validators: [Validators.required]),
              'quantity': FormControl<String>(validators: [Validators.required]),
              'unit': FormControl<String>(validators: [Validators.required]),
              'items': FormControl<List<IngredientModel>>(value: []),
            },
          ),
          'instructions': FormGroup(
            {
              'title': FormControl<String>(validators: [Validators.required]),
              'order': FormControl<int>(),
              'description': FormControl<String>(value: ''),
              'steps': FormControl<List<InstructionModel>>(value: []),
            },
          ),
          'settings': FormGroup({
            'isPublic': FormControl<bool>(value: true),
            'isShareable': FormControl<bool>(value: false),
          }),
        },
      );

  List<bool> completedSteps = [false, false, false, false];

  RecipeModel recipe = RecipeModel(
    title: '',
    category: '',
    recipeBook: '',
    description: '',
    instructions: [],
    ingredients: [],
    likes: 0,
    createdBy: authenticationService.userUid,
  );

  _handleDelete(BuildContext context) {
    recipesService.deleteRecipe(widget.id!, recipe).then((value) {
      context.pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // _tabController.index = 2;

    return LayoutBuilder(builder: (context, constraints) {
      return ResponsiveWidget(
        desktopScreen: buildDesktop(context),
        mobileScreen: buildMobile(context),
      );
    });
  }

  int _currentStep = 0;
  Widget buildDesktop(BuildContext context) {
    return ReactiveFormBuilder(
      form: buildForm,
      builder: (context, formGroup, child) {
        AbstractControl<dynamic> details = formGroup.control('details') as FormGroup;
        AbstractControl<dynamic> ingredients = formGroup.control('ingredients') as FormGroup;
        AbstractControl<dynamic> instructions = formGroup.control('instructions') as FormGroup;
        AbstractControl<dynamic> settings = formGroup.control('settings') as FormGroup;
        return Scaffold(
          appBar: AppBar(
            title: CText(
              widget.id == null ? "Create A New Recipe" : "Edit Recipe",
              textLevel: EText.title,
            ),
          ),
          body: Stepper(
            currentStep: _currentStep,
            type: StepperType.vertical,
            stepIconBuilder: (stepIndex, stepState) {},
            onStepCancel: () {
              if (_currentStep > 0) {
                setState(() {
                  _currentStep--;
                });
              }
            },
            onStepContinue: () {
              switch (_currentStep) {
                case 0:
                  if (details.valid) {
                    setState(() {
                      completedSteps[0] = true;
                      _currentStep++;
                    });
                  } else {
                    details.markAllAsTouched();
                    // snackbar
                  }
                  break;
                case 1:
                  if (ingredients.value['items'].length > 0) {
                    setState(() {
                      completedSteps[1] = true;
                      _currentStep++;
                    });
                  } else {
                    // snackbar
                  }
                  break;
                case 2:
                  if (instructions.value['steps'].length > 0) {
                    setState(() {
                      completedSteps[2] = true;
                      _currentStep++;
                    });
                  } else {
                    // snackbar
                  }
                  break;
                case 3:
                  if (_photo == null && _photoWeb == null) {
                    //snackbar
                    return;
                  }
                  recipe = RecipeModel(
                    title: details.value['name'],
                    category: details.value['category'] ?? '',
                    recipeBook: details.value['book'] ?? '',
                    description: details.value['description'] ?? '',
                    ingredients: ingredients.value['items'],
                    instructions: instructions.value['steps'],
                    likes: 0,
                    createdBy: userUid,
                    isPublic: settings.value['isPublic'],
                    isShareable: settings.value['isShareable'],
                    prepTime: details.value['prepTime'],
                    cookTime: details.value['cookTime'],
                    servings: details.value['servings'],
                  );
                  recipesService.createRecipe(recipe, _photo ?? _photoWeb!);
                  context.read<AppModel>().recipeBook = RecipeBookModel(
                    name: '',
                    recipes: [],
                    createdBy: userUid,
                    likes: 0,
                  );
                  context.go('/');
                  break;
              }
            },
            steps: <Step>[
              Step(
                title: CText(
                  'Details',
                  textLevel: EText.button,
                ),
                content: Align(
                  alignment: Alignment.topLeft,
                  child: CustomCard(
                    card: ECard.elevated,
                    child: DetailsStep(),
                  ),
                ),
              ),
              Step(
                title: CText(
                  'Ingredients',
                  textLevel: EText.button,
                ),
                content: Align(
                  alignment: Alignment.topLeft,
                  child: CustomCard(
                    card: ECard.elevated,
                    child: IngredientsStep(
                      formGroup: formGroup,
                    ),
                  ),
                ),
              ),
              Step(
                title: CText(
                  'Instructions',
                  textLevel: EText.button,
                ),
                content: Align(
                  alignment: Alignment.topCenter,
                  child: CustomCard(
                    card: ECard.elevated,
                    child: InstructionsStep(
                      formGroup: formGroup,
                    ),
                  ),
                ),
              ),
              Step(
                title: CText(
                  'Settings',
                  textLevel: EText.button,
                ),
                content: Align(
                  alignment: Alignment.topCenter,
                  child: CustomCard(
                    card: ECard.elevated,
                    child: SaveStep(
                      formGroup: formGroup,
                      recipe: recipe,
                      selectImage: () => imgFromGallery(),
                      photo: _photoWeb,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildMobile(BuildContext context) {
    final theme = Theme.of(context);

    final controller = PageController(
      viewportFraction: 1,
      keepPage: true,
      initialPage: 0,
    );

    controller.addListener(() {
      setState(() {});
    });

    _handlePageChange(bool forward) {
      forward
          ? controller.nextPage(duration: Duration(milliseconds: 250), curve: Curves.linear)
          : controller.previousPage(duration: Duration(milliseconds: 250), curve: Curves.linear);
    }

    buildPageTitle(String label) {
      return Padding(
        padding: const EdgeInsets.only(
          left: 25.0,
        ),
        child: CText(label, textLevel: EText.title),
      );
    }

    return ReactiveFormBuilder(
      form: buildForm,
      builder: (context, formGroup, child) {
        AbstractControl<dynamic> details = formGroup.control('details') as FormGroup;
        AbstractControl<dynamic> ingredients = formGroup.control('ingredients') as FormGroup;
        AbstractControl<dynamic> instructions = formGroup.control('instructions') as FormGroup;
        AbstractControl<dynamic> settings = formGroup.control('settings') as FormGroup;
        _formGroup = formGroup;

        _determinePageValid() {
          if (controller.page == 0) {
            return details.valid;
          } else if (controller.page == 1) {
            return ingredients.value['items'].length > 0;
          } else if (controller.page == 2) {
            return instructions.value['steps'].length > 0;
          } else if (controller.page == 3) {
            return _photo != null || _photoWeb != null;
          } else {
            return false;
          }
        }

        submit(File photo, String imageName) {
          recipe = RecipeModel(
            title: details.value['name'],
            category: details.value['category'] ?? '',
            recipeBook: details.value['book'] ?? '',
            description: details.value['description'] ?? '',
            ingredients: ingredients.value['items'],
            instructions: instructions.value['steps'],
            likes: 0,
            createdBy: userUid,
            isPublic: settings.value['isPublic'],
            isShareable: settings.value['isShareable'],
            prepTime: details.value['prepTime'],
            cookTime: details.value['cookTime'],
            servings: details.value['servings'],
          );
          if (widget.id != null) {
            recipesService.updateRecipe(widget.id!, recipe);
          } else {
            recipesService.createRecipe(recipe, photo);
          }
          context.read<AppModel>().recipeBook = RecipeBookModel(
            name: '',
            recipes: [],
            createdBy: userUid,
            likes: 0,
          );
          context.go('/');
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: theme.colorScheme.surface,
            elevation: 0,
            title: CText(
              widget.id == null ? "Create A New Recipe" : "Edit Recipe",
              textLevel: EText.title,
              weight: FontWeight.bold,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: IconButton(
                  onPressed: () => _handleDelete(context),
                  icon: Icon(
                    Icons.delete_outline_outlined,
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                flex: 7,
                child: PageView(
                  physics: NeverScrollableScrollPhysics(),
                  controller: controller,
                  children: [
                    Wrap(
                      children: [
                        buildPageTitle('Recipe Details'),
                        DetailsStep(),
                      ],
                    ),
                    Wrap(
                      children: [
                        buildPageTitle('Recipe Ingredients'),
                        IngredientsStep(
                          formGroup: formGroup,
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        buildPageTitle('Recipe Instructions'),
                        InstructionsStep(
                          formGroup: formGroup,
                        ),
                      ],
                    ),
                    Wrap(
                      children: [
                        buildPageTitle('Recipe Settings & Save Recipe'),
                        SaveStep(
                          formGroup: formGroup,
                          recipe: recipe,
                          selectImage: () => imgFromGallery(),
                          photo: _photoWeb,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: ReactiveFormConsumer(
                    builder: (context, formGroup, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 2,
                            child: IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: () => _handlePageChange(false),
                            ),
                          ),
                          Expanded(
                            flex: 7,
                            child: Center(
                              child: SmoothPageIndicator(
                                controller: controller,
                                count: 4,
                                effect: ExpandingDotsEffect(
                                  activeDotColor: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                          controller.page != 3
                              ? Expanded(
                                  flex: 2,
                                  child: IconButton(
                                    icon: Icon(Icons.arrow_forward_ios),
                                    onPressed: _determinePageValid()
                                        ? () => _handlePageChange(true)
                                        : null,
                                  ),
                                )
                              : Expanded(
                                  flex: 2,
                                  child: IconButton(
                                    onPressed: _determinePageValid()
                                        ? () => submit(_photo!, _name!)
                                        : null,
                                    icon: Icon(Icons.check),
                                  ),
                                )
                        ],
                      );
                    },
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
