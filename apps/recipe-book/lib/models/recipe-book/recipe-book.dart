import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'recipe-book.freezed.dart';

@freezed
class RecipeBook with _$RecipeBook {
  const RecipeBook._();

  const factory RecipeBook({
    String? id,
    String? name,
    String? description,
    List<String>? recipeIds,
    List<dynamic>? recipes,
    String? createdBy,
    int? likes,
  }) = _RecipeBook;

  factory RecipeBook.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    if (data == null) throw Exception('No data found in snapshot');
    return RecipeBook(
      id: snapshot.id,
      name: data['name'],
      description: data['description'] ?? '',
      recipeIds: data['recipeIds'] is Iterable ? List<String>.from(data['recipeIds']) : [],
      createdBy: data['createdBy'],
      likes: data['likes'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (name != null) "name": name,
      if (recipeIds != null) "recipeIds": recipeIds,
      if (createdBy != null) "createdBy": createdBy,
      if (likes != null) "likes": likes,
      if (description != null) "description": description,
      if (recipes != null) "recipes": recipes,
      if (id != null) "id": id,
    };
  }
}
