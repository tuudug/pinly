import 'dart:async';
import 'dart:developer';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:pinly/firestore/places.dart';
import 'package:pinly/providers/selected_place_type_provider.dart';
import 'package:pinly/screens/profile_page.dart';
import 'package:pinly/widgets/friend_profile.dart';
import 'package:pinly/widgets/friend_timestamp_box.dart';
import 'package:pinly/widgets/pill_badge.dart';
import 'package:pinly/widgets/place_type_buttons.dart';
import 'package:pinly/widgets/pulsating_circle.dart';
import 'package:relative_time/relative_time.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pinly/firestore/user.dart';
import 'package:pinly/models/user.dart';
import 'package:pinly/providers/user.dart';

import '../models/place.dart';
import '../widgets/main_map_toolbar.dart';
import 'friends_page.dart';

class MainMap extends ConsumerStatefulWidget {
  const MainMap({super.key});

  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends ConsumerState<MainMap>
    with TickerProviderStateMixin {
  final String styleUrl =
      "https://api.mapbox.com/styles/v1/tuudug/clid418pj001w01r0fhs8fptu/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoidHV1ZHVnIiwiYSI6ImNsaWN6ZHBtaTBvZmIzc28ybmt2eWNldmEifQ.AxQ4iSKGHr34_zSbxw-4kA";

  bool _dialogOpen = false;
  bool isMyLocationWatcherSetup = false;
  double? myLat;
  double? myLong;
  String? focusedFriend;

  String locationStatus = "UNKNOWN";
  double _zoomValue = 15.0;
  final TextEditingController _usernameController = TextEditingController();
  final locations = FirebaseDatabase.instance.ref('locations');
  late final _mapController = AnimatedMapController(vsync: this);

  final List<Marker> _friendMarkers = [];
  final List<Marker> _placeMarkers = [];

  _setupLocationWatcher() {
    locations.onValue.listen((DatabaseEvent event) {
      _updateFriendMarkers();
    });
  }

  _setupMyLocationWatcher() {
    if (!isMyLocationWatcherSetup) {
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100,
      );
      Geolocator.getPositionStream(locationSettings: locationSettings)
          .listen((Position? position) {
        if (position != null) {
          final myNode = FirebaseDatabase.instance
              .ref('locations/${ref.read(loggedInUserProvider).id}');
          myNode.set({
            'name': ref.read(loggedInUserProvider).username,
            'lat': position.latitude,
            'long': position.longitude,
            'timestamp': DateTime.now().toLocal().toString(),
          });
          myLat = position.latitude;
          myLong = position.longitude;
        }
      });
    }
  }

