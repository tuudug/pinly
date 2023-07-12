import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/place.dart';

class PlacesDb {
  static Future<List<Place>> getAll() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    List<Place> result = [];

    await db
        .collection("places")
        .get(GetOptions(source: Source.serverAndCache))
        .then((snapshot) async {
      final data = snapshot.docs;
      for (int i = 0; i < data.length; i++) {
        final currentData = data[i].data();
        log(currentData['name']);
        result.add(Place(
            lat: currentData['lat'],
            long: currentData['long'],
            name: currentData['name'],
            type: currentData['type']));
      }
    });
    return result;
  }
}
