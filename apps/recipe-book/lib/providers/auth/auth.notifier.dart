import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:recipe_book/preferences/app_preferences.dart';

import 'package:recipe_book/providers/auth/auth.datasource.dart';
import 'package:recipe_book/providers/auth/auth.state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthDataSource dataSource;

  AuthNotifier(this.dataSource) : super(const AuthState.initial());

  final LocalAuthentication _localAuthentication = LocalAuthentication();
  final AppPreferences appPreferences = AppPreferences();

  Future<void> checkAuth() async {
    // state = const AuthState.loading();

    final uid = await appPreferences.getUserUID();
    final lastLogin = await appPreferences.getLastLogin();

    if (lastLogin == null || uid == '') {
      state = const AuthState.unauthenticated();
      return;
    }

    final lastLoginDate = DateTime.fromMillisecondsSinceEpoch(lastLogin);
    final currDate = DateTime.now();
    final diff = currDate.difference(lastLoginDate).inDays;

    if (diff > 10) {
      state = const AuthState.unauthenticated();
      appPreferences.setUserUID('');
      appPreferences.setLastLogin(0);
      return;
    }

    final bool canAuthenticateWithBiometrics = await _localAuthentication.canCheckBiometrics;
    final bool canAuthenticate = canAuthenticateWithBiometrics || await _localAuthentication.isDeviceSupported();

    if (canAuthenticate) {
      final isAuthenticated = await _localAuthentication.authenticate(
        localizedReason: 'Please authenticate to continue',
      );

      if (isAuthenticated) {
        _setAppPreferencesLogin(FirebaseAuth.instance.currentUser!);
        state = AuthState.authenticated(user: FirebaseAuth.instance.currentUser!);
      } else {
        state = const AuthState.unauthenticated();
      }
    } else {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = const AuthState.loading();
    final response = await dataSource.login(email: email, password: password);
    response.fold(
      (error) => state = AuthState.unauthenticated(message: error),
      (response) {
        _setAppPreferencesLogin(response!);
        return state = AuthState.authenticated(user: response);
      },
    );
  }

  Future<void> signup({required String email, required String password}) async {
    state = const AuthState.loading();
    final response = await dataSource.signup(email: email, password: password);
    response.fold(
      (error) => state = AuthState.unauthenticated(message: error),
      (response) {
        _setAppPreferencesLogin(response);
        return state = AuthState.authenticated(user: response);
      },
    );
  }

  Future<void> continueWithGoogle() async {
    state = const AuthState.loading();
    final response = await dataSource.continueWithGoogle();
    response.fold(
      (error) => state = AuthState.unauthenticated(message: error),
      (response) {
        _setAppPreferencesLogin(response);
        return state = AuthState.authenticated(user: response);
      },
    );
  }

  void _setAppPreferencesLogin(User user) {
    appPreferences.setUserUID(user.uid);
    appPreferences.setLastLogin(DateTime.now().millisecondsSinceEpoch);
  }

  // Future<void> logout() async {
  //   state = const AuthState.loading();
  //   final response = await dataSource.logout();
  //   response.fold(
  //     (error) => state = AuthState.unauthenticated(message: error),
  //     (response) => state = const AuthState.unauthenticated(),
  //   );
  // }
}
