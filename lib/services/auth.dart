import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthBase {
  User? get currentUser;

  Future<User?> signInAnonymously();

  Future<void> signOut();

  Stream<User?> authStateChanges();
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
      await _firebaseAuthInstance.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
