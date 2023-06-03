import 'package:flutter/material.dart';

enum ECard { elevated, outlined, filled }

class CustomCard extends StatelessWidget {
  final ECard card;
  final Widget child;
  final double elevation;

  const CustomCard({super.key, required this.card, required this.child, this.elevation = 2});

  @override
  Widget build(BuildContext context) {
    switch (card) {
      case ECard.elevated:
        return Card(
          elevation: elevation,
          clipBehavior: Clip.hardEdge,
          child: child,
        );
      case ECard.outlined:
        return Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          clipBehavior: Clip.hardEdge,
          child: child,
        );
      case ECard.filled:
        return Card(
          elevation: 0,
          color: Theme.of(context).colorScheme.surfaceVariant,
          clipBehavior: Clip.hardEdge,
          child: child,
        );
    }
  }
}
