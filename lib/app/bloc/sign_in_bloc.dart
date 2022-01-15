import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:time_tracker/services/auth.dart';

class SignInBloc {
  SignInBloc({required this.auth});

  final AuthBase auth;

  final StreamController<bool> _isLoadingController = StreamController<bool>();

  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void _setLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User?> _signIn(Future<User?> Function() signInMethod) async {
    try {
      _setLoading(true);
      return await signInMethod();
    } catch (e) {
      _setLoading(false);
      rethrow;
    }
  }

  Future<User?> signInAnonymously() async => await _signIn(auth.signInAnonymously);

  Future<User?> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);


}
