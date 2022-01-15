import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/app/components/showAlertDialog.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/components/showExceptionAlertDialog.dart';
import 'package:time_tracker/app/model/job.dart';
import 'package:time_tracker/services/auth.dart';
import 'package:time_tracker/services/database.dart';

class JobsPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jobs"),
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
          )
        ],
      ),
      body: _buildContents(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _createJob(context),
      ),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
        stream: database.jobStreams(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            final List<Job>? jobs = snapshot.data;
            if (jobs != null) {
              final children = jobs.map((job) => Text(job.name)).toList();
              return ListView(
                children: children,
              );
            } else {
              return Center(
                child: Text("You don't have any open jobs"),
              );
            }
          }else if(snapshot.hasError) {
            return Center(
              child: Text("Something went wrong"),
            );
          } else {
            return Center(
              child: Text("You don't have any open jobs"),
            );
          }
        });
  }

  Future<void> _createJob(BuildContext context) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.createJob(Job(
        name: "Reading",
        ratePerHour: 20,
      ));
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: "Operation failed",
        exception: e,
      );
    }
  }
}
