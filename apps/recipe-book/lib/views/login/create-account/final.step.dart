import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/services/user/authentication.service.dart';
import 'package:recipe_book/services/user/recipe-books.service.dart';
import 'package:recipe_book/shared/page-view.shared.dart';
import 'package:recipe_book/assets.dart';
import 'package:ui/layout/responsive-widget.custom.dart';

import '../../../app_model.dart';
import '../../../models/models.dart';
import '../../../services/logging.service.dart';
import '../../../services/user/profile.service.dart';

class FinalStep extends StatelessWidget {
  const FinalStep({super.key});

  _handleCreateAccount(FormGroup _formGroup, BuildContext context) async {
    final FormGroup userLogin = _formGroup.control('UserLogin') as FormGroup;
    final FormGroup userSettings = _formGroup.control('UserSettings') as FormGroup;
    final FormGroup categories = _formGroup.control('Categories') as FormGroup;
    final FormGroup recipeBooks = _formGroup.control('RecipeBooks') as FormGroup;

    AuthenticationResult<User> result = await authenticationService.createEmailAccount(
        userLogin.control('Email').value, userLogin.control('Password').value);

    if (result.success) {
      UserModel user = new UserModel(
        name: userSettings.control('Name').value,
        darkTheme: userSettings.control('DefaultTheme').value,
        categories: categories.control('items').value,
      );
      await profileService.createUser(user, result.payload!.uid);
      recipeBooks.control('items').value.forEach((element) async {
        await recipeBookService.createRecipeBook(element);
      });
      context.read<AppModel>().uid = result.payload!.uid;
      context.go('/');
    } else {
      loggingService.triggerSnackbar(
        context,
        ISnackbar(type: ELogging.error, message: result.message!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktopScreen: PageViewShared(
        title: 'Ready to start Creating and Sharing Recipes',
        subtitle: 'Finalize the process by clicking the button below',
        imageWidget: Image.asset(
          ASSETS.RecipeBookLogo,
          height: 75,
        ),
        spacingWidget: SizedBox(
          height: 30.0,
        ),
        bodyWidget: ReactiveFormConsumer(
          builder: (context, _formGroup, child) {
            return SizedBox(
              width: MediaQuery.of(context).size.width * .3,
              child: Wrap(
                children: [
                  ElevatedButton(
                    onPressed: () => _handleCreateAccount(_formGroup, context),
                    child: Text('Get Started'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      mobileScreen: PageViewShared(
        title: 'Ready to start Creating and Sharing Recipes',
        subtitle: 'Finalize the process by clicking the button below',
        imageWidget: Container(
          height: 75,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ASSETS.RecipeBookLogo),
            ),
          ),
        ),
        bodyWidget: ReactiveFormConsumer(
          builder: (context, _formGroup, child) {
            return Wrap(
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () => _handleCreateAccount(_formGroup, context),
                    child: Text('Get Started'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
