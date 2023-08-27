import 'package:flutter/material.dart';
import 'package:recipe_book/services/user/recipes.service.dart';
import 'package:ui/ui.dart';

import '../../../models/models.dart';

class ReviewsTab extends StatefulWidget {
  final String? id;

  const ReviewsTab({super.key, required this.id});

  @override
  ReviewsTabState createState() => ReviewsTabState();
}

class ReviewsTabState extends State<ReviewsTab> {
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: StreamBuilder(
          stream: recipesService.recipeReviews(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!.data();

              List<ReviewModel> reviews = [];
              (data.reviews ?? []).forEach(
                (e) => reviews.add(ReviewModel(
                  review: e.review,
                  stars: e.stars,
                )),
              );
              return ListView(
                children: reviews
                    .map(
                      (review) => ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0.0,
                          horizontal: 10.0,
                        ),
                        // tileColor: theme.colorScheme.surface,
                        title: CText(
                          review.review ?? '',
                          textLevel: EText.title2,
                          theme: theme,
                        ),
                        subtitle: review.stars! > 0
                            ? Wrap(
                                spacing: 4,
                                children: List<Widget>.generate(
                                  review.stars ?? 1,
                                  (index) => Icon(
                                    Icons.star_rate,
                                    color: theme.colorScheme.primary,
                                  ),
                                ).toList(),
                              )
                            : null,
                      ),
                    )
                    .toList(),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
