import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../models/appointment_model.dart';

class AppointmentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadAppointment(AppointmentModel appointment) async {
    try {
      await _firestore.collection('appointments').add(appointment.toJson());
    } catch (e) {
      print('Error uploading appointment: $e');
    }
  }

  Future<List<AppointmentModel>> getAppointmentsByUserId(String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .get();

      return querySnapshot.docs
          .map((doc) => AppointmentModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting appointments by user ID: $e');
      // Handle error accordingly
      return [];
    }
  }

  Future<List<AppointmentModel>> getAppointmentsByUserIdAndDate(String userId,) async {
    try {

      String formattedToday = DateFormat("yyyy-MM-ddTHH:00:00.000").format(DateTime.now());

      DateTime today = DateTime.parse(formattedToday);
        QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
            .collection('appointments')
            .where('userId', isEqualTo: userId)
            .where('selectedDate', isLessThan: today)
            .get();

        return querySnapshot.docs
            .map((doc) => AppointmentModel.fromJson(doc.data()))
            .toList();
    } catch (e) {
      print('Error getting appointments by user ID and date: $e');
      return [];
    }
  }



  Future<List<AppointmentModel>> getAppointmentsByCelebrityId(
      String celebrityId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('appointments')
          .where('celebrityId', isEqualTo: celebrityId)
          .get();

      return querySnapshot.docs
          .map((doc) => AppointmentModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting appointments by celebrity ID: $e');
      // Handle error accordingly
      return [];
    }
  }
}
