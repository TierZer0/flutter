import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  String category;
  int timesUsed;

  CategoryModel({
    required this.category,
    required this.timesUsed,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      category: map['category'],
      timesUsed: map['timesUsed'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'timesUsed': timesUsed,
    };
  }
}

class ResourcesModel {
  List<String> units;
  List<CategoryModel> categories;

  ResourcesModel({
    required this.units,
    required this.categories,
  });

  factory ResourcesModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return ResourcesModel(
      units: data?['units'] is Iterable ? List<String>.from(data?['units']) : [],
      categories:
          List<CategoryModel>.from(data?['categories']?.map((x) => CategoryModel.fromMap(x))),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'units': units.toList(),
      'categories': categories.map((x) => x.toMap()).toList(),
    };
  }
}
