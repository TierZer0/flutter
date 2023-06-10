import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/app_model.dart';
import 'package:recipe_book/preferences/app_preferences.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui/ui.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  AppPreferences appPreferences = AppPreferences();

  @override
  void initState() {
    super.initState();
  }

  final form = FormGroup({
    'email': FormControl(validators: [Validators.required, Validators.email]),
    'password': FormControl(validators: [Validators.required, Validators.minLength(8)]),
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 10,
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
      body: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: constraints.maxWidth > 600
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.3,
                  vertical: 50.0,
                )
              : EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 15.0,
                ),
          child: CustomCard(
            card: ECard.elevated,
            child: ReactiveForm(
              formGroup: form,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Wrap(
                  spacing: 20.0,
                  runSpacing: 20.0,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CText(
                          "Welcome",
                          textLevel: EText.title,
                          weight: FontWeight.w600,
                        ),
                        CText(
                          "Login to your account",
                          textLevel: EText.title2,
                        ),
                      ],
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
                        return ElevatedButton(
                          onPressed: form.invalid
                              ? null
                              : () async {
                                  await authService
                                      .emailSignIn(form.control('email').value,
                                          form.control('password').value)
                                      .then(
                                    (value) {
                                      if (value.runtimeType == String) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text(value)),
                                        );
                                      } else {
                                        context.read<AppModel>().uid = value.uid;
                                        context.go('/');
                                      }
                                    },
                                  );
                                },
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
                            child: CText(
                              "Login",
                              textLevel: EText.button,
                            ),
                          ),
                        );
                      },
                    ),
                    Divider(
                      height: 25,
                    ),
                    Wrap(
                      spacing: 20.0,
                      children: [
                        SizedBox(
                          width: 200,
                          child: OutlinedButton(
                            onPressed: () async {
                              await authService.googleSSO().then((value) {
                                if (value.runtimeType == String) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(value)),
                                  );
                                } else {
                                  context.read<AppModel>().uid = value.uid;
                                  context.go('/');
                                }
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.google,
                                    ),
                                    CText(
                                      "Google Signin",
                                      textLevel: EText.button,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
