import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class VideosService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> getVideo() async {
    try {
      var querySnapshot =
          await _firestore.collection('howToVideo').doc("howToVideo").get();
      var data = querySnapshot.data() as Map<String, dynamic>;
      var videoUrl = data["howToVideo"];
      return videoUrl;
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching video: $e");
      }
      return "";
    }
  }
}
