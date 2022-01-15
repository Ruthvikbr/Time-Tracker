import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/bloc/sign_in_bloc.dart';
import 'package:time_tracker/app/components/customSignInButton.dart';
import 'package:time_tracker/app/components/customSocialSignInButton.dart';
import 'package:time_tracker/app/components/showExceptionAlertDialog.dart';
import 'package:time_tracker/app/signin/email_sign_in_page.dart';
import 'package:time_tracker/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key, required this.bloc}) : super(key: key);
  final SignInBloc bloc;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<SignInBloc>(
      create: (_) => SignInBloc(auth: auth),
      dispose: (_, bloc) => bloc.dispose(),
      child: Consumer<SignInBloc>(
        builder: (_, bloc, __) => SignInPage(bloc: bloc),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Tracker"),
        elevation: 4.0,
      ),
      body: StreamBuilder<bool>(
          stream: bloc.isLoadingStream,
          initialData: false,
          builder: (context, snapshot) {
            return _buildContent(context, snapshot.data);
          }),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context, bool? isLoading) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            child: _buildHeader(isLoading),
            height: 50.0,
          ),
          SizedBox(
            height: 48.0,
          ),
          CustomSocialSignInButton(
            text: "Sign in with Google",
            assetName: "images/google-logo.png",
            color: Colors.white,
            textColor: Colors.black87,
            onPressed: isLoading != null && isLoading
                ? null
                : () => _signInWithGoogle(context),
          ),
          // SizedBox(
          //   height: 8.0,
          // ),
          // CustomSocialSignInButton(
          //   text: "Sign in with Facebook",
          //   assetName: "images/facebook-logo.png",
          //   color: Color(0xFF334D92),
          //   textColor: Colors.white,
          //   onPressed: _signInFacebook,
          // ),
          SizedBox(
            height: 8.0,
          ),
          CustomSignInButton(
            text: "Sign in with email",
            color: Colors.teal[700],
            textColor: Colors.white,
            onPressed: isLoading != null && isLoading
                ? null
                : () => _signInWithEmail(context),
          ),
          SizedBox(
            height: 8.0,
          ),
          Text(
            "or",
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 8.0,
          ),
          CustomSignInButton(
            text: "Go Anonymous",
            color: Colors.lime[300],
            textColor: Colors.black,
            onPressed: isLoading != null && isLoading
                ? null
                : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute<void>(
        fullscreenDialog: true, builder: (context) => EmailSignIn()));
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code != "ERROR_ABORTED_BY_USER") {
      showExceptionAlertDialog(context,
          title: "Sign in failed", exception: exception);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await bloc.signInWithGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await bloc.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Widget _buildHeader(bool? isLoading) {
    if (isLoading != null && isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Text(
        "Sign In",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 32.0,
          fontWeight: FontWeight.w600,
        ),
      );
    }
  }
}
