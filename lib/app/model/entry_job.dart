

import 'package:time_tracker/app/model/entry.dart';
import 'package:time_tracker/app/model/job.dart';

class EntryJob {
  EntryJob(this.entry, this.job);

  final Entry entry;
  final Job job;
}
