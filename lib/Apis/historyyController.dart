import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:starsmeetupuser/models/historyModel.dart';

import '../models/appointment_model.dart';

class HistoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<HistoryModel>> getAppointmentsByUserIdCurrentMonth(
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
          .get();

      List<HistoryModel> appointments = querySnapshot.docs
          .map((doc) => HistoryModel.fromJson(doc.data()))
          .where((appointment) {
        // Parse creationTimestamp string to DateTime object
        DateTime creationTimestamp =
            DateTime.parse(appointment.creationTimestamp.toString());
        // Check if creationTimestamp is within the current month
        return creationTimestamp.isAfter(startOfMonth) &&
            creationTimestamp.isBefore(endOfMonth);
      }).toList();

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

  Future<List<HistoryModel>> getAppointmentsByUserIdwithYear(
      String userId) async {
    try {
      int currentYear = DateTime.now().year;
      DateTime startOfYear = DateTime(currentYear, 1, 1);
      DateTime endOfYear =
          DateTime(currentYear + 1, 1, 1).subtract(Duration(days: 1));

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .get();

      List<HistoryModel> appointments = querySnapshot.docs
          .map((doc) => HistoryModel.fromJson(doc.data()))
          .where((appointment) {
        // Parse creationTimestamp string to DateTime object
        DateTime creationTimestamp =
            DateTime.parse(appointment.creationTimestamp.toString());
        // Check if creationTimestamp is within the current year
        return creationTimestamp.isAfter(startOfYear) &&
            creationTimestamp.isBefore(endOfYear);
      }).toList();

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

  Future<List<HistoryModel>> getAppointmentsByUserId(String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .get();
      log("i am here: ${querySnapshot.docs.length}");

      return querySnapshot.docs
          .map((doc) => HistoryModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('Error getting appointments by user ID: $e');
      // Handle error accordingly
      return [];
    }
  }

  Future<List<HistoryModel>> getHistoryByUserIdCustomdate(
      String userId, String date) async {
    try {
      // Parse the date string into a DateTime object // Parse the date string into a DateTime object

      // Define the start and end of the selected date
      // DateTime startOfDay =
      //     DateTime(selectedDate.year, selectedDate.month, selectedDate.day);
      // DateTime endOfDay = startOfDay.add(Duration(days: 1));

      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: userId)
          .where('creationTimestamp', isEqualTo: date)
          // .where('creationTimestamp', isLessThan: endOfDay)
          .get();

      List<HistoryModel> appointments = querySnapshot.docs
          .map((doc) => HistoryModel.fromJson(doc.data()))
          .toList();

      log("Appointments for user ID $userId for date $date: ${appointments.length}");

      // Check if creationTimestamp is within the current month

      // Print data from each document
      appointments.forEach((appointment) {
        print("This is result ${appointment.toJson()}");
      });

      return appointments;
    } catch (e) {
      print('Error getting appointments by user ID: $e');
      // Handle error accordingly
      return [];
    }
  }
}
