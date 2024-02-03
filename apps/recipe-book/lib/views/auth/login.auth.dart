import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/providers/auth/providers.dart';

import 'package:ui/ui.dart' show CText, CustomCard, CustomReactiveInput, ECard, EText;

class AuthLoginView extends ConsumerStatefulWidget {
  final VoidCallback triggerCreateAccount;

  const AuthLoginView({Key? key, required this.triggerCreateAccount});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthLoginViewState(triggerCreateAccount: triggerCreateAccount);
}

class _AuthLoginViewState extends ConsumerState {
  final VoidCallback triggerCreateAccount;

  _AuthLoginViewState({required this.triggerCreateAccount});

  FormGroup get form => fb.group(
        {
          'email': FormControl(validators: [Validators.required, Validators.email]),
          'password': FormControl(validators: [Validators.required, Validators.minLength(8)]),
        },
      );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    ref.read(authNotifierProvider.notifier).checkAuth();
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
            toolbarHeight: 150.0,
            title: Column(
              children: [
                CText(
                  "Livre de Recettes",
                  textLevel: EText.custom,
                  textStyle: GoogleFonts.poly(
                    fontSize: 55.0,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic,
                    color: theme.colorScheme.primary,
                  ),
                ),
                CText(
                  "Recipe Book",
                  textLevel: EText.title2,
                ),
                CText(
                  "By TierZero Studios",
                  textLevel: EText.caption,
                ),
              ],
            ),
          ),
          body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: ReactiveFormBuilder(
              form: () => form,
              builder: (context, formGroup, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Gap(30.0),
                    CustomCard(
                      margin: EdgeInsets.symmetric(
                        horizontal: 15.0,
                      ),
                      card: ECard.elevated,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Wrap(
                          runSpacing: 20.0,
                          children: [
                            CText(
                              "Welcome",
                              textLevel: EText.title,
                              weight: FontWeight.w600,
                            ),
                            CustomReactiveInput(
                              inputAction: TextInputAction.next,
                              formName: 'email',
                              label: 'Email',
                              textColor: theme.colorScheme.onBackground,
                              validationMessages: {
                                'required': (p0) => 'Email is required',
                                'email': (p0) => 'Email must be Email format'
                              },
                            ),
                            CustomReactiveInput(
                              inputAction: TextInputAction.done,
                              formName: 'password',
                              label: 'Password',
                              obscureText: true,
                              textColor: theme.colorScheme.onBackground,
                              validationMessages: {
                                'minLength': (p1) => 'Password must be atleast 8 characters',
                                'required': (p1) => 'Password is required'
                              },
                            ),
                            ReactiveFormConsumer(
                              builder: (context, formGroup, child) {
                                return Wrap(
                                  spacing: 25,
                                  children: [
                                    ElevatedButton(
                                      onPressed: formGroup.invalid
                                          ? null
                                          : () => ref.read(authNotifierProvider.notifier).login(
                                                email: formGroup.value['email'] as String,
                                                password: formGroup.value['password'] as String,
                                              ),
                                      child: CText(
                                        "Login",
                                        textLevel: EText.button,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () => triggerCreateAccount(),
                                      // onPressed: () => context.replace('/login/createAccount/false'),
                                      child: CText(
                                        "Create Account",
                                        textLevel: EText.button,
                                      ),
                                    )
                                  ],
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Gap(20.0),
                    CustomCard(
                      margin: EdgeInsets.symmetric(
                        horizontal: 15.0,
                      ),
                      card: ECard.elevated,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Wrap(
                          children: [
                            OutlinedButton(
                              onPressed: () =>
                                  ref.read(authNotifierProvider.notifier).continueWithGoogle(),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
                                child: Wrap(
                                  spacing: 15.0,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.google,
                                    ),
                                    CText(
                                      "Google",
                                      textLevel: EText.button,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
