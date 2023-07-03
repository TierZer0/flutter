import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/models/user.models.dart';
import 'package:recipe_book/services/user.service.dart';
import 'package:skeleton_loader/skeleton_loader.dart';
import 'package:ui/ui.dart';

import '../../../shared/items-grid.shared.dart';

class InfoTab extends StatefulWidget {
  UserModel user;

  InfoTab({super.key, required this.user});

  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  List<RecipeModel> recipes = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 660) {
        return buildDesktop(context);
      } else {
        return buildMobile(context);
      }
    });
  }

  Widget buildDesktop(BuildContext context) {
    Map data = new Map.from(widget.user.toFirestore());
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Wrap(
            runSpacing: 15.0,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CText(
                'User Info',
                textLevel: EText.title,
                weight: FontWeight.bold,
              ),
              Container(
                height: 200,
                child: FieldGridShared<RecipeModel>(
                  fields: [
                    'name',
                    'darkTheme',
                  ],
                  data: data,
                ),
              ),
              CText(
                'Recipes Info',
                textLevel: EText.title,
                weight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildMobile(BuildContext context) {
    Map data = new Map.from(widget.user.toFirestore());
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Wrap(
        runSpacing: 15.0,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CText(
            'User Info',
            textLevel: EText.title,
            weight: FontWeight.bold,
          ),
          Container(
            height: 200,
            child: FieldGridShared<RecipeModel>(
              fields: ['name'],
              data: data,
            ),
          ),
          CText(
            'Recipes Info',
            textLevel: EText.title,
            weight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
