class IngredientModel {
  String? item;
  String? quantity;
  String? unit;

  IngredientModel({
    this.item,
    this.quantity,
    this.unit,
  });

  List<IngredientModel> fromMap(List<dynamic> ingredients) {
    return ingredients
        .map(
          (ingredient) => IngredientModel(
            item: ingredient['item'],
            quantity: ingredient['quantity'],
            unit: ingredient['unit'],
          ),
        )
        .toList();
  }

  Map<String, dynamic> toJson() {
    return {
      if (item != null) 'item': item,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
    };
  }

  @override
  String toString() {
    return '$item ($quantity $unit)';
  }
}
