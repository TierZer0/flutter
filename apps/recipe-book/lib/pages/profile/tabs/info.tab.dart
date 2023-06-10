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
    );
  }
}
