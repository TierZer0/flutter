import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/views/login/create-account/categories.step.dart';
import 'package:recipe_book/views/login/create-account/final.step.dart';
import 'package:recipe_book/views/login/create-account/recipe-books.step.dart';
import 'package:recipe_book/views/login/create-account/welcome.step.dart';
// import 'package:introduction_screen/introduction_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ui/layout/responsive-widget.custom.dart';
import 'package:ui/ui.dart';

import 'create-account/user-login.step.dart';
import 'create-account/user-settings.step.dart';

class CreateAccount extends StatefulWidget {
  bool isSSO = false;

  CreateAccount({super.key, this.isSSO = false});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
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
    }),
    'UserSettings': FormGroup({
      'Name': FormControl<String>(validators: [Validators.required]),
      'DefaultTheme': FormControl<bool>(value: false, validators: [Validators.required]),
      // TO DO GET MORE USER SETTINGS
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

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktopScreen: buildDesktop(context),
      mobileScreen: buildMobile(context),
    );
  }

  Widget buildDesktop(BuildContext context) {
    return Container();
  }

  Widget buildMobile(BuildContext context) {
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

    _determinePageValid() {
      if (controller.page == 0) {
        return true;
      } else if (controller.page == 1) {
        return formGroup.control('UserLogin').valid;
      } else if (controller.page == 2) {
        return formGroup.control('UserSettings').valid;
      } else if (controller.page == 3) {
        return formGroup.control('Categories.items').value.length >= 3;
      } else if (controller.page == 4) {
        return formGroup.control('RecipeBooks.items').value.length >= 3;
      } else {
        return true;
      }
    }

    var theme = Theme.of(context);

    return Scaffold(
      body: ReactiveForm(
        formGroup: formGroup,
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: PageView(
                controller: controller,
                children: !widget.isSSO
                    ? [
                        WelcomeStep(),
                        UserLoginStep(),
                        UserSettingsStep(),
                        CategoriesStep(
                          formGroup: formGroup.control('Categories') as FormGroup,
                        ),
                        RecipeBooksStep(
                          formGroup: formGroup.control('RecipeBooks') as FormGroup,
                        ),
                        FinalStep(),
                      ]
                    : [
                        WelcomeStep(),
                        UserSettingsStep(),
                        CategoriesStep(
                          formGroup: formGroup.control('Categories') as FormGroup,
                        ),
                        RecipeBooksStep(
                          formGroup: formGroup.control('RecipeBooks') as FormGroup,
                        ),
                        FinalStep()
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
                      // mainAxisAlignment: MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: () => _handlePageChange(false),
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Center(
                            child: SmoothPageIndicator(
                              controller: controller,
                              count: !widget.isSSO ? 6 : 5,
                              effect: ExpandingDotsEffect(
                                activeDotColor: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            onPressed: _determinePageValid() ? () => _handlePageChange(true) : null,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
