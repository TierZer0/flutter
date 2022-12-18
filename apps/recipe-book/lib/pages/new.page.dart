import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book/app_model.dart';
import 'package:recipe_book/styles.dart';
import 'package:ui/ui.dart';

class NewPage extends StatefulWidget {
  const NewPage({super.key});

  @override
  NewPageState createState() => NewPageState();
}

class NewPageState extends State<NewPage> {
  @override
  void initState() {
    super.initState();
  }

  int _stepIndex = 0;
  final GlobalKey<FormState> _formDetails = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final appModel = Provider.of<AppModel>(context);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        title: CustomText(
          text: "Create A New Recipe",
          fontSize: 25.0,
          fontWeight: FontWeight.w500,
          color: (theme.textTheme.titleLarge?.color)!,
        ),
        leading: CustomIconButton(
          icon: const Icon(
            Icons.arrow_back_outlined,
            size: 30,
          ),
          onPressed: () => context.go('/'),
          color: (theme.textTheme.titleLarge?.color)!,
        ),
      ),
      body: Container(
        color: theme.scaffoldBackgroundColor,
        child: SingleChildScrollView(
          child: Stepper(
            currentStep: _stepIndex,
            onStepCancel: () {
              if (_stepIndex > 0) {
                setState(() {
                  _stepIndex -= 1;
                });
              }
            },
            onStepContinue: () {
              if (_stepIndex <= 0) {
                setState(() {
                  _stepIndex -= 1;
                });
              }
            },
            steps: [
              Step(
                title: CustomText(
                  text: "Details",
                  fontSize: 20.0,
                  fontFamily: "Lato",
                  color: (theme.textTheme.titleLarge?.color)!,
                ),
                content: Container(
                  child: Form(
                    key: _formDetails,
                    child: Column(
                      children: [],
                    ),
                  ),
                ),
              ),
              Step(
                title: const Text(
                  'Ingredients',
                ),
                content: Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
