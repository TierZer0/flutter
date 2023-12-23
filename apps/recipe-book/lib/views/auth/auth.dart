import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/main.view.dart';
import 'package:recipe_book/pages/community/community.page.dart';
import 'package:recipe_book/providers/auth/providers.dart';
import 'package:recipe_book/views/auth/login.auth.dart';

import 'create-account.auth.dart';

class AuthView extends ConsumerStatefulWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView> {
  bool isLoggedIn = false;
  bool isLoading = false;
  bool isCreatingAccount = false;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        ref.listen(authNotifierProvider, (previous, next) {
          next.maybeWhen(
            orElse: () {
              print('here');
            },
            loading: () {
              print('loading');
              setState(() {
                isLoading = true;
              });
            },
            authenticated: (user) {
              print('here');
              setState(() {
                isLoggedIn = true;
              });
            },
            unauthenticated: (message) {
              print('unauthenticated');
              setState(() {
                isLoggedIn = false;
                isLoading = false;
              });
            },
          );
        });

        if (isLoggedIn) {
          return MainView();
        } else if (isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (isCreatingAccount) {
          return AuthCreateAccountView();
        } else {
          return AuthLoginView(
            triggerCreateAccount: () {
              setState(() {
                isCreatingAccount = true;
              });
            },
          );
        }
      },
    );
  }
}
