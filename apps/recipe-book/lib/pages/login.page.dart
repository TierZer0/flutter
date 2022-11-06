import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/app_model.dart';
import 'package:recipe_book/styles.dart';
import 'package:ui/general/text.custom.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              fontSize: 55.0,
              fontWeight: FontWeight.w200,
              color: primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
