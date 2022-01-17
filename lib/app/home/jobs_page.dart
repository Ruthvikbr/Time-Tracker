import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/app/components/jobListTile.dart';
import 'package:time_tracker/app/components/listItemsBuilder.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/components/showExceptionAlertDialog.dart';
import 'package:time_tracker/app/home/add_or_edit_job_page.dart';
import 'package:time_tracker/app/home/job_entries/job_entries_page.dart';
import 'package:time_tracker/app/model/job.dart';
import 'package:time_tracker/services/database.dart';

class JobsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Jobs"),
        actions: <Widget>[
          IconButton(
            onPressed: () => AddOrEditJobPage.navigate(
              context: context,
              job: null,
              database: Provider.of<Database>(context, listen: false),
            ),
            icon: Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Job>>(
      stream: database.jobStreams(),
      builder: (context, snapshot) {
        return ListItemBuilder<Job>(
            snapshot: snapshot,
            itemWidgetBuilder: (context, job) => Dismissible(
                  background: Container(
                    color: Colors.red,
                  ),
                  direction: DismissDirection.endToStart,
                  key: Key('job-${job.id}'),
                  onDismissed: (direction) => _deleteJob(context, job),
                  child: JobListTile(
                    job: job,
                    onPress: () => JobEntriesPage.show(context, job),
                  ),
                ));
      },
    );
  }

  Future<void> _deleteJob(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: "Something went wrong",
        exception: e,
      );
    }
  }
}
