import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:starsmeetupuser/models/historyModel.dart';

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
          .where("status", isEqualTo: "active")
          .get();
      log("i am here: ${querySnapshot.docs.length}");
      List<AppointmentModel> appointments = querySnapshot.docs
          .map((doc) => AppointmentModel.fromJson(doc.data()))
          .toList();

      // Sort the appointments based on their start times
      appointments.sort((a, b) => a.startTime!.compareTo(b.startTime!));

      return appointments;
    } catch (e) {
      print('Error getting appointments by user ID: $e');
      // Handle error accordingly
      return [];
    }
  }

  Future<List<AppointmentModel>> getAppointmentsByUserIdCurrentMonth(
      String userId) async {
    try {
      int currentYear = DateTime.now().year;
      int currentMonth = DateTime.now().month;
      DateTime startOfMonth = DateTime(currentYear, currentMonth, 1);
      DateTime endOfMonth = DateTime(currentYear, currentMonth + 1, 1)
          .subtract(Duration(days: 1));

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .where("status", isEqualTo: "active")
          .get();

      List<AppointmentModel> appointments = querySnapshot.docs
          .map((doc) => AppointmentModel.fromJson(doc.data()))
          .where((appointment) {
        // Parse creationTimestamp string to DateTime object
        DateTime creationTimestamp =
            DateTime.parse(appointment.startTime.toString());
        // Check if creationTimestamp is within the current month
        return creationTimestamp.isAfter(startOfMonth) &&
            creationTimestamp.isBefore(endOfMonth);
      }).toList();

      // Sort the appointments based on their start times
      appointments.sort((a, b) => a.startTime!.compareTo(b.startTime!));

      log("Appointments for user ID $userId for current month: ${appointments.length}");

      // Print data from each document
      appointments.forEach((appointment) {
        print("this is result ${appointment.toJson()}");
      });

      return appointments;
    } catch (e) {
      print('Error getting appointments by user ID: $e');
      // Handle error accordingly
      return [];
    }
  }

  Future<List<AppointmentModel>> getAppointmentsByUserIdwithYear(
      String userId) async {
    try {
      int currentYear = DateTime.now().year;
      DateTime startOfYear = DateTime(currentYear, 1, 1);
      DateTime endOfYear =
          DateTime(currentYear + 1, 1, 1).subtract(Duration(days: 1));

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('appointments')
          .where("status", isEqualTo: "active")
          .where('userId', isEqualTo: userId)
          .get();

      List<AppointmentModel> appointments = querySnapshot.docs
          .map((doc) => AppointmentModel.fromJson(doc.data()))
          .where((appointment) {
        // Parse creationTimestamp string to DateTime object
        DateTime creationTimestamp =
            DateTime.parse(appointment.startTime.toString());
        // Check if creationTimestamp is within the current year
        return creationTimestamp.isAfter(startOfYear) &&
            creationTimestamp.isBefore(endOfYear);
      }).toList();

      appointments.sort((a, b) => a.startTime!.compareTo(b.startTime!));
      log("Appointments for user ID $userId for current year: ${appointments.length}");

      // Print data from each document
      appointments.forEach((appointment) {
        print("this is result ${appointment.toJson()}");
      });

      return appointments;
    } catch (e) {
      print('Error getting appointments by user ID: $e');
      // Handle error accordingly
      return [];
    }
  }

  Future<List<AppointmentModel>> getAppointmentsByCelebrityId(
      String celebrityId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('appointments')
          .where('celebrityId', isEqualTo: celebrityId)
          .where("status", isEqualTo: "active")
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

  Future<List<HistoryModel>> getHistory(String userId) async {
    try {
      DateTime currentDate = DateTime.now();

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('appointments')
          .where("status", isEqualTo: "active")
          .where('userId', isEqualTo: userId)
          .get();

      List<HistoryModel> appointments = querySnapshot.docs
          .map((doc) => HistoryModel.fromJson(doc.data()))
          .where((appointment) {
        // Parse creationTimestamp string to DateTime object
        DateTime creationTimestamp =
            DateTime.parse(appointment.creationTimestamp.toString());
        // Check if creationTimestamp is before the current date
        return creationTimestamp.isBefore(currentDate);
      }).toList();

      log("Appointments for user ID $userId before current date: ${appointments.length}");

      // Print data from each document
      appointments.forEach((appointment) {
        print("this is result ${appointment.toJson()}");
      });

      return appointments;
    } catch (e) {
      print('Error getting appointments by user ID: $e');
      // Handle error accordingly
      return [];
    }
  }

  Future<List<AppointmentModel>> getAppointmentsWithCustomdate(
      String userId, DateTime startDate, DateTime endDate) async {
    log("this is start date: ${startDate}-${endDate}");
    int currentYear = DateTime.now().year;
    DateTime startOfYear =
        DateTime(startDate.year, startDate.month, startDate.day);
    DateTime endOfYear = DateTime(endDate.year, endDate.month, endDate.day + 1);
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .where("status", isEqualTo: "active")
          .get();
      List<AppointmentModel> appointments = querySnapshot.docs
          .map((doc) => AppointmentModel.fromJson(doc.data()))
          .where((appointment) {
        // Parse creationTimestamp string to DateTime object
        DateTime creationTimestamp =
            DateTime.parse(appointment.startTime.toString());
        // Check if creationTimestamp is within the current year
        return creationTimestamp.isAfter(startOfYear) &&
            creationTimestamp.isBefore(endOfYear);
      }).toList();

      log("Appointments for user ID $userId for current year: ${appointments.length}");
      // if (appointments.length == 0) {
      //   return [];
      // }
      // Print data from each document
      appointments.forEach((appointment) {
        print("this is result ${appointment.toJson()}");
      });

      return appointments;
    } catch (e) {
      print('Error getting appointments by user ID: $e');
      // Handle error accordingly
      return [];
    }
  }

  Future<void> cancelAppointmentsByUserId(
      String userId, String tomeSoltId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .where("creationTimestamp", isEqualTo: tomeSoltId)
          .where("status", isEqualTo: "active")
          .get();

      List<QueryDocumentSnapshot<Map<String, dynamic>>> docs =
          querySnapshot.docs;

      for (var doc in docs) {
        await _firestore.collection('appointments').doc(doc.id).update({
          'status': 'cancelled',
        });
      }

      print('Appointments cancelled successfully');
    } catch (e) {
      print('Error cancelling appointments by user ID: $e');
      // Handle error accordingly
    }
  }

  Future<List<AppointmentModel>> getCancelledAppointmentsByUserId(
      String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .where("status", isEqualTo: "cancelled")
          .get();
      log("i am here: ${querySnapshot.docs.length}");
      return querySnapshot.docs
          .map((doc) => AppointmentModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting appointments by user ID: $e');
      // Handle error accordingly
      return [];
    }
  }
}
