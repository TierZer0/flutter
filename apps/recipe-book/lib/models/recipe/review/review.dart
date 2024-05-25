import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';

@freezed
class Review with _$Review {
  const Review._();

  const factory Review({
    String? review,
    String? createdBy,
    int? stars,
  }) = _Review;

  List<Review> fromMap(
    List<dynamic> reviews,
  ) {
    return reviews
        .map(
          (review) => Review(
            review: review['review'],
            createdBy: review['createdBy'],
            stars: review['stars'],
          ),
        )
        .toList();
  }

  Map<String, dynamic> toMap() {
    return {
      if (review != null) 'review': review,
      if (createdBy != null) 'createdBy': createdBy,
      if (stars != null) 'stars': stars,
    };
  }
}
