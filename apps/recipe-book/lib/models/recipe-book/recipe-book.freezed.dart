// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe-book.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$RecipeBook {
  String? get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String>? get recipeIds => throw _privateConstructorUsedError;
  List<dynamic>? get recipes => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  int? get likes => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $RecipeBookCopyWith<RecipeBook> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $RecipeBookCopyWith<$Res> {
  factory $RecipeBookCopyWith(
          RecipeBook value, $Res Function(RecipeBook) then) =
      _$RecipeBookCopyWithImpl<$Res, RecipeBook>;
  @useResult
  $Res call(
      {String? id,
      String? name,
      String? description,
      List<String>? recipeIds,
      List<dynamic>? recipes,
      String? createdBy,
      int? likes});
}

/// @nodoc
class _$RecipeBookCopyWithImpl<$Res, $Val extends RecipeBook>
    implements $RecipeBookCopyWith<$Res> {
  _$RecipeBookCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? recipeIds = freezed,
    Object? recipes = freezed,
    Object? createdBy = freezed,
    Object? likes = freezed,
  }) {
    return _then(_value.copyWith(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      recipeIds: freezed == recipeIds
          ? _value.recipeIds
          : recipeIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      recipes: freezed == recipes
          ? _value.recipes
          : recipes // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      likes: freezed == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$RecipeBookImplCopyWith<$Res>
    implements $RecipeBookCopyWith<$Res> {
  factory _$$RecipeBookImplCopyWith(
          _$RecipeBookImpl value, $Res Function(_$RecipeBookImpl) then) =
      __$$RecipeBookImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String? id,
      String? name,
      String? description,
      List<String>? recipeIds,
      List<dynamic>? recipes,
      String? createdBy,
      int? likes});
}

/// @nodoc
class __$$RecipeBookImplCopyWithImpl<$Res>
    extends _$RecipeBookCopyWithImpl<$Res, _$RecipeBookImpl>
    implements _$$RecipeBookImplCopyWith<$Res> {
  __$$RecipeBookImplCopyWithImpl(
      _$RecipeBookImpl _value, $Res Function(_$RecipeBookImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? recipeIds = freezed,
    Object? recipes = freezed,
    Object? createdBy = freezed,
    Object? likes = freezed,
  }) {
    return _then(_$RecipeBookImpl(
      id: freezed == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: freezed == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      recipeIds: freezed == recipeIds
          ? _value._recipeIds
          : recipeIds // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      recipes: freezed == recipes
          ? _value._recipes
          : recipes // ignore: cast_nullable_to_non_nullable
              as List<dynamic>?,
      createdBy: freezed == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      likes: freezed == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc

class _$RecipeBookImpl extends _RecipeBook {
  const _$RecipeBookImpl(
      {this.id,
      this.name,
      this.description,
      final List<String>? recipeIds,
      final List<dynamic>? recipes,
      this.createdBy,
      this.likes})
      : _recipeIds = recipeIds,
        _recipes = recipes,
        super._();

  @override
  final String? id;
  @override
  final String? name;
  @override
  final String? description;
  final List<String>? _recipeIds;
  @override
  List<String>? get recipeIds {
    final value = _recipeIds;
    if (value == null) return null;
    if (_recipeIds is EqualUnmodifiableListView) return _recipeIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<dynamic>? _recipes;
  @override
  List<dynamic>? get recipes {
    final value = _recipes;
    if (value == null) return null;
    if (_recipes is EqualUnmodifiableListView) return _recipes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? createdBy;
  @override
  final int? likes;

  @override
  String toString() {
    return 'RecipeBook(id: $id, name: $name, description: $description, recipeIds: $recipeIds, recipes: $recipes, createdBy: $createdBy, likes: $likes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RecipeBookImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality()
                .equals(other._recipeIds, _recipeIds) &&
            const DeepCollectionEquality().equals(other._recipes, _recipes) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.likes, likes) || other.likes == likes));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      const DeepCollectionEquality().hash(_recipeIds),
      const DeepCollectionEquality().hash(_recipes),
      createdBy,
      likes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RecipeBookImplCopyWith<_$RecipeBookImpl> get copyWith =>
      __$$RecipeBookImplCopyWithImpl<_$RecipeBookImpl>(this, _$identity);
}

abstract class _RecipeBook extends RecipeBook {
  const factory _RecipeBook(
      {final String? id,
      final String? name,
      final String? description,
      final List<String>? recipeIds,
      final List<dynamic>? recipes,
      final String? createdBy,
      final int? likes}) = _$RecipeBookImpl;
  const _RecipeBook._() : super._();

  @override
  String? get id;
  @override
  String? get name;
  @override
  String? get description;
  @override
  List<String>? get recipeIds;
  @override
  List<dynamic>? get recipes;
  @override
  String? get createdBy;
  @override
  int? get likes;
  @override
  @JsonKey(ignore: true)
  _$$RecipeBookImplCopyWith<_$RecipeBookImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
