import 'package:cloud_firestore/cloud_firestore.dart';

class Holiday {
  final String id;
  final DateTime startDate;
  final DateTime endDate;

  Holiday({
    required this.id,
    required this.startDate,
    required this.endDate,
  });

  factory Holiday.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Holiday(
      id: snapshot.id,
      startDate: (data['startDate'] as Timestamp).toDate(),
      endDate: (data['endDate'] as Timestamp).toDate(),
    );
  }
}
