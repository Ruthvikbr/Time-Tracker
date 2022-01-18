import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker/app/model/job.dart';

void main() {
  group("Job-fromMap", () {
    test("Job with properties", () {
      final job = Job.fromMap({
        "name": "Blogging",
        "ratePerHour": 10,
      }, "ABC");

      expect(job, Job(id: "ABC", name: "Blogging", ratePerHour: 10));
    });

    test("Job-fromMap with individual properties", () {
      final job = Job.fromMap({
        "name": "Blogging",
        "ratePerHour": 10,
      }, "ABC");

      expect(job.name, "Blogging");
      expect(job.ratePerHour, 10);
      expect(job.id, "ABC");
    });
  });

  group("Job-toMap", () {
    test("Job with properties", () {
      final job = Job.fromMap({
        "name": "Blogging",
        "ratePerHour": 10,
      }, "ABC");

      expect(job.toMap(), {
        "name": "Blogging",
        "ratePerHour": 10,
      });
    });
  });
}
