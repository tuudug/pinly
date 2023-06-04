import 'dart:async';
import 'dart:developer';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:latlong2/latlong.dart';
import 'package:pinly/screens/profile_page.dart';
import 'package:pinly/widgets/friend_profile.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';
import 'package:pinly/firestore/user.dart';
import 'package:pinly/models/user.dart';
import 'package:pinly/providers/user.dart';

import 'friends_page.dart';

class MainMap extends ConsumerStatefulWidget {
  const MainMap({super.key});

  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends ConsumerState<MainMap>
    with TickerProviderStateMixin {
  bool _dialogOpen = false;
  bool isMyLocationWatcherSetup = false;
  double? myLat;
  double? myLong;

  String locationStatus = "UNKNOWN";
  double _zoomValue = 15.0;
  final TextEditingController _usernameController = TextEditingController();
  final locations = FirebaseDatabase.instance.ref('locations');
  late final _mapController = AnimatedMapController(vsync: this);

  final List<Marker> _markers = [];

  _setupLocationWatcher() {
    locations.onValue.listen((DatabaseEvent event) {
      _updateMarkers();
    });
  }

  _setupMyLocationWatcher() {
    if (!isMyLocationWatcherSetup) {
      Location location = new Location();
      location.changeSettings(
          accuracy: LocationAccuracy.high, interval: 10000, distanceFilter: 5);
      location.onLocationChanged.listen((LocationData currentLocation) {
        final myNode = FirebaseDatabase.instance
            .ref('locations/${ref.read(loggedInUserProvider).id}');
        myNode.set({
          'name': ref.read(loggedInUserProvider).username,
          'lat': currentLocation.latitude,
          'long': currentLocation.longitude,
          'timestamp': DateTime.now().toLocal().toString(),
        });
        myLat = currentLocation.latitude;
        myLong = currentLocation.longitude;
      });
    }
  }

  _updateMarkers() {
    locations.get().then((snapshot) => {
          snapshot.children.forEach((element) {
            final data = Map<String, dynamic>.from(element.value as Map);
            final key = element.key.toString();
            final friends = ref.read(loggedInUserProvider).friends;
            final user = ref.read(loggedInUserProvider);
            if (friends.contains(key) || key == user.id) {
              bool found = false;
              for (int i = 0; i < _markers.length; i++) {
                if (_markers[i].key == Key(key)) {
                  found = true;
                  setState(() {
                    _markers[i] = Marker(
                      key: Key(key),
                      builder: (context) {
                        if (key == user.id) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.pink,
                              borderRadius: BorderRadius.circular(48),
                            ),
                          );
                        }
                        return GestureDetector(
                          onTap: () {
                            _showFriendProfile(data['name'], context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF8B5CF6),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: Text(
                                data['name'][0],
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      point: LatLng(data['lat'], data['long']),
                      width: key == user.id ? 12 : 45,
                      height: key == user.id ? 12 : 45,
                    );
                  });
                }
              }
              if (found != true) {
                setState(() {
                  _markers.add(Marker(
                    key: Key(key),
                    builder: (context) {
                      return FlutterLogo(size: 80);
                    },
                    point: LatLng(data['lat'], data['long']),
                    width: 80,
                    height: 80,
                  ));
                });
              }
            } else {
              //_markers.remove(key);
            }
          }),
        });
  }

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

  _checkLocationPermission() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        locationStatus = "SERVICE_NOT_ENABLED";
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        locationStatus = "PERMISSION_NOT_GRANTED";
        return;
      }
    }

    locationStatus = "GRANTED";
    return;
  }

  @override
  void initState() {
    _checkLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _checkUsername(context));
    if (locationStatus == "GRANTED") {
      _setupMyLocationWatcher();
      isMyLocationWatcherSetup = true;
    }
    _setupLocationWatcher();

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              maxZoom: 18.0,
              center: LatLng(47.9188, 106.9176),
              zoom: 12.4746,
              onPositionChanged: (position, hasGesture) {
                setState(() {
                  _zoomValue = position.zoom!;
                });
              },
            ),
            mapController: _mapController,
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'mn.tuudug.pinlyf',
              ),
              MarkerLayer(markers: _markers),
            ],
            //markers: _markers.values.toSet(),
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(),
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
          ),
          Positioned(
            top: 0,
            right: -10,
            bottom: 0,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 200, 0, 100),
              child: Opacity(
                opacity: _zoomValue > 10.0 ? 0.5 : 0.0,
                child: SfSlider.vertical(
                  min: 10.0,
                  max: 18.0,
                  value: _zoomValue,
                  interval: 20,
                  showTicks: false,
                  showLabels: false,
                  enableTooltip: false,
                  minorTicksPerInterval: 1,
                  onChanged: (dynamic value) {
                    setState(() {
                      _zoomValue = value;
                      _mapController.move(_mapController.center, value);
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: _goToMe,
        child: Icon(Icons.location_searching),
      ),
    );
  }

  void _showFriendProfile(String username, BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 750.0,
          child: Center(child: FriendProfile(username: username)),
        );
      },
    );
  }

  Future<void> _goToMe() async {
    if (myLat != null && myLong != null) {
      _mapController.animateTo(dest: LatLng(myLat!, myLong!), zoom: 14.4748);
    }
  }

  Future<void> _startingZoom() async {
    log("NIGGA");
    if (myLat != null && myLong != null) {
      _mapController.animateTo(
          dest: LatLng(47.9188, 106.9176), zoom: 14.4748, curve: Curves.easeIn);
    }
  }
}
