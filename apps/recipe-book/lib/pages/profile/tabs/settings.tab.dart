import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/app_model.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:recipe_book/styles.dart';
import 'package:ui/ui.dart';

class SettingsTab extends StatefulWidget {
  SettingsTab({super.key});

  @override
  SettingsTabState createState() => SettingsTabState();
}

class SettingsTabState extends State<SettingsTab> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final appModel = Provider.of<AppModel>(context);
    return Column(
      children: [
        Row(
          children: [
            CustomText(
              text: "Dark Theme",
              fontSize: 20.0,
              padding: const EdgeInsets.only(left: 30.0),
              fontFamily: "Lato",
              color: (theme.textTheme.titleLarge?.color)!,
            ),
            Switch(
              value: appModel.theme,
              onChanged: (value) {
                userService.setUserTheme(value);
                setState(() {
                  appModel.theme = value;
                });
              },
            ),
          ],
        ),
        CustomButton(
          externalPadding: const EdgeInsets.only(right: 50.0, left: 30.0),
          internalPadding: const EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: 20.0,
          ),
          label: 'Logout',
          buttonColor: primaryColor,
          onTap: () {
            authService.logout().then((value) {
              appModel.uid = '';
              appModel.theme = false;
              appModel.view = 'Home';
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Successfully Logged out'),
                ),
              );
            });
          },
          textStyle: const TextStyle(
            fontSize: 20.0,
            color: lightThemeTextColor,
          ),
        )
      ],
    );
  }
}
