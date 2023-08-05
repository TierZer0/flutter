import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/services/user/authentication.service.dart';
import 'package:recipe_book/shared/page-view.shared.dart';

class FinalStep extends StatelessWidget {
  const FinalStep({super.key});

  @override
  Widget build(BuildContext context) {
    return PageViewShared(
        title: 'Ready to start Creating and Sharing Recipes',
        subtitle: 'Finalize the process by clicking the button below',
        imageWidget: Container(
          height: 75,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/recipebook-logo.png"),
            ),
          ),
        ),
        bodyWidget: ReactiveFormConsumer(
          builder: (context, _formGroup, child) {
            final FormGroup userLogin =
                _formGroup.control('UserLogin') as FormGroup;
            final FormGroup userSettings =
                _formGroup.control('UserSettings') as FormGroup;
            final FormGroup categories =
                _formGroup.control('Categories') as FormGroup;
            final FormGroup recipeBooks =
                _formGroup.control('RecipeBooks') as FormGroup;

            return Wrap(
              children: [
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      authenticationService
                          .createEmailAccount(userLogin.control('Email').value,
                              userLogin.control('Password').value)
                          .then(
                        (result) {
                          if (result.success) {
                          } else {}
                        },
                      );
                    },
                    child: Text('Get Started'),
                  ),
                ),
              ],
            );
          },
        ));
  }
}
