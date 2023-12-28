import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';

import 'package:recipe_book/models/models.dart' show RecipeBookModel;
import 'package:ui/ui.dart' show CText, EText, CustomCard, ECard, CustomReactiveInput;

class AuthCreateAccountView extends ConsumerStatefulWidget {
  const AuthCreateAccountView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthCreateAccountViewState();
}

class _AuthCreateAccountViewState extends ConsumerState<AuthCreateAccountView> {
  final formGroup = FormGroup({
    'UserLogin': FormGroup({
      'Email': FormControl<String>(validators: [
        Validators.required,
        Validators.email,
      ]),
      'Password': FormControl<String>(validators: [
        Validators.required,
        Validators.minLength(8),
      ]),
      'Name': FormControl<String>(validators: [Validators.required]),
    }),
    'Categories': FormGroup({
      'Category': FormControl<String>(validators: [Validators.required]),
      'items': FormControl<List<String>>(
        value: [],
        validators: [Validators.required],
      ),
    }),
    'RecipeBooks': FormGroup({
      'Name': FormControl<String>(validators: [Validators.required]),
      'Description': FormControl<String>(validators: [Validators.required]),
      'items': FormControl<List<RecipeBookModel>>(
        value: [],
        validators: [Validators.required],
      ),
    })
  });

  buildCardSection({List<Widget> body = const [], EdgeInsets? margin, List<Widget> header = const []}) {
    return CustomCard(
      margin: margin ?? EdgeInsets.symmetric(horizontal: 15.0),
      card: ECard.elevated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          header.isNotEmpty
              ? CustomCard(
                  margin: EdgeInsets.zero,
                  card: ECard.filled,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: header,
                    ),
                  ),
                )
              : SizedBox.shrink(),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Wrap(
              runSpacing: 20.0,
              children: body,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 0,
            toolbarHeight: 75.0,
            title: Column(
              children: [
                CText(
                  "Livre de Recettes",
                  textLevel: EText.custom,
                  textStyle: GoogleFonts.poly(
                    fontSize: 35.0,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.primary,
                  ),
                ),
                CText(
                  "Create Account",
                  textLevel: EText.title2,
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            child: ReactiveForm(
              formGroup: formGroup,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Gap(10),
                  buildCardSection(
                    header: [
                      CText(
                        "Account Information",
                        textLevel: EText.title,
                        weight: FontWeight.w600,
                      ),
                    ],
                    body: [
                      CustomReactiveInput(
                        inputAction: TextInputAction.next,
                        formName: 'UserLogin.Email',
                        label: 'Email',
                        textColor: theme.colorScheme.onBackground,
                        validationMessages: {'required': (p0) => 'Email is required', 'email': (p0) => 'Email must be Email format'},
                      ),
                      CustomReactiveInput(
                        inputAction: TextInputAction.next,
                        formName: 'UserLogin.Password',
                        label: 'Password',
                        textColor: theme.colorScheme.onBackground,
                        validationMessages: {
                          'required': (p0) => 'Password is required',
                          'minLength': (p0) => 'Password must be at least 8 characters'
                        },
                      ),
                      CustomReactiveInput(
                        inputAction: TextInputAction.next,
                        formName: 'UserLogin.Name',
                        label: 'Display Name',
                        textColor: theme.colorScheme.onBackground,
                        validationMessages: {
                          'required': (p0) => 'Name is required',
                        },
                      ),
                    ],
                  ),
                  Gap(20),
                  buildCardSection(
                    header: [
                      CText(
                        "Initial Categories",
                        textLevel: EText.title,
                        weight: FontWeight.w600,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CText(
                            "Categories are a way to organize your recipes.",
                            textLevel: EText.caption,
                          ),
                          CText(
                            "For example, you might have a category for 'Desserts' or 'Appetizers'.",
                            textLevel: EText.caption,
                          ),
                        ],
                      ),
                      Gap(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomReactiveInput(
                            inputAction: TextInputAction.next,
                            formName: 'Categories.Category',
                            label: 'Category',
                            textColor: theme.colorScheme.onBackground,
                            validationMessages: {
                              'required': (p0) => 'Category is required',
                            },
                          ),
                          Gap(10),
                          ElevatedButton(
                            onPressed: () {
                              formGroup.control('Categories.items').value.add(formGroup.control('Categories.Category').value);
                              formGroup.control('Categories.Category').reset();
                              setState(() {});
                            },
                            child: CText(
                              'Add Category',
                              textLevel: EText.button,
                            ),
                          ),
                        ],
                      ),
                    ],
                    body: [
                      ReactiveFormConsumer(
                        builder: (context, _formGroup, child) {
                          return Container(
                            constraints: BoxConstraints(
                              minHeight: 100,
                              maxHeight: 300,
                            ),
                            child: ListView.builder(
                              itemCount: _formGroup.control('Categories.items').value.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: CText(
                                    _formGroup.control('Categories.items').value[index],
                                    textLevel: EText.body,
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      _formGroup.control('Categories.items').value.removeAt(index);
                                      _formGroup.control('Categories.items').markAsDirty();
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      )
                    ],
                  ),
                  Gap(20),
                  buildCardSection(
                    header: [
                      CText(
                        "Initial Recipe Books",
                        textLevel: EText.title,
                        weight: FontWeight.w600,
                      ),
                      CText(
                        "Recipe Books are a collection of recipes that you can share with others.",
                        textLevel: EText.caption,
                      ),
                      CText(
                        "For example, you might have a recipe book for 'Desserts' or 'Appetizers'.",
                        textLevel: EText.caption,
                      ),
                      Gap(10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomReactiveInput(
                            inputAction: TextInputAction.next,
                            formName: 'RecipeBooks.Name',
                            label: 'Name',
                            textColor: theme.colorScheme.onBackground,
                            validationMessages: {
                              'required': (p0) => 'Name is required',
                            },
                          ),
                          Gap(10),
                          CustomReactiveInput(
                            inputAction: TextInputAction.next,
                            formName: 'RecipeBooks.Description',
                            label: 'Description',
                            textColor: theme.colorScheme.onBackground,
                            validationMessages: {
                              'required': (p0) => 'Description is required',
                            },
                          ),
                          Gap(10),
                          ElevatedButton(
                            onPressed: () {
                              formGroup.control('RecipeBooks.items').value.add(
                                    RecipeBookModel(
                                      name: formGroup.control('RecipeBooks.Name').value,
                                      description: formGroup.control('RecipeBooks.Description').value,
                                    ),
                                  );
                              formGroup.control('RecipeBooks.Name').reset();
                              formGroup.control('RecipeBooks.Description').reset();
                              setState(() {});
                            },
                            child: CText(
                              'Add Recipe Book',
                              textLevel: EText.button,
                            ),
                          ),
                        ],
                      )
                    ],
                    body: [
                      ReactiveFormConsumer(
                        builder: (context, _formGroup, child) {
                          return SizedBox(
                            height: 200,
                            child: ListView.builder(
                              itemCount: _formGroup.control('RecipeBooks.items').value.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: CText(
                                    _formGroup.control('RecipeBooks.items').value[index].name,
                                    textLevel: EText.body,
                                  ),
                                  subtitle: CText(
                                    _formGroup.control('RecipeBooks.items').value[index].description,
                                    textLevel: EText.caption,
                                  ),
                                  trailing: IconButton(
                                    onPressed: () {
                                      _formGroup.control('RecipeBooks.items').value.removeAt(index);
                                      _formGroup.control('RecipeBooks.items').markAsDirty();
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      )
                    ],
                  ),
                  Gap(20)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
