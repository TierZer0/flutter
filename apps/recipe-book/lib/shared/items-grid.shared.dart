import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ui/general/text.custom.dart';
import 'package:utils/functions/case.dart';

class FieldGridShared<T> extends StatelessWidget {
  final List<String> fields;
  final dynamic data;

  const FieldGridShared({
    super.key,
    required this.data,
    required this.fields,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: fields.length,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        childAspectRatio: 2.5 / 1,
        crossAxisSpacing: 20,
        mainAxisSpacing: 0,
      ),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CText(
                properCaseWithSpace(fields[index]),
                textLevel: EText.custom,
                textStyle: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(.75),
                ),
              ),
              CText(
                data[fields[index]].toString(),
                textLevel: EText.title2,
              )
            ],
          ),
        );
      },
    );
  }
}
