import 'package:flutter/material.dart';
import 'package:time_tracker/app/model/job.dart';

class JobListTile extends StatelessWidget {
  const JobListTile({
    Key? key,
    required this.job,
    required this.onPress,
  }) : super(key: key);

  final Job job;
  final VoidCallback onPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(job.name),
      trailing: Icon(Icons.chevron_right),
      onTap: onPress,
    );
  }
}
