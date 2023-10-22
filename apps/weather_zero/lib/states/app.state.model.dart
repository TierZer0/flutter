class LocaleModel {
  final double latitude;
  final double longitude;

  LocaleModel({
    required this.latitude,
    required this.longitude,
  });
}

enum Units {
  metric,
  imperial,
}

class AppStateModel {
  final LocaleModel locale;
  final Units units;

  AppStateModel({
    required this.locale,
    required this.units,
  });

  factory AppStateModel.initial() {
    return AppStateModel(
      locale: LocaleModel(
        latitude: 37.8267,
        longitude: -122.4233,
      ),
      units: Units.imperial,
    );
  }

  AppStateModel copyWith({
    LocaleModel? locale,
    Units? units,
  }) {
    return AppStateModel(
      locale: locale ?? this.locale,
      units: units ?? this.units,
    );
  }
}
