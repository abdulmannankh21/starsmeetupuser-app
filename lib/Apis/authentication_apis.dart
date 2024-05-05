import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

class AuthenticationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.email).set(user.toJson());
      if (kDebugMode) {
        print('User data uploaded successfully!');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading user data: $e');
      }
    }
  }

  Future getUser(String email) async {
    try {
      var result = await _firestore.collection('users').doc(email).get();
      log("this is user data: ${result.data()}");
      if (kDebugMode) {
        print('User data uploaded successfully!');
        return result.data();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading user data: $e');
      }
    }
  }

  Future<void> deleteUserAndData(String userId) async {
    try {
      await _firestore.collection('users').doc(userId).delete();

      if (kDebugMode) {
        print('User and associated data deleted successfully!');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting user and data: $e');
      }
    }
  }
}
