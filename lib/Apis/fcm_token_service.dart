import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FanDeviceTokenHandler {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void saveFanDeviceToken() async {
    // Request permission to receive notifications
    await _firebaseMessaging.requestPermission();

    // Get the device token
    String? deviceToken = await _firebaseMessaging.getToken();

    if (deviceToken != null) {
      // Save the device token to Firestore
      User? user = await FirebaseAuth.instance.currentUser;
      try {
        await _firestore.collection('users').doc(user?.email).update({
          'deviceToken': deviceToken,
        });
        print('Star device token saved successfully: $deviceToken');
      } catch (error) {
        print('Error saving star device token: $error');
      }
    } else {
      print('Failed to get device token');
    }
  }
}
