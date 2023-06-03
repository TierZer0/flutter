import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:ui/ui.dart';

class InstructionsTable extends StatefulWidget {
  final RecipeModel recipeModel;

  InstructionsTable({required this.recipeModel});

  @override
  InstructionsTableState createState() => InstructionsTableState();
}

class InstructionsTableState extends State<InstructionsTable> {
  List<InstructionModel> instructions = [];
  // instructions.sort((a, b) => a.order!.compareTo(b.order!));
  var fields = ['Title', 'Decription'];
  List<bool> selected = [];

  @override
  void initState() {
    super.initState();
    instructions = widget.recipeModel.instructions!;
    selected = List<bool>.generate(instructions.length, (index) => false);
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Center(
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: theme.colorScheme.background,
        child: SizedBox(
          width: double.maxFinite,
          child: DataTable(
            headingRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
              return theme.colorScheme.surface;
            }),
            dataRowColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
              return theme.colorScheme.surface.withOpacity(0.5);
            }),
            columns: List<DataColumn>.generate(
              fields.length,
              (index) => DataColumn(
                label: CustomText(
                  text: fields[index],
                  fontSize: 20.0,
                  fontFamily: "Lato",
                  color: theme.colorScheme.onBackground,
                ),
              ),
            ),
            rows: instructions
                .asMap()
                .entries
                .map(
                  (entry) => DataRow(
                    cells: [
                      DataCell(
                        CustomText(
                          text: entry.value.title,
                          fontSize: 15.0,
                          fontFamily: "Lato",
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      DataCell(
                        CustomText(
                          text: entry.value.description,
                          fontSize: 15.0,
                          fontFamily: "Lato",
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                    selected: selected[entry.key],
                    onSelectChanged: (bool? value) {
                      setState(() {
                        selected[entry.key] = value!;
                      });
                    },
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }
}
