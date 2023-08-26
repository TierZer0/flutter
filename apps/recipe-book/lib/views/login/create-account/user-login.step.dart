import 'package:flutter/material.dart';
import 'package:recipe_book/shared/page-view.shared.dart';
import 'package:ui/inputs/reactive-input.custom.dart';
import 'package:ui/layout/responsive-widget.custom.dart';
import 'package:recipe_book/assets.dart';

class UserLoginStep extends StatelessWidget {
  UserLoginStep({super.key});

  final formGroupName = 'UserLogin';
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ResponsiveWidget(
      desktopScreen: PageViewShared(
        title: 'Create Your Login',
        subtitle: 'Enter your Email and Password to create your account.',
        imageWidget: Image.asset(
          ASSETS.RecipeBookLogo,
          height: 75,
        ),
        spacingWidget: SizedBox(
          height: 30,
        ),
        bodyWidget: SizedBox(
          width: MediaQuery.of(context).size.width * .4,
          child: Wrap(
            runSpacing: 20,
            children: [
              CustomReactiveInput(
                inputAction: TextInputAction.next,
                formName: '${formGroupName}.Email',
                label: 'Email',
                textColor: theme.colorScheme.onBackground,
              ),
              CustomReactiveInput(
                inputAction: TextInputAction.next,
                obscureText: true,
                formName: '${formGroupName}.Password',
                label: 'Password',
                textColor: theme.colorScheme.onBackground,
              ),
            ],
          ),
        ),
      ),
      mobileScreen: PageViewShared(
        title: 'Create Your Login',
        subtitle: 'Enter your Email and Password to create your account.',
        imageWidget: Container(
          height: 75,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ASSETS.RecipeBookLogo),
            ),
          ),
        ),
        bodyWidget: Wrap(
          runSpacing: 20,
          children: [
            CustomReactiveInput(
              inputAction: TextInputAction.next,
              formName: '${formGroupName}.Email',
              label: 'Email',
              textColor: theme.colorScheme.onBackground,
            ),
            CustomReactiveInput(
              inputAction: TextInputAction.next,
              obscureText: true,
              formName: '${formGroupName}.Password',
              label: 'Password',
              textColor: theme.colorScheme.onBackground,
            ),
          ],
        ),
      ),
    );
  }
}
