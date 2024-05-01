import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:starsmeetupuser/models/celebrity_model.dart';

class CelebritiesService {
  Future<List<CelebrityModel>> fetchCelebrities() async {
    List<CelebrityModel> users = [];
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('celebrities').get();

      users =
          querySnapshot.docs.map((DocumentSnapshot<Map<String, dynamic>> doc) {
        return CelebrityModel.fromJson(doc.data()!);
      }).toList();

      return users;
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching users: $e');
      }
      return [];
    }
  }
}
