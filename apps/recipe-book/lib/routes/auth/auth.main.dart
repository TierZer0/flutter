import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/main.page.dart';
import 'package:recipe_book/providers/auth/providers.dart';
import 'package:ui/inputs/reactive-input.custom.dart';
import 'package:ui/layout/responsive-widget.custom.dart';
import 'package:auth_buttons/auth_buttons.dart' show GoogleAuthButton, AuthButtonStyle, AuthButtonType, AuthIconType;

class AuthMainRoute extends ConsumerStatefulWidget {
  const AuthMainRoute({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthMainRouteState();
}

class _AuthMainRouteState extends ConsumerState<AuthMainRoute> {
  FormGroup get form => fb.group(
        {
          'email': FormControl(validators: [Validators.required, Validators.email]),
          'password': FormControl(validators: [Validators.required, Validators.minLength(8)]),
        },
      );

  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    ref.read(authNotifierProvider.notifier).checkAuth();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authNotifierProvider, (previous, next) {
      next.maybeWhen(
        orElse: () {},
        loading: () {
          setState(() {
            // isLoading = true;
          });
        },
        authenticated: (user) {
          setState(() {
            isLoggedIn = true;
          });
        },
        unauthenticated: (message) {
          setState(() {
            isLoggedIn = false;
          });
        },
      );
    });

    return switch (isLoggedIn) {
      true => MainPage(),
      false => ResponsiveWidget(
          mobileScreen: buildMobile(context),
        ),
    };
  }

  Widget buildMobile(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(150),
          child: Image.asset(
            'assets/recipebook-logo.png',
            height: 125,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 30.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Gap(50),
                ReactiveFormBuilder(
                  form: () => form,
                  builder: (context, formGroup, child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CustomReactiveInput(
                          formControlName: 'email',
                          label: 'Email',
                          // prefixIcon: Icons.email,
                          inputAction: TextInputAction.next,
                          validationMessages: {
                            'required': (p0) => 'Email is required',
                            'email': (p0) => 'Email must be Email format',
                          },
                        ),
                        Gap(25),
                        CustomReactiveInput(
                          formControlName: 'password',
                          label: 'Password',
                          // prefixIcon: Icons.lock,
                          obscureText: true,
                          inputAction: TextInputAction.done,
                          validationMessages: {
                            'minLength': (p1) => 'Password must be atleast 8 characters',
                            'required': (p1) => 'Password is required'
                          },
                        ),
                        Gap(50),
                        ReactiveFormConsumer(
                          builder: (context, formGroup, child) {
                            return FilledButton(
                              onPressed: formGroup.invalid
                                  ? null
                                  : () => ref.read(authNotifierProvider.notifier).login(
                                        email: formGroup.value['email'] as String,
                                        password: formGroup.value['password'] as String,
                                      ),
                              child: Text(
                                'Login',
                                textScaler: TextScaler.linear(
                                  1.25,
                                ),
                              ),
                            );
                          },
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Create Account',
                            textScaler: TextScaler.linear(
                              1.00,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                Divider(
                  height: 50,
                ),
                Wrap(
                  children: [
                    GoogleAuthButton(
                      onPressed: () => ref.read(authNotifierProvider.notifier).continueWithGoogle(),
                      darkMode: Theme.of(context).brightness == Brightness.dark,
                      style: AuthButtonStyle(
                        buttonType: AuthButtonType.icon,
                        iconType: AuthIconType.secondary,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
