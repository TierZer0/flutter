import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ui/general/card.custom.dart';
import 'package:ui/general/text.custom.dart';
import 'package:ui/layout/responsive-widget.custom.dart';

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
      body: Stack(
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
                  flexibleSpace: const FlexibleSpaceBar(
                    title: CText(
                      'Weather Zero',
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
                          child: Container(
                            height: 400,
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
    );
  }
}
