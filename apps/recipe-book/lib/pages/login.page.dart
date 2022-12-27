import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:recipe_book/app_model.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/styles.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ui/ui.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  FormGroup buildForm() => fb.group(
        <String, Object>{
          'email': FormControl<String>(
            validators: [Validators.required, Validators.email],
          ),
          'password': ['', Validators.required, Validators.minLength(8)],
        },
      );

  final emailController = TextEditingController();
  var emailValidate = false;
  final passwordController = TextEditingController();
  var passwordValidate = false;

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context);
    return Material(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.only(
          left: 30.0,
          right: 30.0,
          top: 100.0,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              const SizedBox(
                height: 60.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  CustomText(
                    text: "Welcome Back,",
                    fontSize: 28.0,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w600,
                  ),
                  CustomText(
                    text: 'Login to your account',
                    fontSize: 20.0,
                    fontFamily: 'Lato',
                    padding: const EdgeInsets.only(
                      bottom: 20.0,
                    ),
                  ),
                  ReactiveFormBuilder(
                    form: buildForm,
                    builder: (context, form, child) {
                      return Column(
                        children: [
                          CustomReactiveInput(
                            inputAction: TextInputAction.next,
                            formName: 'email',
                            label: 'Email',
                            textColor: lightThemeTextColor,
                            validationMessages: {
                              ValidationMessage.required: (_) => 'The email must not be empty',
                              ValidationMessage.email: (_) =>
                                  'The email value must be a valid email',
                            },
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          CustomReactiveInput(
                            inputAction: TextInputAction.done,
                            formName: 'password',
                            label: 'Password',
                            textColor: lightThemeTextColor,
                            validationMessages: {
                              ValidationMessage.required: (_) => 'The password must not be empty',
                              ValidationMessage.minLength: (_) =>
                                  'The password must be at least 8 characters',
                            },
                          ),
                          const SizedBox(
                            height: 25.0,
                          ),
                          CustomButton(
                            label: 'Login',
                            buttonColor: primaryColor,
                            externalPadding: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width * .25,
                              vertical: 10.0,
                            ),
                            internalPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0,
                              vertical: 15.0,
                            ),
                            textStyle: GoogleFonts.lato(
                              color: darkThemeTextColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 20.0,
                            ),
                            onTap: () async {
                              form.markAllAsTouched();
                              if (form.invalid) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: tertiaryColor,
                                    content: Text(
                                      'Fill out the login form',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                );
                                return;
                              }
                              await authService
                                  .emailSignIn(
                                      form.control('email').value, form.control('password').value)
                                  .then(
                                (value) {
                                  if (value.runtimeType == String) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(value)),
                                    );
                                  } else {
                                    appModel.uid = value.uid;
                                  }
                                },
                              );
                            },
                          )
                        ],
                      );
                    },
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 20.0,
                    ),
                    child: Divider(
                      thickness: 1.0,
                      color: lightThemeTextColor,
                    ),
                  ),
                  Row(
                    children: [
                      Material(
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: IconButton(
                            onPressed: () async {
                              await authService.googleSSO().then((value) {
                                if (value.runtimeType == String) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(value)),
                                  );
                                } else {
                                  appModel.uid = value.uid;
                                }
                              });
                            },
                            iconSize: 40.0,
                            icon: const FaIcon(
                              FontAwesomeIcons.google,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
