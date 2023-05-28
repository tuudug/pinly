import 'dart:developer';

import '../models/user.dart';
import 'user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsDb {
  static Future<List<UserAccount>> getFriends() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final FirebaseFirestore db = FirebaseFirestore.instance;
    List<UserAccount> result = [];
    String? user_uid = await storage.read(key: "user_uid");

    await db.collection("users").doc(user_uid).get().then((snapshot) async {
      final data = snapshot.data() as Map<String, dynamic>;
      final List<dynamic> friends = data['friends'];
      for (int i = 0; i < friends.length; i++) {
        UserAccount user = await UserDb.getUser(friends[i]) ??
            UserAccount(id: "", username: "empty.", phoneNumber: "");
        result.add(user);
      }
    });
    return result;
  }
}
