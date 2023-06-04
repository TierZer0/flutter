import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/app_model.dart';
import 'package:recipe_book/preferences/app_preferences.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/styles.dart';
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
            CustomText(
              text: "Livre de Recettes",
              overrideStyle: true,
              textStyle: GoogleFonts.poly(
                fontSize: 55.0,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                color: primaryColor,
              ),
            ),
            CustomText(
              text: "Recipe Book",
              fontSize: 30.0,
              fontWeight: FontWeight.w400,
              color: lightThemeTextColor,
              fontFamily: 'Lato',
            ),
            CustomText(
              text: "By TierZero Studios",
              fontSize: 18.0,
              fontWeight: FontWeight.w300,
              fontFamily: 'Lato',
              color: lightThemeTextColor,
              padding: const EdgeInsets.symmetric(
                vertical: 5.0,
              ),
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
                        CustomText(
                          text: "Welcome",
                          fontSize: 28.0,
                          fontFamily: 'Lato',
                          fontWeight: FontWeight.w600,
                        ),
                        CustomText(
                          text: 'Login to your account',
                          fontSize: 20.0,
                          fontFamily: 'Lato',
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
                            padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 20.0),
                            child: CustomText(
                              text: "Login",
                              fontSize: 20.0,
                              fontFamily: "Lato",
                              color: theme.colorScheme.onBackground,
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
                          width: 225,
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
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    FaIcon(
                                      FontAwesomeIcons.google,
                                    ),
                                    CustomText(
                                      text: "Google Signin",
                                      fontSize: 20.0,
                                      fontFamily: "Lato",
                                      color: theme.colorScheme.onBackground,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    )
                    // GoogleSignInButton(
                    //   loadingIndicator: CircularProgressIndicator(),
                    //   clientId: DefaultFirebaseOptions.currentPlatform.appId,
                    //   onSignedIn: (user) {
                    //     context.read<AppModel>().uid = user.user!.uid;
                    //     context.go('/');
                    //   },
                    // ),
                    // GoogleSignInIconButton(
                    //   loadingIndicator: CircularProgressIndicator(),
                    //   clientId: '1:85740521128:android:3b8e9f6023aa844bc1249d',
                    //   onSignedIn: (user) {
                    //     context.read<AppModel>().uid = user.user!.uid;
                    //     context.go('/');
                    //   },
                    // )
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
