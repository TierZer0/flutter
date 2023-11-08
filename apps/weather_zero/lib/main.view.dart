import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:location/location.dart';
import 'package:ui/layout/responsive-widget.custom.dart';
import 'package:weather_zero/main.dart';
import 'package:weather_zero/pages/weather.page.dart';
import 'package:weather_zero/states/app.state.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends ConsumerState<MainView> {
  Location location = Location();
  late StateController<AppState> _appState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _appState = ref.watch(appStateProvider.notifier);
    getLocation();
  }

  @override
  void initState() {
    super.initState();
  }

  getLocation() async {
    PermissionStatus permissionGranted;
    LocationData locationData;
    // _serviceEnabled = await location.serviceEnabled();
    // if (!_serviceEnabled) {
    //   _serviceEnabled = await location.requestService();
    //   if (!_serviceEnabled) {
    //     return;
    //   }
    // }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    _appState.state.updateLocale(
      latitude: locationData.latitude!,
      longitude: locationData.longitude!,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktopScreen: buildDesktop(context),
      mobileScreen: buildMobile(context),
    );
  }

  Widget buildDesktop(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.red,
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMobile(BuildContext context) {
    return const WeatherPage();
  }
}
