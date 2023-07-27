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
        result.add(Place(
          id: data[i].id,
          lat: currentData['lat'],
          long: currentData['long'],
          name: currentData['name'],
          type: currentData['type'],
          slogan: currentData['slogan'] ?? "",
          phone: currentData['phone'] ?? "",
          schedule: currentData['schedule'] ?? "",
          likeCount: currentData['like_count'] ?? 0,
        ));
      }
    });
    return result;
  }

  static Future<Place> getOne(String id) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final place = await db.collection("places").doc(id).get();
    return Place(
        id: id,
        lat: place['lat'],
        long: place['long'],
        name: place['name'],
        type: place['type'],
        slogan: place['slogan'] ?? "",
        phone: place['phone'] ?? "",
        schedule: place['schedule'] ?? "",
        likeCount:
            place.data()!.containsKey('like_count') ? place['like_count'] : 0);
  }

  static Future<String> getFirstPicture(String id) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final place = await db.collection("places").doc(id).get();
    final data = place.data() as Map<String, dynamic>;
    if (data.toString().contains("images")) {
      if (data['images'][0] != null) {
        return data['images'][0];
      }
    }
    return "none";
  }

  static Future<List<String>> getAllPictures(String id) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final place = await db.collection("places").doc(id).get();
    final data = place.data() as Map<String, dynamic>;
    if (data.toString().contains("images")) {
      return List<String>.from(data['images']);
    }
    return [];
  }

  static Future<void> updateLikeCount(String id, int delta) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    final place = await db.collection("places").doc(id).get();
    final data = place.data() as Map<String, dynamic>;
    int result = data.containsKey('like_count') ? data['like_count'] : 1;

    await db.collection("places").doc(id).update({
      "like_count": result,
    });
  }

  static int getPlaceTypeNumber(String type) {
    if (type == "eatery") {
      return 0;
    } else if (type == "coffeeshop") {
      return 1;
    } else if (type == "play") {
      return 2;
    } else if (type == "party") {
      return 3;
    } else if (type == "museum") {
      return 4;
    } else if (type == "gym") {
      return 5;
    } else if (type == "books") {
      return 6;
    }
    return -1;
  }
}
