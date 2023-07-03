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
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 660) {
          return buildDesktop(context);
        } else {
          return buildMobile(context);
        }
      },
    );
  }

  Widget buildDesktop(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(10.0),
          child: Wrap(
            spacing: 40.0,
            runSpacing: 20.0,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CText(
                      'Application',
                      textLevel: EText.title,
                      weight: FontWeight.bold,
                    ),
                    SwitchListTile(
                      title: CText(
                        "Dark Theme",
                        textLevel: EText.button,
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
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  children: [
                    CText(
                      "Preferences",
                      textLevel: EText.title,
                      weight: FontWeight.bold,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CText(
                      "User",
                      textLevel: EText.title,
                      weight: FontWeight.bold,
                    ),
                    SizedBox(
                      height: 20.0,
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
                      child: CText(
                        'Logout',
                        textLevel: EText.dangerbutton,
                        theme: theme,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget buildMobile(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 20.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CText(
            'Application',
            textLevel: EText.title,
            weight: FontWeight.bold,
          ),
          SwitchListTile(
            title: CText(
              "Dark Theme",
              textLevel: EText.button,
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
          CText(
            "User",
            textLevel: EText.title,
            weight: FontWeight.bold,
          ),
          SizedBox(
            height: 20.0,
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
            child: CText(
              'Logout',
              textLevel: EText.dangerbutton,
              theme: theme,
            ),
          ),
        ],
      ),
    );
  }
}
