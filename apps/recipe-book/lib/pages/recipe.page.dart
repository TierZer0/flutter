import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class RecipePage extends StatefulWidget {
  final String recipeId;

  RecipePage({required this.recipeId});

  @override
  RecipePageState createState() => RecipePageState();
}

class RecipePageState extends State<RecipePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: Hero(
          tag: 'recipe-${widget.recipeId}',
          child: AppBar(
            title: CustomText(
              text: widget.recipeId,
              fontSize: 35.0,
              fontFamily: "Lato",
              color: theme.colorScheme.onBackground,
              padding: EdgeInsets.only(
                bottom: 40.0,
              ),
            ),
            elevation: 0,
            toolbarHeight: 85.0,
          ),
        ),
      ),
    );
  }
}
