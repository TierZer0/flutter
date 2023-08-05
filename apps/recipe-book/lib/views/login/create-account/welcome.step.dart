import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/shared/page-view.shared.dart';

import '../../../app_model.dart';

class WelcomeStep extends StatelessWidget {
  const WelcomeStep({super.key});

  @override
  Widget build(BuildContext context) {
    return PageViewShared(
      title: 'Welcome, thank you for joining us!',
      subtitle: 'Let\'s get started by creating your account.',
      imageWidget: Wrap(
        runSpacing: 25,
        children: [
          Container(
            height: 125,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/recipebook-logo.png"),
              ),
            ),
          ),
          Container(
            height: 75,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(context.read<AppModel>().theme
                    ? "assets/tierzero-light.png"
                    : "assets/tierzero-dark.png"),
              ),
            ),
          ),
        ],
      ),
      bodyWidget: SizedBox.shrink(),
    );
  }
}
