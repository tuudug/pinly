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

    await db
        .collection("users")
        .doc(user_uid)
        .get(GetOptions(source: Source.serverAndCache))
        .then((snapshot) async {
      final data = snapshot.data() as Map<String, dynamic>;
      final List<dynamic> friends = data['friends'];
      for (int i = 0; i < friends.length; i++) {
        UserAccount user =
            await UserDb.getUser(friends[i]) ?? UserAccount.empty();
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

    await db
        .collection("users")
        .doc(user_uid)
        .get(GetOptions(source: Source.serverAndCache))
        .then((snapshot) async {
      final data = snapshot.data() as Map<String, dynamic>;
      final List<dynamic> friends = data['friend_requests'];
      for (int i = 0; i < friends.length; i++) {
        UserAccount user =
            await UserDb.getUser(friends[i]) ?? UserAccount.empty();
        result.add(user);
      }
    });
    return result;
  }

  static Future<List<UserAccount>> getEveryone() async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final FirebaseFirestore db = FirebaseFirestore.instance;
    List<UserAccount> result = [];
    String? user_uid = await storage.read(key: "user_uid");

    await db
        .collection("users")
        .get(GetOptions(source: Source.serverAndCache))
        .then((snapshot) async {
      final data = snapshot.docs;
      for (int i = 0; i < data.length; i++) {
        final currentId = data[i].data()['uid'];
        UserAccount user =
            await UserDb.getUser(currentId) ?? UserAccount.empty();
        if (user.username != null && user.id != user_uid) {
          result.add(user);
        }
      }
    });
    return result;
  }

  static Future<void> addFriend(String recipientUserId) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final FirebaseFirestore db = FirebaseFirestore.instance;
    String? user_uid = await storage.read(key: "user_uid");

    final userData = await db.collection("users").doc(recipientUserId).get();
    List<String> userFriendRequsts =
        List<String>.from(userData['friend_requests']);
    if (!userFriendRequsts.contains(user_uid)) {
      userFriendRequsts.add(user_uid!);
    }
    await db
        .collection("users")
        .doc(recipientUserId)
        .update({"friend_requests": userFriendRequsts});
  }

  static Future<void> removeFriend(String recipientUserId) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final FirebaseFirestore db = FirebaseFirestore.instance;
    String? user_uid = await storage.read(key: "user_uid");

    final userData = await db.collection("users").doc(user_uid).get();
    final recipientData =
        await db.collection("users").doc(recipientUserId).get();
    List<String> userFriends = List<String>.from(userData['friends']);
    List<String> recipientFriends = List<String>.from(recipientData['friends']);
    if (userFriends.contains(recipientUserId)) {
      userFriends.remove(recipientUserId);
    }
    if (recipientFriends.contains(user_uid)) {
      recipientFriends.remove(user_uid);
    }

    await db.collection("users").doc(user_uid).update({"friends": userFriends});
    await db
        .collection("users")
        .doc(recipientUserId)
        .update({"friends": recipientFriends});
  }

  static Future<void> acceptFriend(String recipientUserId) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final FirebaseFirestore db = FirebaseFirestore.instance;
    String? user_uid = await storage.read(key: "user_uid");

    final userData = await db.collection("users").doc(user_uid).get();
    final recipientData =
        await db.collection("users").doc(recipientUserId).get();

    List<String> userFriendRequsts =
        List<String>.from(userData['friend_requests']);
    List<String> userFriends = List<String>.from(userData['friends']);
    List<String> recipientFriends = List<String>.from(recipientData['friends']);
    if (userFriendRequsts.contains(recipientUserId)) {
      userFriendRequsts.remove(recipientUserId);
    }

    if (!userFriends.contains(recipientUserId)) {
      userFriends.add(recipientUserId);
    }
    if (!recipientFriends.contains(user_uid)) {
      recipientFriends.add(user_uid!);
    }

    await db
        .collection("users")
        .doc(user_uid)
        .update({"friend_requests": userFriendRequsts, "friends": userFriends});
    await db
        .collection("users")
        .doc(recipientUserId)
        .update({"friends": recipientFriends});
  }

  static Future<void> denyFriend(String recipientUserId) async {
    const FlutterSecureStorage storage = FlutterSecureStorage();
    final FirebaseFirestore db = FirebaseFirestore.instance;
    String? user_uid = await storage.read(key: "user_uid");

    final userData = await db.collection("users").doc(user_uid).get();
    List<String> userFriendRequsts =
        List<String>.from(userData['friend_requests']);
    if (userFriendRequsts.contains(recipientUserId)) {
      userFriendRequsts.remove(recipientUserId);
    }
    await db
        .collection("users")
        .doc(user_uid)
        .update({"friend_requests": userFriendRequsts});
  }
}
