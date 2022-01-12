
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer';

abstract class AuthBase {
  User? get currentUser;

  Future<User?> signInAnonymously();

  Future<void> signOut();

  Stream<User?> authStateChanges();

  Future<User?> signInWithGoogle();
}

class Auth implements AuthBase {
  final _firebaseAuthInstance = FirebaseAuth.instance;

  @override
  Stream<User?> authStateChanges() => _firebaseAuthInstance.authStateChanges();

  @override
  User? get currentUser => _firebaseAuthInstance.currentUser;

  @override
  Future<User?> signInAnonymously() async {
    try {
      final userCredentials = await _firebaseAuthInstance.signInAnonymously();
      return userCredentials.user;
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await GoogleSignIn().signOut();
      await _firebaseAuthInstance.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;
      if (googleAuth?.idToken != null) {
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        final userCredential =
            await _firebaseAuthInstance.signInWithCredential(credential);
        return userCredential.user;
      } else {
        log("failed");
        throw FirebaseAuthException(
          code: 'ERROR_MISSING_GOOGLE_ID_TOKEN',
          message: "Missing Google Id Token",
        );
      }
    } else {
      log("failed");
      throw FirebaseAuthException(
        code: 'ERROR_ABORTED_BY_USER',
        message: "Sign in aborted by user",
      );
    }
  }
}
