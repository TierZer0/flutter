import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget? desktopScreen;
  final Widget? tabletScreen;
  final Widget mobileScreen;

  const ResponsiveWidget({
    super.key,
    this.desktopScreen,
    this.tabletScreen,
    required this.mobileScreen,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return desktopScreen ??
              const Center(
                child: Text('Not Implemented'),
              );
        } else if (constraints.maxWidth >= 800 && tabletScreen != null) {
          return tabletScreen!;
        } else {
          return mobileScreen;
        }
      },
    );
  }
}
