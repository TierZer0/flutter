import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:recipe_book/providers/auth/auth.datasource.dart';
import 'package:recipe_book/providers/auth/auth.state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthDataSource dataSource;

  AuthNotifier(this.dataSource) : super(const AuthState.initial());
}
