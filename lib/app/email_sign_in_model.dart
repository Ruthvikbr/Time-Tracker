import 'package:time_tracker/services/validators.dart';

enum EmailSignInFormType { signIn, signUp }

class EmailSignInModel with EmailAndPasswordValidators {
  EmailSignInModel({
    this.email = '',
    this.password = '',
    this.emailSignInFormType = EmailSignInFormType.signIn,
    this.loading = false,
    this.submitted = false,
  });

  final String email;
  final String password;
  final EmailSignInFormType emailSignInFormType;
  final bool loading;
  final bool submitted;

  EmailSignInModel copyWith({
    String? email,
    String? password,
    EmailSignInFormType? emailSignInFormType,
    bool? loading,
    bool? submitted,
  }) {
    return EmailSignInModel(
      email: email ?? this.email,
      password: password ?? this.password,
      emailSignInFormType: emailSignInFormType ?? this.emailSignInFormType,
      loading: loading ?? this.loading,
      submitted: submitted ?? this.submitted,
    );
  }

  String get primaryText {
    return emailSignInFormType == EmailSignInFormType.signIn
        ? "Sign in"
        : "Sign up";
  }

  String get secondaryText {
    return emailSignInFormType == EmailSignInFormType.signIn
        ? "Don't have an account? Register"
        : "Already have an account? Login";
  }

  bool get canSubmit {
    return emailValidator.isValid(email) &&
        passwordValidator.isValid(password) &&
        !loading;
  }

  String? get passwordErrorText {
    return submitted && !passwordValidator.isValid(password)
        ? "Enter a valid password"
        : null;
  }

  String? get emailErrorText {
    return submitted && !emailValidator.isValid(email)
        ? "Enter a valid email"
        : null;
  }
}
