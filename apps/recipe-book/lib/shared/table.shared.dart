import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:ui/general/text.custom.dart';

class TableShared<T> extends StatefulWidget {
  List<String> fields;
  List<T> data;
  bool useCheckbox;

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
    this.useCheckbox = false,
  });

  @override
  State<TableShared<T>> createState() => _TableSharedState<T>();
}

class _TableSharedState<T> extends State<TableShared<T>> {
  List<bool> selected = [];
  List<int> items = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    items = List<int>.generate(widget.data.length, (int index) => index);
    selected = List<bool>.generate(widget.data.length, (index) => false);
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      color: this.widget.color ?? theme.colorScheme.background,
      child: SizedBox(
        width: double.maxFinite,
        child: DataTable(
          headingRowColor: this.widget.headingRowColor ??
              MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) => theme.colorScheme.surface),
          dataRowColor: this.widget.dataRowColor ??
              MaterialStateProperty.resolveWith<Color?>(
                  (Set<MaterialState> states) => theme.colorScheme.surface.withOpacity(0.5)),
          columns: List<DataColumn>.generate(
            widget.fields.length,
            (index) => DataColumn(
              label: CText(
                widget.fields[index],
                textLevel: EText.title2,
                weight: FontWeight.bold,
              ),
            ),
          ),
          rows: items.map((itemIndex) {
            return DataRow(
              cells: List<DataCell>.generate(widget.fields.length, (index) {
                try {
                  final obj = jsonDecode(jsonEncode(widget.data[itemIndex]));
                  return DataCell(
                    CText(
                      obj[widget.fields[index].toLowerCase()].toString(),
                      textLevel: EText.body,
                    ),
                  );
                } catch (e) {
                  return DataCell(
                    SizedBox.shrink(),
                  );
                }
              }).toList(),
              selected: selected[itemIndex],
              onSelectChanged: widget.useCheckbox
                  ? (bool? value) {
                      setState(() {
                        selected[itemIndex] = value!;
                      });
                    }
                  : null,
            );
          }).toList(),
        ),
      ),
    );
  }
}
