import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:firebase_core/firebase_core.dart';
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

class _MainMapState extends ConsumerState<MainMap> {
  bool _dialogOpen = false;
  bool isMyLocationWatcherSetup = false;
  double? myLat;
  double? myLong;

  String locationStatus = "UNKNOWN";
  double _value = 15.0;
  final TextEditingController _usernameController = TextEditingController();
  final locations = FirebaseDatabase.instance.ref('locations');
  late final GoogleMapController _mapController;

  final Map<String, Marker> _markers = {};
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
            if (friends.contains(key) ||
                key == ref.read(loggedInUserProvider).id) {
              _markers[key] = Marker(
                  icon: key == ref.read(loggedInUserProvider).id
                      ? BitmapDescriptor.defaultMarkerWithHue(321.0)
                      : BitmapDescriptor.defaultMarker,
                  markerId: MarkerId(element.key.toString()),
                  position: LatLng(data['lat'], data['long']),
                  infoWindow: InfoWindow(
                    title: data['name'],
                    snippet: data['timestamp'] != null
                        ? 'Last Updated: ${data['timestamp']}'
                        : "Last Updated Unknown",
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
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: ulaanbaatar,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            onCameraMove: (position) {
              setState(() {
                _value = position.zoom;
              });
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
          ),
            Positioned(
              top: 0,
              right: -10,
              bottom: 0,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 200, 0, 100),
                child: Opacity(
                  opacity: _value > 10.0 ? 0.5 : 0.0,
                  child: SfSlider.vertical(
                      min: 10.0,
                      max: 21.0,
                      value: _value,
                      interval: 20,
                      showTicks: false,
                      showLabels: false,
                      enableTooltip: false,
                      minorTicksPerInterval: 1,
                      onChanged: (dynamic value) {
                        setState(() {
                          _value = value;
                          _mapController.moveCamera(CameraUpdate.zoomTo(value));
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

  Future<void> _goToMe() async {
    if (myLat != null && myLong != null) {
      await _mapController
          .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(myLat!, myLong!),
        zoom: 14.4746,
      )));
    }
  }
}
