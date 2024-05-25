import 'package:freezed_annotation/freezed_annotation.dart';

part 'ingredient.freezed.dart';

@freezed
class Ingredient with _$Ingredient {
  const Ingredient._();

  const factory Ingredient({
    String? item,
    String? quantity,
    String? unit,
  }) = _Ingredient;

  List<Ingredient> fromMap(
    List<dynamic> ingredients,
  ) {
    return ingredients
        .map(
          (ingredient) => Ingredient(
            item: ingredient['item'],
            quantity: ingredient['quantity'],
            unit: ingredient['unit'],
          ),
        )
        .toList();
  }

  Map<String, dynamic> toMap() {
    return {
      if (item != null) "item": item,
      if (quantity != null) "quantity": quantity,
      if (unit != null) "unit": unit,
    };
  }
}
