import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserDb {
  static Future<UserAccount?> getUser(String userUid) async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    UserAccount? user;

    await db.collection("users").doc(userUid).get().then((snapshot) {
      final data = snapshot.data() as Map<String, dynamic>;
      user = UserAccount(
        id: userUid,
        username: data['username'],
        phoneNumber: data['phone_number'],
        friends: List<String>.from(data['friends']),
        friendRequests: List<String>.from(data['friend_requests']),
      );
    });
    return user;
  }

  static Future<void> setUsername(String username) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final FirebaseFirestore db = FirebaseFirestore.instance;
    String? user_uid = await storage.read(key: "user_uid");

    await db.collection("users").doc(user_uid).update({"username": username});
  }
}
