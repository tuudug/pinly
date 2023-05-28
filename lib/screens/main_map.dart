import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MainMap extends StatefulWidget {
  const MainMap({super.key});

  @override
  _MainMapState createState() => _MainMapState();
}

class _MainMapState extends State<MainMap> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(47.8864, 106.9057),
    zoom: 14.4746,
  );

  static const CameraPosition _kLake = CameraPosition(
    target: LatLng(47.8864, 106.9057),
    zoom: 14,
  );

  bool _isSideMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kGooglePlex,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Color(0xFF8B5CF6),
                width: 1,
              ),
            ),
            margin: EdgeInsets.only(left: 8, top: 24),
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
                  margin: EdgeInsets.only(right: 8, top: 24),
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
                  margin: EdgeInsets.only(right: 8, top: 24 + 56),
                  child: IconButton(
                    color: Color(0xFF8B5CF6),
                    iconSize: 32,
                    icon: Icon(Icons.group),
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
                  margin: EdgeInsets.only(right: 8, top: 24 + 56 + 56),
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
    await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}
