import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/components/listItemsBuilder.dart';
import 'package:time_tracker/app/components/showExceptionAlertDialog.dart';
import 'package:time_tracker/app/home/add_or_edit_job_page.dart';
import 'package:time_tracker/app/home/job_entries/entry_list_item.dart';
import 'package:time_tracker/app/home/job_entries/entry_page.dart';
import 'package:time_tracker/app/model/entry.dart';
import 'package:time_tracker/app/model/job.dart';
import 'package:time_tracker/services/database.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({required this.database, required this.job});

  final Database database;
  final Job job;

  static Future<void> show(BuildContext context, Job job) async {
    final database = Provider.of<Database>(context, listen: false);
    await Navigator.of(context).push(
      CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context) => JobEntriesPage(database: database, job: job),
      ),
    );
  }

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Job>(
        stream: database.jobStream(jobId: job.id),
        builder: (context, snapshot) {
          final jobData = snapshot.data;
          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              centerTitle: true,
              title: Text(jobData?.name ?? ""),
              actions: <Widget>[
                IconButton(
                  onPressed: () => AddOrEditJobPage.navigate(
                    context: context,
                    job: job,
                    database: Provider.of<Database>(context, listen: false),
                  ),
                  icon: Icon(Icons.edit, color: Colors.white),
                ),
                IconButton(
                  onPressed: () => EntryPage.show(
                    context: context,
                    job: job,
                    database: Provider.of<Database>(context, listen: false),
                  ),
                  icon: Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            body: _buildContent(context, jobData ?? job),
          );
        });
  }

  Widget _buildContent(BuildContext context, Job job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job: job),
      builder: (context, snapshot) {
        return ListItemBuilder<Entry>(
          snapshot: snapshot,
          itemWidgetBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => EntryPage.show(
                context: context,
                database: database,
                job: job,
                entry: entry,
              ),
            );
          },
        );
      },
    );
  }
}
