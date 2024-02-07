import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/providers/resources/resources.providers.dart';
import 'package:ui/general/card.custom.dart';
import 'package:ui/general/text.custom.dart';

class CategoryPart extends ConsumerStatefulWidget {
  const CategoryPart({super.key});

  @override
  CategoryPartState createState() => CategoryPartState();
}

class CategoryPartState extends ConsumerState<CategoryPart> {
  @override
  Widget build(BuildContext context) {
    final categoriesProvider = ref.watch(getCategoriesProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.maxFinite,
      height: 125,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
            ),
            child: CText(
              'By Category',
              textLevel: EText.custom,
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: colorScheme.onPrimary,
              ),
            ),
          ),
          Expanded(
            child: switch (categoriesProvider) {
              AsyncData(:final value) => switch (value.success) {
                  true => ListView.builder(
                      itemCount: value.payload![0].length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final item = value.payload![0][index];
                        return Hero(
                          tag: item.category,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CustomCard(
                              card: ECard.elevated,
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
                          ),
                        );
                      },
                    ),
                  false => Center(
                      child: CText(
                        'No categories found.',
                        textLevel: EText.subtitle,
                      ),
                    ),
                },
              AsyncLoading() => Center(child: CircularProgressIndicator()),
              AsyncError(:final error) => Center(
                  child: CText(
                    error.toString(),
                    textLevel: EText.subtitle,
                  ),
                ),
              _ => Center(
                  child: CircularProgressIndicator(),
                ),
            },
          ),
        ],
      ),
    );
  }
}
