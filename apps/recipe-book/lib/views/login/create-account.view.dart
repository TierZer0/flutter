import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:ui/layout/responsive-widget.custom.dart';
import 'package:ui/ui.dart';

class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktopScreen: buildDesktop(context),
      mobileScreen: buildMobile(context),
    );
  }

  Widget buildDesktop(BuildContext context) {
    return Container();
  }

  Widget buildMobile(BuildContext context) {
    final controller = PageController(viewportFraction: 1, keepPage: true);
    var theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: PageView(
              controller: controller,
              children: [
                Container(
                  height: 125,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/recipebook-logo.png"),
                    ),
                  ),
                ),
                Container(
                  height: 75,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/tierzero-dark.png"),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: SmoothPageIndicator(
              controller: controller,
              count: 3,
              effect: ExpandingDotsEffect(
                activeDotColor: theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
      // body: IntroductionScreen(
      //   onDone: () => {},
      //   back: const Icon(Icons.arrow_back),
      //   skip: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
      //   next: const Icon(Icons.arrow_forward),
      //   done: const Text('Done', style: TextStyle(fontWeight: FontWeight.w600)),
      //   pages: [
      //     PageViewModel(
      //       // title: "Welcome To Livre de Recettes, a community Recipe Book",
      //       image: Wrap(
      //         runSpacing: 50,
      //         children: [
      //           Container(
      //             height: 125,
      //             width: MediaQuery.of(context).size.width,
      //             decoration: BoxDecoration(
      //               image: DecorationImage(
      //                 image: AssetImage("assets/recipebook-logo.png"),
      //               ),
      //             ),
      //           ),
      //           Container(
      //             height: 75,
      //             width: MediaQuery.of(context).size.width,
      //             decoration: BoxDecoration(
      //               image: DecorationImage(
      //                 image: AssetImage("assets/tierzero-dark.png"),
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //       title: 'Welcome, thank you for joining us!',
      //       body: "Create account and setup to start creating and share your recipes",
      //       decoration: const PageDecoration(
      //         pageColor: Colors.transparent,
      //       ),
      //     ),
      //     PageViewModel(
      //       // title: "Welcome To Livre de Recettes, a community Recipe Book",
      //       image: Wrap(
      //         runSpacing: 50,
      //         children: [
      //           Container(
      //             height: 125,
      //             width: MediaQuery.of(context).size.width,
      //             decoration: BoxDecoration(
      //               image: DecorationImage(
      //                 image: AssetImage("assets/recipebook-logo.png"),
      //               ),
      //             ),
      //           ),
      //           Container(
      //             height: 75,
      //             width: MediaQuery.of(context).size.width,
      //             decoration: BoxDecoration(
      //               image: DecorationImage(
      //                 image: AssetImage("assets/tierzero-dark.png"),
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //       title: 'Welcome, thank you for joining us!',
      //       body: "Create account and setup to start creating and share your recipes",
      //       decoration: const PageDecoration(
      //         pageColor: Colors.transparent,
      //       ),
      //     ),
      //     PageViewModel(
      //       // title: "Welcome To Livre de Recettes, a community Recipe Book",
      //       image: Wrap(
      //         runSpacing: 50,
      //         children: [
      //           Container(
      //             height: 125,
      //             width: MediaQuery.of(context).size.width,
      //             decoration: BoxDecoration(
      //               image: DecorationImage(
      //                 image: AssetImage("assets/recipebook-logo.png"),
      //               ),
      //             ),
      //           ),
      //           Container(
      //             height: 75,
      //             width: MediaQuery.of(context).size.width,
      //             decoration: BoxDecoration(
      //               image: DecorationImage(
      //                 image: AssetImage("assets/tierzero-dark.png"),
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
      //       title: 'Welcome, thank you for joining us!',
      //       body: "Create account and setup to start creating and share your recipes",
      //       decoration: const PageDecoration(
      //         pageColor: Colors.transparent,
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
