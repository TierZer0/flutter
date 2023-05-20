import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ui/general/text.custom.dart';

class TableShared<T> extends StatelessWidget {
  List<String> fields;
  List data;

  MaterialStateProperty<Color?>? headingRowColor;
  MaterialStateProperty<Color?>? dataRowColor;
  Color? color;

  TableShared({
    super.key,
    required this.fields,
    required this.data,
    this.headingRowColor = null,
    this.dataRowColor = null,
    this.color = null,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      color: this.color ?? theme.colorScheme.background,
      child: SizedBox(
        width: double.maxFinite,
        child: DataTable(
          headingRowColor: this.headingRowColor ??
              MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) => theme.colorScheme.surface),
          dataRowColor: this.dataRowColor ??
              MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) => theme.colorScheme.surface.withOpacity(0.5)),
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
          rows: data
              .map(
                (item) => DataRow(
                  cells: List<DataCell>.generate(fields.length, (index) {
                    final obj = jsonDecode(jsonEncode(item));
                    return DataCell(
                      CustomText(
                        text: obj[fields[index].toLowerCase()].toString(),
                        fontSize: 15.0,
                        fontFamily: "Lato",
                        color: theme.colorScheme.onSurface,
                      ),
                    );
                  }).toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
