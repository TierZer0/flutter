import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:ui/ui.dart';

class InfoTab extends StatefulWidget {
  const InfoTab({super.key});

  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  List<RecipeModel> recipes = [];

  @override
  void initState() {
    super.initState();
    // userService.likes().then((results) async {
    //   List<RecipeModel> _recipes = [];
    //   print(results);
    //   results.forEach((result) async {
    //     var item = await result;
    //     setState(() {
    //       _recipes.add(item);
    //     });
    //   });
    // });
  }

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
                      color: theme.colorScheme.primary,
                    )
                  ],
                ),
                SizedBox(
                  height: 150.0,
                  child: Padding(
                    padding: EdgeInsets.only(top: 0.0, left: 0.0),
                    child: FutureBuilder(
                      future: userService.likes(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final docs = snapshot.data!.docs;
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: docs.map((doc) {
                              final recipe = doc.data();

                              return Hero(
                                tag: 'recipe-${doc.id}-profileInfo',
                                child: Card(
                                  elevation: 2,
                                  margin: EdgeInsets.only(right: 10.0, bottom: 15.0, left: 20.0),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: () => context.push('/recipe/${doc.id}/profileInfo'),
                                    child: SizedBox(
                                      height: 250,
                                      width: 150,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 10.0,
                                          horizontal: 10.0,
                                        ),
                                        child: CustomText(
                                          text: recipe.title,
                                          fontSize: 18.0,
                                          fontFamily: "Lato",
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                        return SkeletonLoader(
                          builder: Row(
                            children: [
                              Card(
                                margin: EdgeInsets.only(right: 10.0, bottom: 15.0, left: 20.0),
                                child: SizedBox(
                                  height: 135,
                                  width: 150,
                                ),
                              ),
                              Card(
                                margin: EdgeInsets.only(right: 10.0, bottom: 15.0, left: 20.0),
                                child: SizedBox(
                                  height: 125,
                                  width: 150,
                                ),
                              ),
                            ],
                          ),
                          items: 1,
                          period: Duration(seconds: 4),
                          baseColor: theme.colorScheme.surface,
                          highlightColor: theme.colorScheme.primary,
                          direction: SkeletonDirection.ltr,
                        );
                      },
                    ),
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
                      color: theme.colorScheme.primary,
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
                      color: theme.colorScheme.primary,
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
