import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatelessWidget {
  double height;
  EdgeInsets padding;
  List<Widget> navs;

  CustomBottomNavBar({
    required this.height,
    this.padding = const EdgeInsets.all(1.0),
    required this.navs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      height: height,
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: navs,
      ),
    );
  }
}
