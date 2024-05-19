// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resources.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Resources {
  List<String> get units => throw _privateConstructorUsedError;
  List<Categories> get categories => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ResourcesCopyWith<Resources> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResourcesCopyWith<$Res> {
  factory $ResourcesCopyWith(Resources value, $Res Function(Resources) then) =
      _$ResourcesCopyWithImpl<$Res, Resources>;
  @useResult
  $Res call({List<String> units, List<Categories> categories});
}

/// @nodoc
class _$ResourcesCopyWithImpl<$Res, $Val extends Resources>
    implements $ResourcesCopyWith<$Res> {
  _$ResourcesCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? units = null,
    Object? categories = null,
  }) {
    return _then(_value.copyWith(
      units: null == units
          ? _value.units
          : units // ignore: cast_nullable_to_non_nullable
              as List<String>,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Categories>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ResourcesImplCopyWith<$Res>
    implements $ResourcesCopyWith<$Res> {
  factory _$$ResourcesImplCopyWith(
          _$ResourcesImpl value, $Res Function(_$ResourcesImpl) then) =
      __$$ResourcesImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<String> units, List<Categories> categories});
}

/// @nodoc
class __$$ResourcesImplCopyWithImpl<$Res>
    extends _$ResourcesCopyWithImpl<$Res, _$ResourcesImpl>
    implements _$$ResourcesImplCopyWith<$Res> {
  __$$ResourcesImplCopyWithImpl(
      _$ResourcesImpl _value, $Res Function(_$ResourcesImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? units = null,
    Object? categories = null,
  }) {
    return _then(_$ResourcesImpl(
      units: null == units
          ? _value._units
          : units // ignore: cast_nullable_to_non_nullable
              as List<String>,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<Categories>,
    ));
  }
}

/// @nodoc

class _$ResourcesImpl extends _Resources {
  const _$ResourcesImpl(
      {required final List<String> units,
      required final List<Categories> categories})
      : _units = units,
        _categories = categories,
        super._();

  final List<String> _units;
  @override
  List<String> get units {
    if (_units is EqualUnmodifiableListView) return _units;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_units);
  }

  final List<Categories> _categories;
  @override
  List<Categories> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  @override
  String toString() {
    return 'Resources(units: $units, categories: $categories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResourcesImpl &&
            const DeepCollectionEquality().equals(other._units, _units) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_units),
      const DeepCollectionEquality().hash(_categories));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResourcesImplCopyWith<_$ResourcesImpl> get copyWith =>
      __$$ResourcesImplCopyWithImpl<_$ResourcesImpl>(this, _$identity);
}

abstract class _Resources extends Resources {
  const factory _Resources(
      {required final List<String> units,
      required final List<Categories> categories}) = _$ResourcesImpl;
  const _Resources._() : super._();

  @override
  List<String> get units;
  @override
  List<Categories> get categories;
  @override
  @JsonKey(ignore: true)
  _$$ResourcesImplCopyWith<_$ResourcesImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