  _updateFriendMarkers() {
    locations.get().then((snapshot) => {
          snapshot.children.forEach((element) {
            final data = Map<String, dynamic>.from(element.value as Map);
            final key = element.key.toString();
            final friends = ref.read(loggedInUserProvider).friends;
            final user = ref.read(loggedInUserProvider);
            if (friends.contains(key) || key == user.id) {
              bool found = false;
              for (int i = 0; i < _friendMarkers.length; i++) {
                if (_friendMarkers[i].key == Key(key)) {
                  found = true;
                  setState(() {
                    _friendMarkers[i] = Marker(
                      key: Key(key),
                      builder: (context) {
                        if (key == user.id) {
                          return Container();
                        }
                        return GestureDetector(
                          onTap: () {
                            if (focusedFriend == key) {
                              _showFriendProfile(data['name'], context);
                            }
                            _goToCoords(data['lat'], data['long'])
                                .then((_) => focusedFriend = key);
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: focusedFriend == key
                                ? ([
                                    Positioned(
                                        top: -90,
                                        child: FriendTimestampBox(
                                            text: RelativeTime.locale(
                                                    const Locale('en'),
                                                    timeUnits: const <TimeUnit>[
                                                      TimeUnit.day,
                                                      TimeUnit.hour,
                                                      TimeUnit.minute,
                                                    ],
                                                    numeric: true)
                                                .format(DateTime.parse(
                                                    data['timestamp'])))),
                                    PulsatingCircle(
                                        size: focusedFriend == key ? 100 : 0,
                                        color: Colors.greenAccent),
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF8B5CF6),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: Text(
                                          data['name'][0],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ])
                                : [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF8B5CF6),
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Center(
                                        child: Text(
                                          data['name'][0],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                          ),
                        );
                      },
                      point: LatLng(data['lat'], data['long']),
                      width: focusedFriend == key ? 100 : 55,
                      height: focusedFriend == key ? 100 : 55,
                    );
                  });
                }
              }
              if (found != true) {
                setState(() {
                  _friendMarkers.add(Marker(
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

  _loadPlaceMarkers() async {
    List<Place> places = await PlacesDb.getAll();
    for (int i = 0; i < places.length; i++) {
      var placeTypeNumber;
      var type = places[i].type;
      type == "eatery"
          ? placeTypeNumber = 0
          : type == "meet"
              ? placeTypeNumber = 1
              : type == "party"
                  ? placeTypeNumber = 2
                  : placeTypeNumber = 3;
      _placeMarkers.add(Marker(
          point: LatLng(places[i].lat, places[i].long),
          builder: (context) {
            return GestureDetector(
              onTap: () {
                _goToCoords(places[i].lat, places[i].long);
                showModalBottomSheet(
                    barrierColor: Colors.black.withAlpha(1),
                    context: context,
                    builder: (context) {
                      return SizedBox(
                        height: 200,
                        child: Card(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 4,
                                child: Container(
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: Image.network(
                                      'https://picsum.photos/200',
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 6,
                                child: Container(
                                  color: Colors.white,
                                  child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            places[i].type == "eatery"
                                                ? Icon(Icons.restaurant)
                                                : places[i].type == "meet"
                                                    ? Icon(Icons
                                                        .meeting_room_rounded)
                                                    : places[i].type == "party"
                                                        ? Icon(
                                                            Icons.celebration)
                                                        : Icon(Icons
                                                            .sports_esports),
                                            Text(
                                              " ${places[i].name}",
                                              style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                        PillBadge(
                                            badgeColor: Colors.purple,
                                            textColor: Colors.white,
                                            text: "Verified"),
                                        SizedBox(height: 8),
                                        ElevatedButton.icon(
                                            onPressed: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return Dialog.fullscreen(
                                                      child: Text(
                                                          "Place more info todo"),
                                                    );
                                                  });
                                            },
                                            icon: Icon(Icons.expand_less),
                                            label: Text("More Info"))
                                      ]),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              },
              child: Icon(
                Icons.location_on,
                color: Colors.purpleAccent,
                size: ref.read(selectedPlaceTypeProvider) == placeTypeNumber
                    ? 42
                    : 0,
              ),
            );
          }));
    }
  }

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
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        locationStatus = "SERVICE_NOT_ENABLED";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.denied) {
        setState(() {
          locationStatus = "PERMISSION_NOT_GRANTED";
        });
        return;
      }
    }

    setState(() {
      locationStatus = "GRANTED";
    });
    return;
  }

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _loadPlaceMarkers();
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
              interactiveFlags:
                  InteractiveFlag.pinchZoom | InteractiveFlag.drag,
              maxZoom: 18.0,
              center: LatLng(47.9188, 106.9176),
              zoom: 12.4746,
              onPositionChanged: (position, hasGesture) {
                setState(() {
                  focusedFriend = null;
                  _zoomValue = position.zoom!;
                });
              },
              onTap: (position, latlng) {
                setState(() {
                  focusedFriend = null;
                });
              },
            ),
            mapController: _mapController,
            children: (locationStatus == "GRANTED")
                ? ([
                    TileLayer(
                        urlTemplate: styleUrl,
                        tileProvider: FMTC.instance('mapStore').getTileProvider(
                            FMTCTileProviderSettings(
                                cachedValidDuration: const Duration(days: 31),
                                maxStoreLength: 2000))),
                    CurrentLocationLayer(),
                    MarkerLayer(
                        markers: ref.watch(selectedPlaceTypeProvider) == -1
                            ? _friendMarkers
                            : _placeMarkers),
                  ])
                : [
                    TileLayer(
                      urlTemplate: styleUrl,
                      tileProvider: FMTC.instance('mapStore').getTileProvider(
                          FMTCTileProviderSettings(
                              cachedValidDuration: const Duration(days: 31),
                              maxStoreLength: 2000)),
                    ),
                    MarkerLayer(
                        markers: ref.watch(selectedPlaceTypeProvider) == -1
                            ? _friendMarkers
                            : _placeMarkers),
                  ],
            //markers: _markers.values.toSet(),
          ),
          SafeArea(
              child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: MainMapToolbar(),
          )),
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
                      focusedFriend = null;
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(48, 0, 0, 16),
              child: FloatingActionButton(
                heroTag: "friends",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FriendsPage(),
                    ),
                  );
                },
                child: Icon(Icons.diversity_1),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 48),
              child: FloatingActionButton(
                heroTag: "gotome",
                onPressed: _goToMe,
                child: Icon(Icons.location_searching),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 48, 16),
              child: FloatingActionButton(
                heroTag: "profile",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ),
                  );
                },
                child: Icon(Icons.account_circle),
              ),
            ),
          ),
        ],
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
    focusedFriend = null;
    if (myLat != null && myLong != null) {
      _mapController.animateTo(dest: LatLng(myLat!, myLong!), zoom: 14.4748);
    }
  }

  Future<void> _goToCoords(double lat, double long) async {
    await _mapController.animateTo(
        dest: LatLng(lat, long), zoom: 17.4748, rotation: 0);
  }

  Future<void> _startingZoom() async {
    log("NIGGA");
    if (myLat != null && myLong != null) {
      _mapController.animateTo(
          dest: LatLng(47.9188, 106.9176), zoom: 14.4748, curve: Curves.easeIn);
    }
  }
}
