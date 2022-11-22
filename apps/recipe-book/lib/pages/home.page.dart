import 'package:flutter/material.dart';
import 'package:recipe_book/styles.dart';
import 'package:ui/ui.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  TextEditingController searchController = TextEditingController();
  PageController trendingCtrl = PageController(viewportFraction: 0.65);

  var testTrending = [
    {"title": "Southern Breakfast"},
    {"title": "Easy Dinners"},
    {"title": "Meal Preps"}
  ];
  bool categoryActive = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SafeArea(
      child: Material(
        child: Container(
          padding: const EdgeInsets.only(
            top: 20.0,
          ),
          color: theme.scaffoldBackgroundColor,
          height: MediaQuery.of(context).size.height - 90.0,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                text: "Welcome,",
                fontSize: 35.0,
                padding: const EdgeInsets.only(left: 30.0),
                fontFamily: "Lato",
                color: (theme.textTheme.titleLarge?.color)!,
              ),
              CustomText(
                text: "What do you want to cook today?",
                fontSize: 20.0,
                padding: const EdgeInsets.only(left: 30.0),
                fontFamily: "Lato",
                color: (theme.textTheme.titleLarge?.color)!,
              ),
              CustomInput(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 20.0,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                  vertical: 20.0,
                ),
                controller: searchController,
                focusColor: primaryColor,
                textColor: primaryColor,
                label: "Search",
                errorText: null,
                icon: const Icon(
                  Icons.search,
                ),
                fontSize: 20.0,
                onTap: () {},
              ),
              const SizedBox(
                height: 20.0,
              ),
              CustomText(
                text: "Trending",
                fontSize: 25.0,
                padding: const EdgeInsets.only(left: 30.0),
                fontFamily: "Lato",
                color: (theme.textTheme.titleLarge?.color)!,
              ),
              Container(
                height: 175,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 0.0,
                  ),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: testTrending
                      .map(
                        (item) => buildTrendingCard(
                          item,
                          theme.backgroundColor,
                          (theme.textTheme.titleLarge?.color)!,
                          context,
                          () {},
                        ),
                      )
                      .toList(),
                ),
              ),
              Container(
                height: 75,
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30.0,
                    vertical: 10.0,
                  ),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    CustomActionChip(
                      label: "Category",
                      backgroundColor: primaryColor.withOpacity(0.25),
                      borderColor: primaryColor,
                      textColor: primaryColor,
                      activeTextColor: Colors.white,
                      activeColor: primaryColor,
                      onTap: () {
                        setState(() {
                          categoryActive = !categoryActive;
                        });
                      },
                      active: categoryActive,
                      internalPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 5.0,
                      ),
                    ),
                  ],
                ),
              )
              // Container(
              //   height: 255,
              //   child: PageView.builder(
              //     itemCount: 3,
              //     controller: trendingCtrl,
              //     itemBuilder: (BuildContext context, int currentIndex) {
              //       return ;
              //     },
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildTrendingCard(item, Color backgrounColor, Color textColor,
    BuildContext context, VoidCallback onTap) {
  return Container(
    width: 200,
    margin: const EdgeInsets.symmetric(
      horizontal: 20.0,
      vertical: 20.0,
    ),
    decoration: BoxDecoration(
      color: backgrounColor,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          blurRadius: 10.0,
        ),
      ],
      borderRadius: const BorderRadius.all(
        Radius.circular(
          20.0,
        ),
      ),
    ),
    child: Material(
      color: Colors.transparent,
      borderRadius: const BorderRadius.all(
        Radius.circular(
          20.0,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomText(
                text: item['title'],
                fontSize: 20.0,
                fontFamily: "Lato",
                color: textColor,
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Widget buildRecipeCard(item, bool active, Color backgroundColor,
    Color textColor, BuildContext context) {
  final double blur = active ? 15 : 0;
  final double opacity = active ? 1 : 0;
  final double top = active ? 25 : 50;
  final double bottom = active ? 25 : 50;
  final double left = active ? 20 : 15;
  final double right = active ? 20 : 15;

  return AnimatedContainer(
    duration: const Duration(
      milliseconds: 400,
    ),
    decoration:
        BoxDecoration(color: backgroundColor, boxShadow: [new BoxShadow()]),
  );
}
