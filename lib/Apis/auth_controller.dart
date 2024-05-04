import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_auth/email_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utilities/app_routes.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  get user => _auth.currentUser;

  Future signUp({String? email, String? password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email!, password: password!);
      return null;
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError(e.message.toString());
      return e.message;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }

      return e.message;
    } on SocketException catch (e) {
      if (kDebugMode) {
        print(e.message);
      }

      return e.message;
    }
  }

  Future<User?> signIn({String? email, String? password}) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      final currentUser = userCredential.user;
      log("this is sigIn method: ${currentUser}");
      // if (currentUser != null) {
      //   // Check if user is already logged in on another device
      //   final isAlreadyLoggedIn =
      //       await _checkIfAlreadyLoggedIn(currentUser.email!);
      //   if (isAlreadyLoggedIn) {
      //     // If user is already logged in on another device, sign them out
      //     await _auth.signOut();
      //     return null; // Indicate to the UI that login failed due to single login restriction
      //   } else {
      //     return currentUser; // User can proceed with login
      //   }
      // } else {
      //   return null; // Sign-in failed, return null
      // }
    } on FirebaseAuthException catch (e) {
      EasyLoading.showError(_getFirebaseAuthErrorMessage(e.code));
      return null; // Sign-in failed, return null
    }
  }

  Future<bool> _checkIfAlreadyLoggedIn(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('active_sessions')
        .doc(email)
        .get();
    return snapshot.exists;
  }

  String _getFirebaseAuthErrorMessage(String code) {
    switch (code) {
      case "invalid-email":
        return "Invalid email format. Please enter a valid email.";
      case "user-not-found":
        return "User not found";
      case "wrong-password":
        return "Invalid email or password. Please try again.";
      case "too-many-requests":
        return "Too many unsuccessful attempts. Please try again later.";
      case "invalid-credential":
        return "Invalid email or password. Please try again.";
      default:
        return "An error occurred(User might not exist). Please try again.";
    }
  }

  Future signOut() async {
    await _auth.signOut();
  }

  deleteAccount(context) async {
    try {
      await user.delete();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var email = prefs.getString("currentUserEmail");

      FirebaseFirestore.instance
          .collection('users')
          .doc(email!.toLowerCase())
          .collection("products")
          .get()
          .then((querySnapshot) {
        for (var document in querySnapshot.docs) {
          document.reference.delete();
        }
      });
      FirebaseFirestore.instance
          .collection('users')
          .doc(email.toLowerCase())
          .collection("sales")
          .get()
          .then((querySnapshot) {
        for (var document in querySnapshot.docs) {
          document.reference.delete();
        }
      });
      FirebaseFirestore.instance
          .collection('users')
          .doc(email.toLowerCase())
          .collection("notifications")
          .get()
          .then((querySnapshot) {
        for (var document in querySnapshot.docs) {
          document.reference.delete();
        }
      });

      FirebaseFirestore.instance
          .collection('users')
          .doc(email.toLowerCase())
          .delete();

      EasyLoading.showSuccess("Account Deleted Successfully");

      Navigator.pushNamedAndRemoveUntil(
          context, loginScreenRoute, (route) => false);
      prefs.clear();
    } catch (e) {
      EasyLoading.showError(e.toString());
    }
  }

  late EmailAuth auth;

  Future enterEmailAuth(email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email).then((value) {
        if (kDebugMode) {
          print("Email Sent!");
        }
      });
      return null;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e);
      }
      EasyLoading.showError(e.message.toString());
      return e.message;
    } on PlatformException catch (e) {
      EasyLoading.showError(e.message.toString());

      if (kDebugMode) {
        print(e.message);
      }
      return e.message;
    } on SocketException catch (e) {
      EasyLoading.showError(e.message.toString());

      if (kDebugMode) {
        print(e.message);
      }
      return e.message;
    }
  }
}
