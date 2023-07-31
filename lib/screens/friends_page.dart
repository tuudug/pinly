import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinly/providers/user.dart';
import 'package:pinly/widgets/add_friend_bottom_sheet.dart';

import '../firestore/friends.dart';
import '../models/user.dart';
import '../widgets/no_entries.dart';

class FriendsPage extends ConsumerStatefulWidget {
  @override
  _FriendsPageState createState() => _FriendsPageState();
}

class _FriendsPageState extends ConsumerState<FriendsPage> {
  Future<List<UserAccount>> friends = FriendsDb.getFriends();
  Future<List<UserAccount>> friendRequests = FriendsDb.getFriendRequests();

  _refresh() async {
    setState(() {
      friends = FriendsDb.getFriends();
      friendRequests = FriendsDb.getFriendRequests();
    });
    UserAccount user = ref.read(loggedInUserProvider);
    List<UserAccount> refreshedFriends = await friends;
    List<String> refreshedFriendsString = [];
    refreshedFriends.forEach((element) {
      refreshedFriendsString.add(element.id);
    });
    log(refreshedFriendsString.toString());
    ref.read(loggedInUserProvider.notifier).state = UserAccount(
        id: user.id,
        username: user.username,
        phoneNumber: user.phoneNumber,
        friends: refreshedFriendsString,
        friendRequests: user.friendRequests);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(
            dividerColor: Colors.transparent,
            labelColor: Colors.black,
            padding: EdgeInsets.symmetric(horizontal: 72),
            tabs: [
              Tab(icon: Icon(Icons.people)),
              Tab(icon: Icon(Icons.group_add)),
            ],
          ),
          actions: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      showDragHandle: true,
                      context: context,
                      builder: (context) {
                        return AddFriendBottomSheet();
                      });
                },
                icon: Icon(Icons.person_add))
          ],
        ),
        body: Column(
          children: [
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
                        return snapshot.data?.length == 0
                            ? NoEntries(
                                text: "No friends added",
                                icon: Icons.group,
                                buttonText: "Add friend",
                                buttonAction: () {
                                  showModalBottomSheet(
                                      isScrollControlled: true,
                                      showDragHandle: true,
                                      context: context,
                                      builder: (context) {
                                        return AddFriendBottomSheet();
                                      });
                                },
                              )
                            : ListView.builder(
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
                          return snapshot.data?.length == 0
                              ? NoEntries(
                                  text: "No friend requests",
                                  icon: Icons.groups_2,
                                )
                              : ListView.builder(
                                  itemCount: snapshot.data?.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          backgroundImage: NetworkImage(
                                              'https://picsum.photos/200'),
                                        ),
                                        title: Text(
                                            snapshot.data?[index].username ??
                                                ""),
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
                                                style: TextStyle(
                                                    color: Colors.green),
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
                                                style: TextStyle(
                                                    color: Colors.red),
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
