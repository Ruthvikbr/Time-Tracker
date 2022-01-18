import 'dart:ui';

class Job {
  Job({required this.id, required this.name, required this.ratePerHour});

  final String id;
  final String name;
  final int ratePerHour;

  factory Job.fromMap(Map<String, dynamic> data, String documentId) {
    final String name = data['name'];
    final int ratePerHour = data['ratePerHour'];
    return Job(
      id: documentId,
      name: name,
      ratePerHour: ratePerHour,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "ratePerHour": ratePerHour,
    };
  }

  @override
  int get hashCode => hashValues(
        id,
        name,
        ratePerHour,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (runtimeType != other.runtimeType) {
      return false;
    }
    return other is Job &&
        other.id == id &&
        other.name == name &&
        other.ratePerHour == ratePerHour;
  }
}
