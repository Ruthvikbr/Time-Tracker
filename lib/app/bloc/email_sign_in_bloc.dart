import 'dart:async';
import 'package:time_tracker/app/model/email_sign_in_model.dart';
import 'package:time_tracker/services/auth.dart';

class EmailSignInBloc {
  EmailSignInBloc({required this.auth});

  final AuthBase auth;

  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();

  Stream<EmailSignInModel> get modelStream => _modelController.stream;

  EmailSignInModel _model = EmailSignInModel();

  void dispose() {
    _modelController.close();
  }

  void updatePassword(String password) => updateWith(password: password);

  void updateEmail(String email) => updateWith(email: email);

  void toggleFormType() {
    EmailSignInFormType formType =
        _model.emailSignInFormType == EmailSignInFormType.signIn
            ? EmailSignInFormType.signUp
            : EmailSignInFormType.signIn;
    updateWith(
      submitted: false,
      loading: false,
      email: "",
      password: "",
      formType: formType,
    );
  }

  void updateWith({
    String? email,
    String? password,
    EmailSignInFormType? formType,
    bool? loading,
    bool? submitted,
  }) {
    _model = _model.copyWith(
      email: email,
      password: password,
      emailSignInFormType: formType,
      loading: loading,
      submitted: submitted,
    );
    _modelController.add(_model);
  }

  Future<void> submit() async {
    updateWith(loading: true, submitted: true);
    try {
      if (_model.emailSignInFormType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createUserWithEmailAndPassword(
            _model.email, _model.password);
      }
    } catch (e) {
      updateWith(loading: false);
      rethrow;
    }
  }
}
