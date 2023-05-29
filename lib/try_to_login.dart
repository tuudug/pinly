import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pinly/providers/user.dart';
import 'package:pinly/screens/home_page.dart';
import 'package:pinly/screens/main_map.dart';

import 'firestore/user.dart';
import 'models/user.dart';

class TryToLoginPage extends ConsumerStatefulWidget {
  const TryToLoginPage({super.key});

  @override
  ConsumerState<TryToLoginPage> createState() => _TryToLoginPageState();
}

class _TryToLoginPageState extends ConsumerState<TryToLoginPage> {
  final FlutterSecureStorage storage = new FlutterSecureStorage();
  final FirebaseFirestore db = FirebaseFirestore.instance;

  _tryToLogin() async {
    storage.readAll().then((localUser) => {
          if (localUser['user_uid'] == null)
            {
              Navigator.pop(context),
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              )
            }
          else
            {
              db
                  .collection("users")
                  .doc(localUser['user_uid'])
                  .get()
                  .then((user) async => {
                        if (user.data()?['session_id'].toString() !=
                            localUser['session_id'].toString())
                          {
                            log('not match'),
                            Navigator.pop(context),
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyHomePage(),
                              ),
                            )
                          }
                        else
                          {
                            ref.read(loggedInUserProvider.notifier).state = await UserDb.getUser(localUser['user_uid']!)  
                              ?? UserAccount(id: "", username: "", phoneNumber: "", friends: [], friendRequests: []),
                            Navigator.pop(context),
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainMap(),
                              ),
                            )
                          }
                      })
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    _tryToLogin();
    return const Scaffold(
      body: Center(
        child: SafeArea(child: CircularProgressIndicator()),
      ),
    );
  }
}
