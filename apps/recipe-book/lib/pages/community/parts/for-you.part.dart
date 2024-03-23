import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForYouPart extends ConsumerStatefulWidget {
  @override
  ForYouPartState createState() => ForYouPartState();
}

class ForYouPartState extends ConsumerState<ForYouPart> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: Text(
            'For You',
            textScaler: TextScaler.linear(2),
          ),
        ),
      ],
    );
  }
}
