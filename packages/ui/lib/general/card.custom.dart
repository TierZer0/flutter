import 'package:flutter/material.dart';

enum ECard { elevated, outlined, filled, none, custom }

class CustomCard extends StatelessWidget {
  final ECard card;
  final Widget child;
  final double elevation;
  final Color? color;
  final EdgeInsets? margin;

  const CustomCard({
    super.key,
    required this.card,
    required this.child,
    this.elevation = 2,
    this.color,
    this.margin = const EdgeInsets.all(4.0),
  });

  @override
  Widget build(BuildContext context) {
    switch (card) {
      case ECard.elevated:
        return Card(
          margin: margin,
          color: color ?? Theme.of(context).colorScheme.secondaryContainer,
          elevation: elevation,
          clipBehavior: Clip.hardEdge,
          child: child,
        );
      case ECard.outlined:
        return Card(
          margin: margin,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          clipBehavior: Clip.hardEdge,
          color: color ?? Colors.transparent,
          child: child,
        );
      case ECard.filled:
        return Card(
          margin: margin,
          elevation: 0,
          color: color ?? Theme.of(context).colorScheme.primaryContainer,
          clipBehavior: Clip.hardEdge,
          child: child,
        );
      case ECard.none:
        return Card(
          margin: margin,
          elevation: 0,
          color: color ?? Colors.transparent,
          clipBehavior: Clip.hardEdge,
          child: child,
        );
      case ECard.custom:
        return Card(
          margin: margin,
          elevation: elevation,
          color: color ?? Theme.of(context).colorScheme.tertiaryContainer,
          clipBehavior: Clip.hardEdge,
          child: child,
        );
    }
  }
}
