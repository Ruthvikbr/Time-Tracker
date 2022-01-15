import 'package:time_tracker/app/model/job.dart';
import 'package:time_tracker/services/api_path.dart';
import 'package:time_tracker/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);

  Stream<List<Job>> jobStreams();
}

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});

  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> createJob(Job job) => _service.setData(
        path: APIPath.job(uid, "job_abc"),
        data: job.toMap(),
      );

  @override
  Stream<List<Job>> jobStreams() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data) => Job.fromMap(data),
      );


}
