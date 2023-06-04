import 'package:flutter/material.dart';
import 'package:recipe_book/models/recipe.models.dart';
import 'package:recipe_book/services/recipes.service.dart';
import 'package:ui/ui.dart';

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
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 20.0),
        child: StreamBuilder(
          stream: recipesService.getRecipeReviews(widget.id),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var data = snapshot.data!.data();

              List<ReviewModel> reviews = [];
              (data['reviews'] ?? []).forEach(
                (e) => reviews.add(ReviewModel(
                  review: e['review'],
                  stars: e['stars'],
                )),
              );
              return ListView(
                children: reviews
                    .map(
                      (review) => Card(
                        elevation: 1,
                        clipBehavior: Clip.antiAlias,
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 5.0,
                            horizontal: 15.0,
                          ),
                          tileColor: theme.colorScheme.surface,
                          title: CustomText(
                            text: review.review,
                            fontSize: 25.0,
                            fontFamily: "Lato",
                            color: theme.colorScheme.onBackground,
                          ),
                          subtitle: review.stars! > 0
                              ? Wrap(
                                  spacing: 4,
                                  children: List<Widget>.generate(
                                    review.stars ?? 0,
                                    (index) => Icon(
                                      Icons.star_rate,
                                      color: theme.colorScheme.primary,
                                    ),
                                  ).toList(),
                                )
                              : null,
                        ),
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
