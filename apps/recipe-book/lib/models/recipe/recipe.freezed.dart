// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Recipe {
  String? get title => throw _privateConstructorUsedError;
  String? get category => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<Instruction>? get instructions => throw _privateConstructorUsedError;
  List<Ingredient>? get ingredients => throw _privateConstructorUsedError;
  int? get likes => throw _privateConstructorUsedError;
  String? get id => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  List<Review>? get reviews => throw _privateConstructorUsedError;
  bool? get isPublic => throw _privateConstructorUsedError;
  bool? get isShareable => throw _privateConstructorUsedError;
  int? get prepTime => throw _privateConstructorUsedError;
  int? get cookTime => throw _privateConstructorUsedError;
  int? get totalTime => throw _privateConstructorUsedError;
  int? get servings => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RecipeCopyWith<Recipe> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeCopyWith<$Res> {
  factory $RecipeCopyWith(Recipe value, $Res Function(Recipe) then) =
      _$RecipeCopyWithImpl<$Res, Recipe>;
  @useResult
  $Res call(
      {String? title,
      String? category,
      String? description,
      List<Instruction>? instructions,
      List<Ingredient>? ingredients,
      int? likes,
      String? id,
      String? createdBy,
      String? image,
      List<Review>? reviews,
      bool? isPublic,
      bool? isShareable,
      int? prepTime,
      int? cookTime,
      int? totalTime,
      int? servings});
}

/// @nodoc
class _$RecipeCopyWithImpl<$Res, $Val extends Recipe>
    implements $RecipeCopyWith<$Res> {
  _$RecipeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? category = freezed,
    Object? description = freezed,
    Object? instructions = freezed,
    Object? ingredients = freezed,
    Object? likes = freezed,
    Object? id = freezed,
    Object? createdBy = freezed,
    Object? image = freezed,
    Object? reviews = freezed,
    Object? isPublic = freezed,
    Object? isShareable = freezed,
    Object? prepTime = freezed,
    Object? cookTime = freezed,
    Object? totalTime = freezed,
    Object? servings = freezed,
  }) {
    return _then(_value.copyWith(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      instructions: freezed == instructions
          ? _value.instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as List<Instruction>?,
      ingredients: freezed == ingredients
          ? _value.ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>?,
      likes: freezed == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as int?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      reviews: freezed == reviews
          ? _value.reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as List<Review>?,
      isPublic: freezed == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool?,
      isShareable: freezed == isShareable
          ? _value.isShareable
          : isShareable // ignore: cast_nullable_to_non_nullable
              as bool?,
      prepTime: freezed == prepTime
          ? _value.prepTime
          : prepTime // ignore: cast_nullable_to_non_nullable
              as int?,
      cookTime: freezed == cookTime
          ? _value.cookTime
          : cookTime // ignore: cast_nullable_to_non_nullable
              as int?,
      totalTime: freezed == totalTime
          ? _value.totalTime
          : totalTime // ignore: cast_nullable_to_non_nullable
              as int?,
      servings: freezed == servings
          ? _value.servings
          : servings // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecipeImplCopyWith<$Res> implements $RecipeCopyWith<$Res> {
  factory _$$RecipeImplCopyWith(
          _$RecipeImpl value, $Res Function(_$RecipeImpl) then) =
      __$$RecipeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? title,
      String? category,
      String? description,
      List<Instruction>? instructions,
      List<Ingredient>? ingredients,
      int? likes,
      String? id,
      String? createdBy,
      String? image,
      List<Review>? reviews,
      bool? isPublic,
      bool? isShareable,
      int? prepTime,
      int? cookTime,
      int? totalTime,
      int? servings});
}

