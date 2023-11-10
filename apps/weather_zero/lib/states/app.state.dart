import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weather_zero/states/app.state.model.dart';

class AppState extends StateNotifier<AppStateModel> {
  AppState() : super(AppStateModel.initial());

  AppStateModel _prevState = AppStateModel.initial();

  void updateLocale({
    required double latitude,
    required double longitude,
  }) {
    setPrevState();
    state = state.copyWith(
      locale: LocaleModel(
        latitude: latitude,
        longitude: longitude,
      ),
    );
  }

  AppStateModel get currState => state;
  AppStateModel get prevState => _prevState;

  setPrevState() {
    _prevState = currState;
  }

  void setUnits(Units units) {
    setPrevState();
    state = state.copyWith(units: units);
  }

  void reset() {
    state = AppStateModel.initial();
  }

  get latitude => state.locale.latitude;
  get longitude => state.locale.longitude;
  Units get units => state.units;
}
