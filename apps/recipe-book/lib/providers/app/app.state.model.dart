class AppStateModel {
  final bool darkMode;
  final String lastRoute;

  AppStateModel({
    required this.darkMode,
    required this.lastRoute,
  });

  factory AppStateModel.initial() {
    return AppStateModel(
      darkMode: false,
      lastRoute: '/',
    );
  }

  AppStateModel copyWith({
    bool? darkMode,
    String? lastRoute,
  }) {
    return AppStateModel(
      darkMode: darkMode ?? this.darkMode,
      lastRoute: lastRoute ?? this.lastRoute,
    );
  }
}
