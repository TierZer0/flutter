import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:recipe_book/models/resources/categories.dart';

part 'resources.freezed.dart';

@freezed
class Resources with _$Resources {
  const Resources._();

  const factory Resources({
    required List<String> units,
    required List<Categories> categories,
  }) = _Resources;

  factory Resources.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return Resources(
      units: data?['units'] is Iterable ? List<String>.from(data?['units']) : [],
      categories: List<Categories>.from(data?['categories']?.map((x) => Categories.fromMap(x))),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'units': units.toList(),
      'categories': categories.map((x) => x.toFirestore()).toList(),
    };
  }
}
