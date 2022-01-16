import 'package:flutter/material.dart';
import 'package:time_tracker/app/components/jobListTile.dart';
import 'package:time_tracker/app/components/showAlertDialog.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/add_or_edit_job_page.dart';
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
        onPressed: () => AddOrEditJobPage.navigate(
          context: context,
          job: null,
        ),
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
              final children = jobs
                  .map((job) => JobListTile(
                        job: job,
                        onPress: () => AddOrEditJobPage.navigate(
                          context: context,
                          job: job,
                        ),
                      ))
                  .toList();
              return ListView(
                children: children,
              );
            } else {
              return Center(
                child: Text("You don't have any open jobs"),
              );
            }
          } else if (snapshot.hasError) {
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
}
