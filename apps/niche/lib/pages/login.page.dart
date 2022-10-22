import 'package:Niche/components/card.custom.dart';
import 'package:Niche/components/text.custom.dart';
import 'package:Niche/components/input-field.custom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../styles.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

enum states {
  LOGIN,
  NICHES,
}

class LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  final emailController = new TextEditingController();

  var currentEnum = states.LOGIN;

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context);
    return Material(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).scaffoldBackgroundColor,
        padding: const EdgeInsets.all(
          30.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomText(
              text: "Niche",
              fontSize: 45.0,
              fontWeight: FontWeight.bold,
              color: primaryTextColor,
            ),
            CustomText(
              text: "By TierZero Studios",
              fontSize: 20.0,
              fontWeight: FontWeight.w200,
              color: primaryTextColor,
            ),
            const SizedBox(
              height: 15.0,
            ),
            CustomText(
              text: "A Place To Find Your Niche",
              fontSize: 25.0,
              fontWeight: FontWeight.w500,
              color: secondaryTextColor,
            ),
            const SizedBox(
              height: 25.0,
            ),
            CustomCard(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
              elevation: 2.0,
              color: Theme.of(context).backgroundColor,
              child: Container(
                height: MediaQuery.of(context).size.height * .35,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  border: Border.all(
                    color:
                        appModel.darkTheme ? darkTextColor2 : lightTextColor2,
                    width: 0.25,
                  ),
                ),
                width: MediaQuery.of(context).size.width * .35,
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                  horizontal: 25.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 25.0,
                    ),
                    InputField(
                      controller: emailController,
                      hint: "Email",
                      textColor:
                          appModel.darkTheme ? darkTextColor2 : lightTextColor2,
                      focusColor: secondaryTextColor,
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      obscureText: false,
                      isElevated: true,
                    ),
                  ],
                ),
              ),
            ),
            // Material(
            //   borderRadius: const BorderRadius.all(
            //     Radius.circular(10.0),
            //   ),
            //   elevation: 2.0,
            //   color: Theme.of(context).backgroundColor,
            //   child: Container(
            //     height: MediaQuery.of(context).size.height * .35,
            //     decoration: BoxDecoration(
            //       borderRadius: const BorderRadius.all(
            //         Radius.circular(10.0),
            //       ),
            //       border: Border.all(
            //         color:
            //             appModel.darkTheme ? darkTextColor2 : lightTextColor2,
            //         width: 0.25,
            //       ),
            //     ),
            //     width: MediaQuery.of(context).size.width * .35,
            //     padding: const EdgeInsets.symmetric(
            //       vertical: 15.0,
            //       horizontal: 25.0,
            //     ),
            //     child: Column(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       children: [
            //         const Text(
            //           "Welcome Back",
            //           style: TextStyle(
            //             fontSize: 20,
            //           ),
            //         ),
            //         const SizedBox(
            //           height: 25.0,
            //         ),
            //         InputField(
            //           controller: emailController,
            //           hint: "Email",
            //           textColor:
            //               appModel.darkTheme ? darkTextColor2 : lightTextColor2,
            //           focusColor: secondaryTextColor,
            //           backgroundColor: Theme.of(context).backgroundColor,
            //           obscureText: false,
            //           isElevated: true,
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
