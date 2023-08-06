// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:ui/general/text.custom.dart';

class PageViewShared extends StatelessWidget {
  String? title;
  Widget? titleWidget;
  String? subtitle;
  Widget? subtitleWidget;
  String? image;
  Widget? imageWidget;
  String? body;
  Widget? bodyWidget;

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

    // if (imageWidget == null && image != null) {
    //   imageWidget = Image.asset(image!);
    // } else if (imageWidget == null && image == null) {
    //   throw ErrorWidget(
    //       "[PageViewShared] imageWidget and image cannot both be null");
    // }
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
    return Center(
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
            titleWidget!,
            subtitleWidget!,
            bodyWidget!,
          ],
        ),
      ),
    );
  }
}
