import 'package:Niche/pages/login.page.dart';
import 'package:flutter/material.dart';

import '../views/sidebar/application-nav.view.dart';
import '../views/sidebar/server-nav.view.dart';

import '../views/main/server-content.view.dart';

import '../../main.dart';

class MainPage extends StatefulWidget {
  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  AppModel model = AppModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: model.uid != ''
          ? LoginPage()
          : Row(
              children: [
                ApplicationNav(),
                ServerNav(),
                Expanded(
                  child: ServerContent(),
                ),
              ],
            ),
    );
  }
}
