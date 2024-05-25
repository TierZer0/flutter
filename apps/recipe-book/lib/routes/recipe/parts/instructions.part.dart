import 'package:flutter/material.dart';
import 'package:recipe_book/models/models.dart';

class RecipeInstructionsPart extends StatefulWidget {
  final List<Instruction> instructions;

  const RecipeInstructionsPart({
    Key? key,
    required this.instructions,
  }) : super(key: key);

  @override
  _RecipeInstructionsPartState createState() => _RecipeInstructionsPartState();
}

class _RecipeInstructionsPartState extends State<RecipeInstructionsPart> {
  @override
  void initState() {
    super.initState();
    widget.instructions.sort((a, b) => a.order!.compareTo(b.order!));
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.instructions.length,
            itemBuilder: (context, index) {
              final instruction = widget.instructions[index];
              return ListTile(
                dense: true,
                leading: Text(
                  '${instruction.order}',
                  textScaler: TextScaler.linear(
                    1.5,
                  ),
                ),
                title: Text(
                  instruction.title!,
                  textScaler: TextScaler.linear(
                    1.25,
                  ),
                ),
                subtitle: Text(
                  instruction.description!,
                  textScaler: TextScaler.linear(
                    1.0,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
