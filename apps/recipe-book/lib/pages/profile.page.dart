import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/services/auth.service.dart';
import 'package:ui/ui.dart';

import '../app_model.dart';

class ProfilePage extends StatefulWidget {
  @override
  ProfilePageState createState() => ProfilePageState();
}

class ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  var auth = AuthService();

  @override
  Widget build(BuildContext context) {
    User user = auth.user;
    var theme = Theme.of(context);
    final appModel = Provider.of<AppModel>(context);

    return SafeArea(
      child: Material(
        child: Container(
          padding: const EdgeInsets.only(
            top: 20.0,
          ),
          color: theme.scaffoldBackgroundColor,
          height: MediaQuery.of(context).size.height - 90.0,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                text: (user.displayName)!,
                fontSize: 35.0,
                padding: const EdgeInsets.only(left: 30.0),
                fontFamily: "Lato",
                color: (theme.textTheme.titleLarge?.color)!,
              ),
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
                      setState(() {
                        appModel.theme = value;
                      });
                    },
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
