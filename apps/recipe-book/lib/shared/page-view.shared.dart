// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ui/general/text.custom.dart';
import 'package:ui/layout/responsive-widget.custom.dart';

class PageViewShared extends StatelessWidget {
  String? title;
  Widget? titleWidget;
  String? subtitle;
  Widget? subtitleWidget;
  String? image;
  Widget? imageWidget;
  String? body;
  Widget? bodyWidget;

  Widget spacingWidget;

  PageViewShared({
    super.key,
    this.title,
    this.titleWidget,
    this.subtitle,
    this.subtitleWidget,
    this.image,
    this.imageWidget,
    this.body,
    this.bodyWidget,
    this.spacingWidget = const SizedBox.shrink(),
  }) {
    if (titleWidget == null && title != null) {
      titleWidget = CText(
        title!,
        textLevel: EText.custom,
        textStyle: TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      );
    } else if (titleWidget == null && title == null) {
      throw ErrorWidget(
          "[PageViewShared] titleWidget and title cannot both be null");
    }
    if (subtitleWidget == null && subtitle != null) {
      subtitleWidget = CText(
        subtitle!,
        textLevel: EText.title2,
      );
    } else if (subtitleWidget == null && subtitle == null) {
      throw ErrorWidget(
          "[PageViewShared] subtitleWidget and subtitle cannot both be null");
    }
    if (bodyWidget == null && body != null) {
      bodyWidget = CText(
        body!,
        textLevel: EText.body,
      );
    } else if (bodyWidget == null && body == null) {
      throw ErrorWidget(
          "[PageViewShared] bodyWidget and body cannot both be null");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      desktopScreen: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 0.0,
        ),
        child: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageWidget ?? SizedBox.shrink(),
              spacingWidget,
              titleWidget!,
              subtitleWidget!,
              spacingWidget,
              bodyWidget!,
            ],
          ),
        ),
      ),
      mobileScreen: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30.0,
          ),
          child: Wrap(
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            runSpacing: 15.0,
            children: [
              imageWidget ?? SizedBox.shrink(),
              spacingWidget,
              titleWidget!,
              subtitleWidget!,
              spacingWidget,
              bodyWidget!,
            ],
          ),
        ),
      ),
    );
  }
}
