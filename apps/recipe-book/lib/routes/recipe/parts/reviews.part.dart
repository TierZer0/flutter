import 'package:flutter/material.dart';
import 'package:recipe_book/models/models.dart';

class RecipeReviewsPart extends StatefulWidget {
  final List<Review> reviews;

  const RecipeReviewsPart({
    Key? key,
    required this.reviews,
  }) : super(key: key);

  @override
  _RecipeReviewsPartState createState() => _RecipeReviewsPartState();
}

class _RecipeReviewsPartState extends State<RecipeReviewsPart> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.reviews.length,
            itemBuilder: (context, index) {
              final review = widget.reviews[index];
              return ListTile(
                dense: true,
                title: Text(
                  review.review!,
                  textScaler: TextScaler.linear(
                    1.25,
                  ),
                ),
                subtitle: Row(
                  children: List.generate(
                    review.stars!,
                    (index) => Icon(Icons.star),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
