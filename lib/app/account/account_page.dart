import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/components/avatar.dart';
import 'package:time_tracker/app/components/showAlertDialog.dart';
import 'package:time_tracker/services/auth.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
      title: Text("Account"),
      actions: <Widget>[
        TextButton(
          child: Text(
            "Logout",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
            ),
          ),
          onPressed: () => _confirmSignOut(context),
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(130.0),
        child: _buildContent(auth.currentUser),
      ),
    ));
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final didRequestSignOut = await showAlertDialog(context,
        title: "Logout",
        content: "Are you sure you want to logout?",
        defaultActionText: "Confirm",
        cancelActionText: "Cancel");
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  Widget _buildContent(User? currentUser) {
    return Column(
      children: [
        Avatar(photoUrl: currentUser!.photoURL, radius: 50.0),
        SizedBox(
          height: 8,
        ),
        if (currentUser.displayName != null)
          Text(
            currentUser.displayName ?? "",
            style: TextStyle(color: Colors.white),
          ),
      ],
    );
  }
}
