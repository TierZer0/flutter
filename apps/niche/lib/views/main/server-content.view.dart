import 'package:flutter/material.dart';

class ServerContent extends StatefulWidget {
  @override
  ServerContentState createState() => ServerContentState();
}

class ServerContentState extends State<ServerContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 12,
      child: Container(
        width: MediaQuery.of(context).size.width * .15,
        height: MediaQuery.of(context).size.height,
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
    );
  }
}
