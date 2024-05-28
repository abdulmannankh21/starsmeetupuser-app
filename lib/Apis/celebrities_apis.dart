import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:starsmeetupuser/models/celebrity_model.dart';

class CelebritiesService {
  Stream<List<CelebrityModel>> streamCelebrities() {
    try {
      Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
          FirebaseFirestore.instance.collection('celebrities').snapshots();

      // Convert the stream of snapshots to a stream of lists of CelebrityModel
      return snapshots.map((snapshot) => snapshot.docs
          .map((doc) => CelebrityModel.fromJson(doc.data()!))
          .toList());
    } catch (e) {
      if (kDebugMode) {
        print('Error streaming celebrities: $e');
      }
      // Return an empty stream in case of error
      return Stream.value([]);
    }
  }

  Future<void> addToFavorites(String userId, String celebrityId) async {
    try {
      // Update the 'favorite' field in the celebrity document
      await FirebaseFirestore.instance
          .collection('celebrities')
          .doc(celebrityId)
          .update({'favorite': true});
    } catch (e) {
      if (kDebugMode) {
        print('Error adding to favorites: $e');
      }
      // Handle error
    }
  }

  Stream<bool> isFavoriteStream(String userId) {
    try {
      return FirebaseFirestore.instance
          .collection('celebrities')
          .doc(userId)
          .snapshots()
          .map((snapshot) => snapshot.data()?['favorite'] ?? false);
    } catch (e) {
      print('Error streaming favorite status: $e');
      return Stream.value(false);
    }
  }

  Future<void> removeFromFavorites(String userId, String celebrityId) async {
    try {
      // Update the 'favorite' field in the celebrity document
      await FirebaseFirestore.instance
          .collection('celebrities')
          .doc(celebrityId)
          .update({'favorite': false});
    } catch (e) {
      if (kDebugMode) {
        print('Error removing from favorites: $e');
      }
      // Handle error
    }
  }
}
