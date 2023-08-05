import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:ui/general/text.custom.dart';
import 'package:ui/inputs/reactive-input.custom.dart';

import '../../../app_model.dart';
import '../../../shared/page-view.shared.dart';

class UserSettingsStep extends StatelessWidget {
  const UserSettingsStep({super.key});

  final formGroupName = 'UserSettings';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PageViewShared(
      title: 'Create Your Recipe Book Profile',
      subtitle: 'Fill out your profile information',
      imageWidget: Container(
        height: 75,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/recipebook-logo.png"),
          ),
        ),
      ),
      bodyWidget: Wrap(
        runSpacing: 20,
        children: [
          CustomReactiveInput(
            inputAction: TextInputAction.next,
            formName: '${formGroupName}.Name',
            label: 'Display Name',
            textColor: theme.colorScheme.onBackground,
          ),
          ReactiveSwitchListTile(
            formControlName: '${formGroupName}.DefaultTheme',
            title: CText(
              'Default Theme',
              textLevel: EText.button,
            ),
            subtitle: CText('Light Theme or Dark Theme'),
            activeColor: theme.colorScheme.primary,
            onChanged: (control) {
              control.value = control.value;
              context.read<AppModel>().theme = control.value!;
            },
          ),
        ],
      ),
    );
  }
}
