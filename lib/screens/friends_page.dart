import 'package:flutter/material.dart';

import '../firestore/friends.dart';
import '../models/user.dart';

class FriendsPage extends StatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  Future<List<UserAccount>> friends = FriendsDb.getFriends();
  List<String> friendRequests = [
    "Sarah Williams",
    "Robert Davis",
  ];

  List<String> everyone = [
    "Sarah Williams",
    "Robert Davis",
  ];

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
                        return CircularProgressIndicator();
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
                                title:
                                    Text(snapshot.data?[index].username ?? ""),
                                subtitle: Text("Status: idk tbh"),
                              ),
                            );
                          },
                        );
                      }
                    },
                  ),

                  // Friend Requests Tab
                  ListView.builder(
                    itemCount: friendRequests.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage('https://picsum.photos/200'),
                          ),
                          title: Text(friendRequests[index]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // Accept friend request
                                },
                                child: Text(
                                  "Accept",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Decline friend request
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
                  ),
                  ListView.builder(
                    itemCount: everyone.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage('https://picsum.photos/200'),
                          ),
                          title: Text(everyone[index]),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () {
                                  // Accept friend request
                                },
                                child: Text(
                                  "Add Friend",
                                  style: TextStyle(color: Colors.green),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
