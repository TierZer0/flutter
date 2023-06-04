import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/app_model.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:recipe_book/services/user.service.dart';
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
    // final appModel = Provider.of<AppModel>(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Application",
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Lato",
            color: theme.colorScheme.onBackground,
            padding: EdgeInsets.only(
              bottom: 10.0,
            ),
          ),
          SwitchListTile(
            title: Text(
              "Dark Theme",
              textScaleFactor: 1.0,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            value: context.read<AppModel>().theme,
            onChanged: (value) {
              userService.setUserTheme(value);
              setState(() {
                context.read<AppModel>().theme = value;
              });
            },
          ),
          Divider(
            height: 25.0,
          ),
          CustomText(
            text: "User",
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            fontFamily: "Lato",
            color: theme.colorScheme.onBackground,
            padding: EdgeInsets.only(
              bottom: 10.0,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              authService.logout().then((value) {
                context.read<AppModel>().uid = '';
                context.read<AppModel>().theme = false;
                context.read<AppModel>().view = 'Home';
                context.go('/login');
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Successfully Logged out'),
                  ),
                );
              });
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(theme.colorScheme.error),
            ),
            child: CustomText(
              text: "Logout",
              fontSize: 25.0,
              padding: EdgeInsets.symmetric(
                horizontal: 25.0,
                vertical: 10.0,
              ),
              fontFamily: "Lato",
              color: theme.colorScheme.onError,
            ),
          ),
        ],
      ),
    );
  }
}
