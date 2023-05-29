import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pinly/firestore/user.dart';
import 'package:pinly/models/user.dart';
import 'package:pinly/providers/user.dart';

import 'friends_page.dart';

class MainMap extends ConsumerStatefulWidget {
  const MainMap({super.key});

  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends ConsumerState<MainMap> {
  bool _dialogOpen = false;
  final TextEditingController _usernameController = TextEditingController();
  final locations = FirebaseDatabase.instance.ref('locations');
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  final Map<String, Marker> _markers = {};
  _setupLocationWatcher() {
    locations.onValue.listen((DatabaseEvent event) {
      _updateMarkers();
    });
  }

  _updateMarkers() {
    locations.get().then((snapshot) => {
          snapshot.children.forEach((element) {
            final data = Map<String, dynamic>.from(element.value as Map);
            final key = element.key.toString();
            final friends = ref.read(loggedInUserProvider).friends;
            if (friends.contains(key)) {
              _markers[key] = Marker(
                  markerId: MarkerId(element.key.toString()),
                  position: LatLng(data['lat'], data['long']),
                  infoWindow: InfoWindow(
                    title: data['name'],
                    snippet: "hi lol",
                  ));
            } else {
              _markers.remove(key);
            }
          }),
          setState(() {})
        });
  }

  static const CameraPosition ulaanbaatar = CameraPosition(
    target: LatLng(47.8864, 106.9057),
    zoom: 14.4746,
  );

  bool _isSideMenuOpen = false;

  Future<void> _displayTextInputDialog(BuildContext context) async {
    _dialogOpen = true;
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return WillPopScope(
            onWillPop: () => Future.value(false),
            child: AlertDialog(
              title: Text('What is your name?'),
              content: TextField(
                onChanged: (value) {},
                controller: _usernameController,
                decoration: InputDecoration(hintText: ""),
              ),
              actions: [
                FilledButton(
                    onPressed: () async {
                      UserDb.setUsername(_usernameController.text)
                          .then((value) {
                        UserAccount user = ref.read(loggedInUserProvider);
                        user.username = _usernameController.text;
                        ref.read(loggedInUserProvider.notifier).state = user;
                        Navigator.pop(context);
                      });
                    },
                    child: Text("Submit"))
              ],
            ),
          );
        });
  }

  _checkUsername(context) {
    final user = ref.read(loggedInUserProvider);
    if (user.username == null && !_dialogOpen) {
      _displayTextInputDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _checkUsername(context));
    _setupLocationWatcher();
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: ulaanbaatar,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: _markers.values.toSet(),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Color(0xFF8B5CF6),
                width: 1,
              ),
            ),
            margin: EdgeInsets.only(left: 8, top: 48),
            child: IconButton(
              color: Color(0xFF8B5CF6),
              iconSize: 32,
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
          ),
          Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Color(0xFF8B5CF6),
                      width: 1,
                    ),
                  ),
                  margin: EdgeInsets.only(right: 8, top: 48),
                  child: IconButton(
                    color: Color(0xFF8B5CF6),
                    iconSize: 32,
                    icon: Icon(Icons.account_circle),
                    onPressed: () {},
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Color(0xFF8B5CF6),
                      width: 1,
                    ),
                  ),
                  margin: EdgeInsets.only(right: 8, top: 48 + 56),
                  child: IconButton(
                    color: Color(0xFF8B5CF6),
                    iconSize: 32,
                    icon: Icon(Icons.group),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FriendsPage(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Color(0xFF8B5CF6),
                      width: 1,
                    ),
                  ),
                  margin: EdgeInsets.only(right: 8, top: 48 + 56 + 56),
                  child: IconButton(
                    color: Color(0xFF8B5CF6),
                    iconSize: 32,
                    icon: Icon(Icons.explore),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _goToTheLake,
        child: Icon(Icons.location_searching),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(ulaanbaatar));
  }
}
