import 'package:flutter/material.dart';
import 'package:ui/ui.dart';

class Accordion extends StatefulWidget {
  String title;
  String? subtitle;
  Widget? leading;
  Widget content;

  /// The expanded and collapsed sizes of the accordion.
  /// [0] is the collapsed size.
  /// [1] is the expanded size.
  ///
  /// {@macro flutter.widgets.ProxyWidget.child}
  List<double> expandedSizes = [];

  Accordion({
    super.key,
    required this.title,
    required this.content,
    this.subtitle,
    this.leading,
    this.expandedSizes = const [80, 250],
  });

  @override
  State<Accordion> createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  bool isExpanded = false;

  @override
  initState() {
    super.initState();
  }

  _handleExpand() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: double.maxFinite,
      height: isExpanded ? widget.expandedSizes[1] : widget.expandedSizes[0],
      duration: const Duration(milliseconds: 250),
      child: CustomCard(
        card: isExpanded ? ECard.elevated : ECard.outlined,
        child: InkWell(
          onTap: _handleExpand,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15.0,
              vertical: 10.0,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: CText(
                        widget.title,
                        textLevel: EText.title,
                      ),
                    ),
                    const Expanded(
                      flex: 5,
                      child: SizedBox(),
                    ),
                    Expanded(
                      flex: 1,
                      child: Icon(
                        isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                        size: 30,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
