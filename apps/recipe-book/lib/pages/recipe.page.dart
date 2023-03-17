import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class RecipePage extends StatefulWidget {
  final String recipeId;
  final String source;

  RecipePage({required this.recipeId, required this.source});

  @override
  RecipePageState createState() => RecipePageState();
}

class RecipePageState extends State<RecipePage> {
  @override
  void initState() {
    super.initState();
    trackView();
  }

  trackView() async {
    try {
      var instance = FirebaseFunctions.instance;
      // instance.useFunctionsEmulator('localhost', 5001);
      print(FirebaseAuth.instance.currentUser);
      final result = await instance.httpsCallable('viewOnRecipe').call([
        {"recipeId": widget.recipeId}
      ]);
    } on FirebaseFunctionsException catch (error) {
      print(error.code);
      print(error.details);
      print(error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150),
        child: Hero(
          tag: 'recipe-${widget.recipeId}-${widget.source}',
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
