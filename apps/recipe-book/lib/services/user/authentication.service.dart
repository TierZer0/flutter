import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthenticationResult<T> {
  bool success;
  String? message;
  bool newUser;
  T? payload;

  AuthenticationResult(
    this.payload, {
    this.newUser = false,
    required this.success,
    this.message,
  });
}

class _AuthenticationService<T> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<AuthenticationResult<T>> emailSignIn(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // update user collection

      return AuthenticationResult<T>(
        userCredential.user as T,
        success: true,
        message: 'Login Sucessful',
      );
    } on FirebaseAuthException catch (e) {
      return AuthenticationResult<T>(
        null,
        success: false,
        message: e.message,
      );
    }
  }

  Future<AuthenticationResult<T>> createEmailAccount(
      String email, String password) async {
    // implement with new user flow process
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    return AuthenticationResult<T>(
      null,
      newUser: true,
      success: false,
      message: 'Not Implemented',
    );
  }

  Future<AuthenticationResult<T>> googleSSO() async {
    GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleAuth?.idToken,
      accessToken: googleAuth?.accessToken,
    );

    try {
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // update user collection
      final newUser = userCredential.additionalUserInfo?.isNewUser;

      return AuthenticationResult<T>(
        userCredential.user as T,
        success: true,
        newUser: newUser!,
        message: 'Login Sucessful',
      );
    } on FirebaseAuthException catch (e) {
      return AuthenticationResult<T>(
        null,
        success: false,
        newUser: true,
        message: e.message,
      );
    }
  }

  Future<AuthenticationResult<T>> logout() async {
    try {
      await _auth.signOut();
      return AuthenticationResult<T>(
        null,
        success: true,
        message: 'Logout Sucessful',
      );
    } on FirebaseAuthException catch (e) {
      return AuthenticationResult<T>(
        null,
        success: false,
        message: e.message,
      );
    }
  }

  User get user => _auth.currentUser!;
  String get userUid => user.uid;
}

final _AuthenticationService<User> authenticationService =
    _AuthenticationService<User>();
