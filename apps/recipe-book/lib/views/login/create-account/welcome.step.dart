import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/assets.dart';
import 'package:recipe_book/shared/page-view.shared.dart';
import 'package:ui/general/text.custom.dart';
import 'package:ui/layout/responsive-widget.custom.dart';

import '../../../app_model.dart';

class WelcomeStep extends StatelessWidget {
  const WelcomeStep({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktopScreen: PageViewShared(
        titleWidget: Padding(
          padding: const EdgeInsets.only(
            left: 35.0,
          ),
          child: CText(
            'Welcome, thank you for joining us!',
            textLevel: EText.custom,
            textStyle: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        subtitleWidget: Padding(
          padding: EdgeInsets.only(
            left: 35.0,
          ),
          child: CText(
            'Let\'s get started by creating your account.',
            textLevel: EText.subtitle,
          ),
        ),
        spacingWidget: SizedBox(
          height: 30.0,
        ),
        imageWidget: Padding(
          padding: const EdgeInsets.only(
            bottom: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                ASSETS.RecipeBookLogo,
                height: 225,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 25.0,
                ),
                child: Image.asset(
                  context.read<AppModel>().theme
                      ? ASSETS.TierZeroStudiosLightLogo
                      : ASSETS.TierZeroStudiosDarkLogo,
                  height: 100,
                ),
              ),
            ],
          ),
        ),
        bodyWidget: SizedBox.shrink(),
      ),
      mobileScreen: PageViewShared(
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
                  image: AssetImage(ASSETS.RecipeBookLogo),
                ),
              ),
            ),
            Container(
              height: 75,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(context.read<AppModel>().theme
                      ? ASSETS.TierZeroStudiosLightLogo
                      : ASSETS.TierZeroStudiosDarkLogo),
                ),
              ),
            ),
          ],
        ),
        bodyWidget: SizedBox.shrink(),
      ),
    );
  }
}
