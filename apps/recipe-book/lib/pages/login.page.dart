import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
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

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var auth = AuthService();
    final appModel = Provider.of<AppModel>(context);
    return Material(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.symmetric(
          horizontal: 30.0,
          vertical: 100.0,
        ),
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
                CustomInput(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  label: 'Email',
                  type: TextInputType.emailAddress,
                  controller: emailController,
                  focusColor: primaryColor,
                  textColor: lightThemeTextColor,
                  onTap: () {},
                ),
                CustomInput(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                  ),
                  label: 'Password',
                  type: TextInputType.visiblePassword,
                  controller: passwordController,
                  focusColor: primaryColor,
                  textColor: lightThemeTextColor,
                  obscure: true,
                  onTap: () {},
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
                  onTap: () async => await auth
                      .emailSignIn(
                        emailController.text,
                        passwordController.text,
                      )
                      .then((value) => {appModel.uid = value.uid}),
                ),
                CustomButton(
                  buttonColor: Colors.transparent,
                  label: 'Create Account',
                  textStyle: GoogleFonts.lato(
                    color: lightThemeTextColor,
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                  externalPadding: EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width * .25,
                    vertical: 0.0,
                  ),
                  internalPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  boxShadows: const [],
                  onTap: () async => await auth
                      .emailCreateAccount(
                        emailController.text,
                        passwordController.text,
                      )
                      .then((value) => {appModel.uid = value.uid}),
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
                          onPressed: () {},
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
    );
  }
}
