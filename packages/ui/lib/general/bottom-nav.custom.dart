import 'package:flutter/material.dart';
import 'package:ui/general/text.custom.dart';

class CustomBottomNavBar extends StatelessWidget {
  double height;
  EdgeInsets padding;
  List<Widget> navs;
  List<CustomNavBarItem> mat3Navs;
  bool useMat3;
  Color activeColor;

  CustomBottomNavBar({
    required this.height,
    this.padding = const EdgeInsets.all(1.0),
    this.navs = const [],
    this.mat3Navs = const [],
    this.useMat3 = false,
    this.activeColor = Colors.transparent,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      color: theme.scaffoldBackgroundColor,
      height: height,
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: useMat3
            ? mat3Navs
                .map(
                  (item) => Expanded(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        splashColor: useMat3 ? Colors.transparent : Colors.grey,
                        onTap: item.onPressed,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15.0,
                                vertical: 0.0,
                              ),
                              margin: const EdgeInsets.only(bottom: 5.0),
                              decoration: BoxDecoration(
                                color: item.isActive ? activeColor : Colors.transparent,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(
                                    35.0,
                                  ),
                                ),
                              ),
                              child: item.icon,
                            ),
                            CustomText(
                              text: item.label,
                              fontSize: 12.0,
                              fontFamily: "Lato",
                              color: theme.colorScheme.onBackground,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                )
                .toList()
            : navs,
      ),
    );
  }
}

class CustomNavBarItem {
  String label;
  Icon icon;
  bool isActive;
  VoidCallback onPressed;

  CustomNavBarItem(
      {required this.label, required this.icon, required this.isActive, required this.onPressed});
}
