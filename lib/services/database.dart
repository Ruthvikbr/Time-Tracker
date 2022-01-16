import 'package:time_tracker/app/model/job.dart';
import 'package:time_tracker/services/api_path.dart';
import 'package:time_tracker/services/firestore_service.dart';

abstract class Database {
  Future<void> createOrUpdateJob(Job job);

  Stream<List<Job>> jobStreams();
}

String documentIdFromCurrentString() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});

  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> createOrUpdateJob(Job job) => _service.setData(
        path: APIPath.job(
          uid,
          job.id,
        ),
        data: job.toMap(),
      );

  @override
  Stream<List<Job>> jobStreams() => _service.collectionStream(
        path: APIPath.jobs(uid),
        builder: (data,documentId) => Job.fromMap(data,documentId),
      );
}
