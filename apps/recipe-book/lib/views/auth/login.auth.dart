import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/providers/auth/providers.dart';

class AuthLoginView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Column(
        children: [
          Text('In AuthLoginView'),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(authNotifierProvider.notifier)
                  .dataSource
                  .login(email: 'test', password: 'test');
            },
            child: Text('Sign in with Google'),
          ),
        ],
      ),
    );
  }
}
