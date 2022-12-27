class RecipeBook {}

class Recipe {}

class Ingredient {
  String item;
  String quanity;
  String unit;

  Ingredient(this.item, this.quanity, this.unit);

  @override
  String toString() {
    return '$item ($quanity $unit)';
  }
}
