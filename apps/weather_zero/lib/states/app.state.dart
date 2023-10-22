import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_zero/states/app.state.model.dart';

class AppState extends StateNotifier<AppStateModel> {
  AppState() : super(AppStateModel.initial());

  void updateLocale({
    required double latitude,
    required double longitude,
  }) {
    state = state.copyWith(
      locale: LocaleModel(
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }

  void setUnits(Units units) {
    state = state.copyWith(units: units);
  }

  void reset() {
    state = AppStateModel.initial();
  }

  get latitude => state.locale.latitude;
  get longitude => state.locale.longitude;
  Units get units => state.units;
}
