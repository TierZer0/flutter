import 'package:flutter/material.dart';
import 'package:ui/general/text.custom.dart';

enum ELogging { error, info, success, update }

class ISnackbar {
  final ELogging type;
  final String message;
  final String? actionLabel;
  final Function? actionOnPressed;
  final Duration? duration;

  ISnackbar({
    required this.type,
    required this.message,
    this.actionLabel,
    this.actionOnPressed,
    this.duration,
  });
}

class LoggingService {
  // post to an error collection
  sendErrorReport(String error) {}

  triggerSnackbar(BuildContext context, ISnackbar snackbar) async {
    final colorScheme = Theme.of(context).colorScheme;

    Color color;
    Color backgroundColor;
    IconData icon;
    switch (snackbar.type) {
      case ELogging.error:
        color = colorScheme.onError;
        backgroundColor = colorScheme.error;
        icon = Icons.error;
        break;
      case ELogging.info:
        color = Colors.black;
        backgroundColor = Color(0xFFA0C1D1);
        icon = Icons.info;
        break;
      case ELogging.success:
        color = Colors.white;
        backgroundColor = Color(0xFF3BB273);
        icon = Icons.check;
        break;
      case ELogging.update:
        color = Colors.white;
        backgroundColor = Color(0xFF4D9DE0);
        icon = Icons.update;
        break;
      default:
        color = colorScheme.onBackground;
        backgroundColor = Color(0xFFA0C1D1);
        icon = Icons.info;
        break;
    }

    final width = MediaQuery.of(context).size.width;

    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        action: snackbar.actionLabel != null
            ? SnackBarAction(
                label: snackbar.actionLabel!,
                onPressed: () => snackbar.actionOnPressed,
              )
            : null,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Icon(
                icon,
                size: 35,
                color: color,
              ),
            ),
            SizedBox(width: 10.0),
            Expanded(
              flex: 8,
              child: CText(
                snackbar.message,
                textLevel: EText.custom,
                textStyle: TextStyle(color: color, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        duration: Duration(milliseconds: snackbar.type == ELogging.error ? 2500 : 1500),
        width: width > 1200 ? width * .35 : width * .9,
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }
}

final LoggingService loggingService = LoggingService();
