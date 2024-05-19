import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'categories.freezed.dart';

@freezed
class Categories with _$Categories {
  const Categories._();

  const factory Categories({
    required String category,
    required int timesUsed,
  }) = _Categories;

  factory Categories.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Categories(
      category: data?['category'],
      timesUsed: data?['timesUsed'],
    );
  }

  factory Categories.fromMap(Map<String, dynamic> map) {
    return Categories(
      category: map['category'],
      timesUsed: map['timesUsed'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'category': category,
      'timesUsed': timesUsed,
    };
  }
}
