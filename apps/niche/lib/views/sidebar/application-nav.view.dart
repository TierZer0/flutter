import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../main.dart';

import '../../components/icon-button.custom.dart';

import '../../styles.dart';

class ApplicationNav extends StatefulWidget {
  @override
  ApplicationNavState createState() => ApplicationNavState();
}

class ApplicationNavState extends State<ApplicationNav> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context);
    return Container(
      width: MediaQuery.of(context).size.width * .03,
      height: MediaQuery.of(context).size.height,
      color: Theme.of(context).backgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => appModel.darkTheme = !appModel.darkTheme,
              child: const Center(
                child: Text(
                  'N',
                  style: TextStyle(
                    color: primaryTextColor,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Nunito',
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 15,
          ),
          CustomIconButton(
            externalPadding: const EdgeInsets.all(0),
            internalPadding: const EdgeInsets.all(8.0),
            backgroundColor: Colors.transparent,
            iconColor: appModel.view == 'niches'
                ? secondaryTextColor
                : lightTextColor2,
            onTap: () => appModel.view = 'niches',
            iconSize: 30,
            icon: Icons.folder_outlined,
          ),
          Container(
            height: 5,
          ),
          CustomIconButton(
            externalPadding: const EdgeInsets.all(0),
            internalPadding: const EdgeInsets.all(8.0),
            backgroundColor: Colors.transparent,
            iconColor:
                appModel.view == 'chats' ? secondaryTextColor : lightTextColor2,
            onTap: () => appModel.view = 'chats',
            iconSize: 30,
            icon: Icons.chat_outlined,
          ),
        ],
      ),
    );
  }
}
