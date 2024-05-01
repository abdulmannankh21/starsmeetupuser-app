import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/faq_model.dart';

class FaqsService {
  final CollectionReference faqCollection =
      FirebaseFirestore.instance.collection('faqs');

  Future<List<PoliciesModel>> getFAQs() async {
    try {
      QuerySnapshot querySnapshot =
          await faqCollection.orderBy("timestamp", descending: false).get();
      List<PoliciesModel> faqs = querySnapshot.docs
          .map((doc) =>
              PoliciesModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      return faqs;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting FAQs: $e');
      }
      return [];
    }
  }
}
