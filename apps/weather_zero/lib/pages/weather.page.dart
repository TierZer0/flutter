import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/general/card.custom.dart';
import 'package:ui/general/text.custom.dart';
import 'package:ui/layout/responsive-widget.custom.dart';
import 'package:weather_zero/models/weather_response.model.dart';
import 'package:weather_zero/services/weatherkit.service.dart';
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
    return Scaffold(
      body: FutureBuilder(
          future: weatherKitSerivce.getWeather(37.8267, -122.4233, 'America/Chicago'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              IWeatherResponse weather = snapshot.data!;
              return Stack(
                children: [
                  Positioned(child: Container(color: Colors.black26)),
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
                              celciusToFahrenheit(weather.currentWeather.temperature).toString() +
                                  ' \u2109',
                              textLevel: EText.title,
                            ),
                          ),
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
                                    child: Container(
                                      height: 400,
                                      child: Column(
                                        children: [
                                          CText(
                                            // 'test',
                                            weather.currentWeather.asOf.toString(),
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
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: CText(
                  snapshot.error.toString(),
                  textLevel: EText.title,
                ),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
