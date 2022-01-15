import 'package:flutter/material.dart';
import 'package:time_tracker/app/components/emailSignInForm.dart';

class EmailSignIn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        elevation: 4.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: EmailSignInForm.create(context),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: true,
    );
  }
}
