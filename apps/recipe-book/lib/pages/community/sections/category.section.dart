import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/providers/resources/resources.providers.dart';
import 'package:ui/general/card.custom.dart';
import 'package:ui/general/text.custom.dart';

class ByCategorySection extends ConsumerStatefulWidget {
  final String category;

  const ByCategorySection({Key? key, required this.category}) : super(key: key);

  @override
  _ByCategorySectionState createState() => _ByCategorySectionState();
}

class _ByCategorySectionState extends ConsumerState {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final categoriesProvider = ref.read(getCategoriesProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12.0,
          ),
          child: CText(
            'By Category',
            textLevel: EText.title,
          ),
        ),
        Gap(5),
        Expanded(
          child: switch (categoriesProvider) {
            AsyncData(:final value) => switch (value.success) {
                true => ListView.builder(
                    itemCount: value.payload![0].length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      final item = value.payload![0][index];
                      print(value.payload![0].length);

                      return Hero(
                        tag: item.category,
                        child: CustomCard(
                          card: ECard.elevated,
                          color: colorScheme.tertiaryContainer,
                          child: InkWell(
                            onTap: () => context.push('/community/byCategory/${item.category}'),
                            child: SizedBox(
                              width: 100,
                              child: Center(
                                child: CText(
                                  item.category,
                                  textLevel: EText.title2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                _ => Center(
                    child: CText(
                      value.message!,
                      textLevel: EText.title2,
                    ),
                  ),
              },
            AsyncError(:final error, :final stackTrace) => Center(
                child: CText(
                  error.toString(),
                  textLevel: EText.title2,
                ),
              ),
            _ => Center(
                child: CircularProgressIndicator(),
              ),
          },
        ),
      ],
    );
  }
}
