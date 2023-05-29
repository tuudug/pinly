import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinly/providers/user.dart';

import '../firestore/friends.dart';
import '../models/user.dart';

class FriendsPage extends ConsumerStatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends ConsumerState<FriendsPage> {
  Future<List<UserAccount>> friends = FriendsDb.getFriends();
  Future<List<UserAccount>> friendRequests = FriendsDb.getFriendRequests();
  Future<List<UserAccount>> everyone = FriendsDb.getEveryone();

  _refresh() {
    setState(() {
      friends = FriendsDb.getFriends();
      friendRequests = FriendsDb.getFriendRequests();
      everyone = FriendsDb.getEveryone();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Friends"),
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            const TabBar(
              labelColor: Colors.black,
              tabs: [
                Tab(icon: Icon(Icons.people), text: "Friends"),
                Tab(icon: Icon(Icons.group_add), text: "Requests"),
                Tab(icon: Icon(Icons.groups), text: "Everyone"),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Your Friends Tab
                  FutureBuilder(
                    future: friends,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return ListView.builder(
                          itemCount: snapshot.data?.length,
                          itemBuilder: (context, index) {
                            return Card(
                                child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage('https://picsum.photos/200'),
                              ),
                              title: Text(snapshot.data?[index].username ?? ""),
                              subtitle: Text("Status: idk tbh"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextButton(
                                    onPressed: () async {
                                      await FriendsDb.removeFriend(
                                          snapshot.data![index].id);
                                      _refresh();
                                    },
                                    child: Text(
                                      "Unfriend",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                          },
                        );
                      }
                    },
                  ),

                  // Friend Requests Tab
                  FutureBuilder(
                      future: friendRequests,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://picsum.photos/200'),
                                  ),
                                  title: Text(
                                      snapshot.data?[index].username ?? ""),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextButton(
                                        onPressed: () async {
                                          await FriendsDb.acceptFriend(
                                              snapshot.data![index].id);
                                          _refresh();
                                        },
                                        child: Text(
                                          "Accept",
                                          style: TextStyle(color: Colors.green),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await FriendsDb.denyFriend(
                                              snapshot.data![index].id);
                                          _refresh();
                                        },
                                        child: Text(
                                          "Decline",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }),
                  FutureBuilder(
                      future: Future.wait([everyone, friends, friendRequests]),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data?[0].length,
                            itemBuilder: (context, index) {
                              bool friends = false;
                              bool requestReceived = false;
                              bool requestSent = false;
                              String currentUserId =
                                  snapshot.data?[0][index].id ?? "";
                              for (int j = 0;
                                  j < (snapshot.data?[1].length as int);
                                  j++) {
                                if (snapshot.data?[0][index].id ==
                                    snapshot.data?[1][j].id) {
                                  friends = true;
                                }
                              }
                              for (int j = 0;
                                  j < (snapshot.data?[2].length as int);
                                  j++) {
                                if (snapshot.data?[0][index].id ==
                                    snapshot.data?[2][j].id) {
                                  requestReceived = true;
                                }
                              }
                              for (int j = 0;
                                  j <
                                      (snapshot.data?[0][index].friendRequests
                                          .length as int);
                                  j++) {
                                if (ref.read(loggedInUserProvider).id ==
                                    snapshot
                                        .data?[0][index].friendRequests[j]) {
                                  requestSent = true;
                                }
                              }
                              return Card(
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        'https://picsum.photos/200'),
                                  ),
                                  title: Text(
                                      snapshot.data?[0][index].username ?? ""),
                                  subtitle:
                                      Text(snapshot.data?[0][index].id ?? ""),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      !friends &&
                                              !requestReceived &&
                                              !requestSent
                                          ? TextButton(
                                              onPressed: () async {
                                                await FriendsDb.addFriend(
                                                    currentUserId);
                                                _refresh();
                                              },
                                              child: const Text(
                                                "Add Friend",
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            )
                                          : requestReceived && !requestSent
                                              ? TextButton(
                                                  onPressed: () {
                                                    // Accept friend request
                                                  },
                                                  child: const Text(
                                                    "Request received",
                                                    style: TextStyle(
                                                        color: Colors.grey),
                                                  ),
                                                )
                                              : requestSent
                                                  ? TextButton(
                                                      onPressed: () {
                                                        // Accept friend request
                                                      },
                                                      child: const Text(
                                                        "Request sent",
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    )
                                                  : TextButton(
                                                      onPressed: () {
                                                        // Accept friend request
                                                      },
                                                      child: const Text(
                                                        "Friends",
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      ),
                                                    ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
