class ReviewModel {
  String? review;
  String? createdBy;
  int? stars;

  ReviewModel({
    this.review,
    this.createdBy,
    this.stars,
  });

  List<ReviewModel> fromMap(List<dynamic> reviews) {
    return reviews
        .map(
          (review) => ReviewModel(
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
