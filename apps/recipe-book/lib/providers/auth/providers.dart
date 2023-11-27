import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:recipe_book/providers/auth/auth.datasource.dart';
import 'package:recipe_book/providers/auth/auth.notifier.dart';
import 'package:recipe_book/providers/auth/auth.state.dart';
import 'package:recipe_book/providers/firebase/firebase.providers.dart';

final authDataSourceProvider = Provider<AuthDataSource>(
  (ref) => AuthDataSource(
    firebaseAuth: ref.read(firebaseAuthProvider),
    ref: ref,
  ),
);

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(
    ref.read(
      authDataSourceProvider,
    ),
  ),
);
