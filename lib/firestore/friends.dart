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

    await db.collection("users").doc(user_uid).get(GetOptions(source: Source.serverAndCache)).then((snapshot) async {
      final data = snapshot.data() as Map<String, dynamic>;
      final List<dynamic> friends = data['friends'];
      for (int i = 0; i < friends.length; i++) {
        UserAccount user = await UserDb.getUser(friends[i]) ??
            UserAccount(id: "", username: "empty.", phoneNumber: "", friends: [], friendRequests: []);
        result.add(user);
      }
    });
    return result;
  }

  static Future<List<UserAccount>> getFriendRequests() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final FirebaseFirestore db = FirebaseFirestore.instance;
    List<UserAccount> result = [];
    String? user_uid = await storage.read(key: "user_uid");

    await db.collection("users").doc(user_uid).get(GetOptions(source: Source.serverAndCache)).then((snapshot) async {
      final data = snapshot.data() as Map<String, dynamic>;
      final List<dynamic> friends = data['friend_requests'];
      for (int i = 0; i < friends.length; i++) {
        UserAccount user = await UserDb.getUser(friends[i]) ??
            UserAccount(id: "", username: "empty.", phoneNumber: "", friends: [], friendRequests: []);
        result.add(user);
      }
    });
    return result;
  }

  static Future<List<UserAccount>> getEveryone() async {
    final FirebaseFirestore db = FirebaseFirestore.instance;
    List<UserAccount> result = [];

    await db.collection("users").get(GetOptions(source: Source.serverAndCache)).then((snapshot) async {
      final data = snapshot.docs;
      for (int i = 0; i < data.length; i++) {
        final currentId = data[i].data()['uid'];
        UserAccount user = await UserDb.getUser(currentId) ??
            UserAccount(id: "", username: "empty.", phoneNumber: "", friends: [], friendRequests: []);
        result.add(user);
      }
    });
    return result;
  }

  static Future<void> addFriend(userId) async {

  }

  static Future<void> removeFriend(userId) async {

  }

  static Future<void> acceptFriend(userId) async {
    
  }

  static Future<void> denyFriend(userId) async {
    
  }
}