/// @nodoc
class __$$RecipeImplCopyWithImpl<$Res>
    extends _$RecipeCopyWithImpl<$Res, _$RecipeImpl>
    implements _$$RecipeImplCopyWith<$Res> {
  __$$RecipeImplCopyWithImpl(
      _$RecipeImpl _value, $Res Function(_$RecipeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = freezed,
    Object? category = freezed,
    Object? description = freezed,
    Object? instructions = freezed,
    Object? ingredients = freezed,
    Object? likes = freezed,
    Object? id = freezed,
    Object? createdBy = freezed,
    Object? image = freezed,
    Object? reviews = freezed,
    Object? isPublic = freezed,
    Object? isShareable = freezed,
    Object? prepTime = freezed,
    Object? cookTime = freezed,
    Object? totalTime = freezed,
    Object? servings = freezed,
  }) {
    return _then(_$RecipeImpl(
      title: freezed == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String?,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      instructions: freezed == instructions
          ? _value._instructions
          : instructions // ignore: cast_nullable_to_non_nullable
              as List<Instruction>?,
      ingredients: freezed == ingredients
          ? _value._ingredients
          : ingredients // ignore: cast_nullable_to_non_nullable
              as List<Ingredient>?,
      likes: freezed == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as int?,
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      image: freezed == image
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      reviews: freezed == reviews
          ? _value._reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as List<Review>?,
      isPublic: freezed == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool?,
      isShareable: freezed == isShareable
          ? _value.isShareable
          : isShareable // ignore: cast_nullable_to_non_nullable
              as bool?,
      prepTime: freezed == prepTime
          ? _value.prepTime
          : prepTime // ignore: cast_nullable_to_non_nullable
              as int?,
      cookTime: freezed == cookTime
          ? _value.cookTime
          : cookTime // ignore: cast_nullable_to_non_nullable
              as int?,
      totalTime: freezed == totalTime
          ? _value.totalTime
          : totalTime // ignore: cast_nullable_to_non_nullable
              as int?,
      servings: freezed == servings
          ? _value.servings
          : servings // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$RecipeImpl extends _Recipe {
  const _$RecipeImpl(
      {this.title,
      this.category,
      this.description,
      final List<Instruction>? instructions,
      final List<Ingredient>? ingredients,
      this.likes,
      this.id,
      this.createdBy,
      this.image,
      final List<Review>? reviews,
      this.isPublic,
      this.isShareable,
      this.prepTime,
      this.cookTime,
      this.totalTime,
      this.servings})
      : _instructions = instructions,
        _ingredients = ingredients,
        _reviews = reviews,
        super._();

  @override
  final String? title;
  @override
  final String? category;
  @override
  final String? description;
  final List<Instruction>? _instructions;
  @override
  List<Instruction>? get instructions {
    final value = _instructions;
    if (value == null) return null;
    if (_instructions is EqualUnmodifiableListView) return _instructions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<Ingredient>? _ingredients;
  @override
  List<Ingredient>? get ingredients {
    final value = _ingredients;
    if (value == null) return null;
    if (_ingredients is EqualUnmodifiableListView) return _ingredients;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final int? likes;
  @override
  final String? id;
  @override
  final String? createdBy;
  @override
  final String? image;
  final List<Review>? _reviews;
  @override
  List<Review>? get reviews {
    final value = _reviews;
    if (value == null) return null;
    if (_reviews is EqualUnmodifiableListView) return _reviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final bool? isPublic;
  @override
  final bool? isShareable;
  @override
  final int? prepTime;
  @override
  final int? cookTime;
  @override
  final int? totalTime;
  @override
  final int? servings;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._instructions, _instructions) &&
            const DeepCollectionEquality()
                .equals(other._ingredients, _ingredients) &&
            (identical(other.likes, likes) || other.likes == likes) &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.image, image) || other.image == image) &&
            const DeepCollectionEquality().equals(other._reviews, _reviews) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic) &&
            (identical(other.isShareable, isShareable) ||
                other.isShareable == isShareable) &&
            (identical(other.prepTime, prepTime) ||
                other.prepTime == prepTime) &&
            (identical(other.cookTime, cookTime) ||
                other.cookTime == cookTime) &&
            (identical(other.totalTime, totalTime) ||
                other.totalTime == totalTime) &&
            (identical(other.servings, servings) ||
                other.servings == servings));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      title,
      category,
      description,
      const DeepCollectionEquality().hash(_instructions),
      const DeepCollectionEquality().hash(_ingredients),
      likes,
      id,
      createdBy,
      image,
      const DeepCollectionEquality().hash(_reviews),
      isPublic,
      isShareable,
      prepTime,
      cookTime,
      totalTime,
      servings);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeImplCopyWith<_$RecipeImpl> get copyWith =>
      __$$RecipeImplCopyWithImpl<_$RecipeImpl>(this, _$identity);
}

abstract class _Recipe extends Recipe {
  const factory _Recipe(
      {final String? title,
      final String? category,
      final String? description,
      final List<Instruction>? instructions,
      final List<Ingredient>? ingredients,
      final int? likes,
      final String? id,
      final String? createdBy,
      final String? image,
      final List<Review>? reviews,
      final bool? isPublic,
      final bool? isShareable,
      final int? prepTime,
      final int? cookTime,
      final int? totalTime,
      final int? servings}) = _$RecipeImpl;
  const _Recipe._() : super._();

  @override
  String? get title;
  @override
  String? get category;
  @override
  String? get description;
  @override
  List<Instruction>? get instructions;
  @override
  List<Ingredient>? get ingredients;
  @override
  int? get likes;
  @override
  String? get id;
  @override
  String? get createdBy;
  @override
  String? get image;
  @override
  List<Review>? get reviews;
  @override
  bool? get isPublic;
  @override
  bool? get isShareable;
  @override
  int? get prepTime;
  @override
  int? get cookTime;
  @override
  int? get totalTime;
  @override
  int? get servings;
  @override
  @JsonKey(ignore: true)
  _$$RecipeImplCopyWith<_$RecipeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
