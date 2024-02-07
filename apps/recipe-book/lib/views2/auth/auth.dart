import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:recipe_book/main.page.dart';
import 'package:recipe_book/main.view.dart';
import 'package:recipe_book/pages2/community/community.page.dart';
import 'package:recipe_book/providers/auth/providers.dart';
import 'package:recipe_book/views2/auth/login.auth.dart';

import 'create-account.auth.dart';

enum AuthViewRoutes {
  login,
  createAccount,
}

class AuthView extends ConsumerStatefulWidget {
  final AuthViewRoutes? route;

  const AuthView({Key? key, this.route}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AuthViewState();
}

class _AuthViewState extends ConsumerState<AuthView> {
  bool isLoggedIn = false;
  bool isLoading = false;
  bool isCreatingAccount = false;

  @override
  void initState() {
    super.initState();

    setState(() {
      switch (widget.route) {
        case AuthViewRoutes.login:
          isCreatingAccount = false;
          break;
        case AuthViewRoutes.createAccount:
          isCreatingAccount = true;
          break;
        default:
          isCreatingAccount = false;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget? child) {
        ref.listen(authNotifierProvider, (previous, next) {
          next.maybeWhen(
            orElse: () {},
            loading: () {
              setState(() {
                isLoading = true;
              });
            },
            authenticated: (user) {
              setState(() {
                isLoggedIn = true;
              });
            },
            unauthenticated: (message) {
              setState(() {
                isLoggedIn = false;
                isLoading = false;
              });
            },
          );
        });

        if (isLoggedIn) {
          // return MainView();
          return MainPage();
        } else if (isLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (isCreatingAccount) {
          return AuthCreateAccountView();
        } else {
          return AuthLoginView(
            triggerCreateAccount: () {
              context.push('/createAccount');
            },
          );
        }
      },
    );
  }
}
