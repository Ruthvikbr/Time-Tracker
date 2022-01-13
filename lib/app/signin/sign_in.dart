import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/components/customSignInButton.dart';
import 'package:time_tracker/app/components/customSocialSignInButton.dart';
import 'package:time_tracker/app/signin/email_sign_in_page.dart';
import 'package:time_tracker/services/auth.dart';

class SignInPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Tracker"),
        elevation: 4.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Sign In",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(
            height: 48.0,
          ),
          CustomSocialSignInButton(
            text: "Sign in with Google",
            assetName: "images/google-logo.png",
            color: Colors.white,
            textColor: Colors.black87,
            onPressed:() => _signInWithGoogle(context),
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
            onPressed: () => _signInWithEmail(context),
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
            onPressed: () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  void _signInWithEmail(BuildContext context) {

    Navigator.of(context).push(MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context) => EmailSignIn()));
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context,listen: false);
      await auth.signInWithGoogle();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context,listen: false);
      await auth.signInAnonymously();
    } catch (e) {
      print(e.toString());
    }
  }
}
