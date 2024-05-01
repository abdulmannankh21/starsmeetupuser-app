import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../models/promo_code_model.dart';

class PromoCodeService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<PromoCodeModel?> getPromoCode(String promoCode) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('promocodes')
          .where('code', isEqualTo: promoCode)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        PromoCodeModel promoCodeModel = PromoCodeModel.fromJson(
            querySnapshot.docs.first.data() as Map<String, dynamic>);
        return promoCodeModel;
      } else {
        EasyLoading.showError('Invalid Promo Code');
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching promo code: $e');
      }
      return null;
    }
  }
}
