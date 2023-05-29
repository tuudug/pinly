import 'dart:developer';

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
}
