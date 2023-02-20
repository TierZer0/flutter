import 'package:flutter/material.dart';
import 'package:recipe_book/styles.dart';
import 'package:ui/ui.dart';

class InfoTab extends StatelessWidget {
  const InfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20.0,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomText(
                      text: "Likes",
                      fontSize: 25.0,
                      fontFamily: "Lato",
                      color: theme.colorScheme.onBackground,
                      padding: const EdgeInsets.only(
                        top: 18.0,
                        left: 20.0,
                        bottom: 20.0,
                      ),
                    ),
                    CustomIconButton(
                      icon: const Icon(
                        Icons.navigate_next_outlined,
                        size: 25.0,
                      ),
                      onPressed: () {},
                      color: primaryColor,
                    )
                  ],
                ),
                SizedBox(
                  height: 125.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Column(
              children: [
                Row(
                  children: [
                    CustomText(
                      text: "Popular Recipes",
                      fontSize: 25.0,
                      fontFamily: "Lato",
                      color: theme.colorScheme.onBackground,
                      padding: const EdgeInsets.only(
                        top: 18.0,
                        left: 20.0,
                        bottom: 20.0,
                      ),
                    ),
                    CustomIconButton(
                      icon: const Icon(
                        Icons.navigate_next_outlined,
                        size: 25.0,
                      ),
                      onPressed: () {},
                      color: primaryColor,
                    )
                  ],
                ),
                SizedBox(
                  height: 125.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Column(
              children: [
                Row(
                  children: [
                    CustomText(
                      text: "Popular Recipe Books",
                      fontSize: 25.0,
                      fontFamily: "Lato",
                      color: theme.colorScheme.onBackground,
                      padding: const EdgeInsets.only(
                        top: 18.0,
                        left: 20.0,
                        bottom: 20.0,
                      ),
                    ),
                    CustomIconButton(
                      icon: const Icon(
                        Icons.navigate_next_outlined,
                        size: 25.0,
                      ),
                      onPressed: () {},
                      color: primaryColor,
                    )
                  ],
                ),
                SizedBox(
                  height: 125.0,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
