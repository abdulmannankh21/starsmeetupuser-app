import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/holiday_model.dart';



class HolidayService {
  final CollectionReference _holidayCollection =
      FirebaseFirestore.instance.collection('holidays');

  Future<bool> isHoliday(DateTime selectedDay, String userId) async {
    try {
      DocumentSnapshot docSnapshot = await _holidayCollection.doc(userId).get();
      if (docSnapshot.exists) {
        Holiday holiday = Holiday.fromSnapshot(docSnapshot);
        return holiday.startDate.isBefore(selectedDay) &&
            holiday.endDate.add(Duration(days: 1)).isAfter(selectedDay);
      } else {
        return false;
      }
    } catch (e) {
      print("Error checking holiday: $e");
      return false;
    }
  }
}
