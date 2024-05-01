import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/celebrity_services_model.dart';

class CelebrityServicesService {
  final CollectionReference celebrityServicesCollection =
      FirebaseFirestore.instance.collection('celebrityServices');

  Future<void> uploadCelebrityService(
      CelebrityServicesModel celebrityServicesModel) async {
    try {
      await celebrityServicesCollection
          .doc(celebrityServicesModel.id)
          .set(celebrityServicesModel.toMap());
      if (kDebugMode) {
        print('Services uploaded successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading Services: $e');
      }
    }
  }

  Future<void> deleteCelebrityServiceList(List<String> servicesIds) async {
    try {
      for (String serviceId in servicesIds) {
        await celebrityServicesCollection.doc(serviceId).delete();
      }
      if (kDebugMode) {
        print('Services deleted successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting Services: $e');
      }
    }
  }

  Future<List<CelebrityServicesModel>> getCelebrityService() async {
    try {
      QuerySnapshot querySnapshot = await celebrityServicesCollection.get();
      List<CelebrityServicesModel> services = querySnapshot.docs
          .map((doc) => CelebrityServicesModel.fromMap(
              doc.id, doc.data() as Map<String, dynamic>))
          .toList();
      return services;
    } catch (e) {
      if (kDebugMode) {
        print('Error getting Services: $e');
      }
      return [];
    }
  }
}
