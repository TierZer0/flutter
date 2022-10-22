import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../main.dart';

class ServerNav extends StatefulWidget {
  @override
  ServerNavState createState() => ServerNavState();
}

class ServerNavState extends State<ServerNav> {
  @override
  void initState() {
    super.initState();
  }

  List<String> openViews = ['server', 'chats'];

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context);
    return Material(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        width: MediaQuery.of(context).size.width *
            (openViews.contains(appModel.view) ? .15 : 0),
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).backgroundColor,
      ),
    );
  }
}
