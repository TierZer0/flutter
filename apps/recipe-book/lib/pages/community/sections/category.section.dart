import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/models/resources/resources.model.dart';
import 'package:recipe_book/services/resources.service.dart';
import 'package:ui/general/card.custom.dart';
import 'package:ui/general/text.custom.dart';

class ByCategorySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
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
          child: FutureBuilder(
            future: resourcesService.getCategories(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data as List<CategoryModel>;
                data.sort((a, b) => b.timesUsed.compareTo(a.timesUsed));
                return ListView.builder(
                  itemCount: data.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Hero(
                      tag: data[index].category,
                      child: CustomCard(
                        card: ECard.elevated,
                        color: colorScheme.tertiaryContainer,
                        child: InkWell(
                          onTap: () =>
                              context.push('/community/byCategory/${data[index].category}'),
                          child: SizedBox(
                            width: 100,
                            child: Center(
                              child: CText(
                                data[index].category,
                                textLevel: EText.title2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: CText(
                    snapshot.error.toString(),
                    textLevel: EText.title2,
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ],
    );
  }
}
