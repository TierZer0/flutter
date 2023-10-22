import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/general/card.custom.dart';
import 'package:ui/general/text.custom.dart';
import 'package:ui/layout/responsive-widget.custom.dart';
import 'package:weather_zero/main.dart';
import 'package:weather_zero/models/weather_response.model.dart';
import 'package:weather_zero/services/weatherkit.service.dart';
import 'package:weather_zero/states/app.state.dart';
import 'package:weather_zero/states/app.state.model.dart';
import 'package:weather_zero/states/weather.state.dart';
import 'package:weather_zero/utils/conversions.util.dart';

class WeatherPage extends ConsumerStatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WeatherPageState();
}

class _WeatherPageState extends ConsumerState<WeatherPage> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktopScreen: buildDesktop(context),
      mobileScreen: buildMobile(context),
    );
  }

  Future _showSettingsSheet(BuildContext context, StateController<AppState> appState) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * .3,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 20.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 30.0,
                ),
                child: CText(
                  'Units',
                  textLevel: EText.title,
                ),
              ),
              Wrap(
                children: [
                  ListTile(
                    title: const CText(
                      'Metric',
                      textLevel: EText.subtitle,
                    ),
                    leading: Radio(
                      value: appState.state.units,
                      groupValue: Units.metric,
                      onChanged: (Units? value) {},
                    ),
                    onTap: () {
                      appState.state.setUnits(Units.metric);
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const CText(
                      'Imperial',
                      textLevel: EText.subtitle,
                    ),
                    leading: Radio(
                      value: appState.state.units,
                      groupValue: Units.imperial,
                      onChanged: (Units? value) {},
                    ),
                    onTap: () {
                      appState.state.setUnits(Units.imperial);
                      Navigator.pop(context);
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
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
    return Consumer(
      builder: (context, ref, child) {
        final StateController<AppState> appState = ref.watch(appStateProvider.notifier);
        final AsyncValue<IWeatherResponse> weatherRequest = ref.watch(weatherProvider);

        return SizedBox(
          child: switch (weatherRequest) {
            AsyncData(:final value) => Scaffold(
                body: Stack(
                  children: [
                    Positioned(child: Container(color: Colors.cyan)),
                    Positioned(
                      child: CustomScrollView(
                        slivers: [
                          SliverAppBar(
                            pinned: false,
                            backgroundColor: Colors.transparent,
                            expandedHeight: MediaQuery.of(context).size.height * .4,
                            // elevation: 10,
                            flexibleSpace: FlexibleSpaceBar(
                              title: CText(
                                appState.state.units == Units.metric
                                    ? '${cleanCelcius(value.currentWeather.temperature)} \u2103'
                                    : '${celciusToFahrenheit(value.currentWeather.temperature)} \u2109',
                                textLevel: EText.title,
                              ),
                            ),
                            actions: [
                              IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.location_city,
                                  size: 35,
                                ),
                              ),
                              IconButton(
                                onPressed: () => _showSettingsSheet(
                                  context,
                                  appState,
                                ).then((value) => setState(() {})),
                                icon: const Icon(
                                  Icons.settings,
                                  size: 35,
                                ),
                              ),
                            ],
                          ),
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CustomCard(
                                    card: ECard.elevated,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {});
                                      },
                                      child: SizedBox(
                                        height: 400,
                                        child: Column(
                                          children: [
                                            CText(
                                              // 'test',
                                              value.currentWeather.asOf.toString(),
                                              textLevel: EText.title,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: 4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            AsyncError(:final error) => Center(child: Text(error.toString())),
            _ => const Center(child: CircularProgressIndicator()),
          },
        );
      },
    );
  }
}
