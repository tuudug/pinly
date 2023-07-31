import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:geolocator/geolocator.dart';

import 'main_map.dart';

class LocationPermissionScreen extends StatefulWidget {
  @override
  State<LocationPermissionScreen> createState() =>
      _LocationPermissionScreenState();
}

class _LocationPermissionScreenState extends State<LocationPermissionScreen> {
  bool permissionGranted = false;

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onFocusGained: () async {
        final permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) {
          setState(() {
            permissionGranted = true;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Location Permission'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                permissionGranted ? Icons.thumb_up : Icons.location_disabled,
                size: 100,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(fontSize: 18, color: Colors.black),
                  children: [
                    TextSpan(
                      text: permissionGranted
                          ? 'Thank you for granting permission!\n\n'
                          : 'Location service permissions are required to use this app.\n\n',
                    ),
                    TextSpan(
                      text: permissionGranted
                          ? 'Enjoy the app =]'
                          : 'We need to access your location to provide you with the best experience.',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (!permissionGranted) {
                    AppSettings.openAppSettings(type: AppSettingsType.settings);
                  } else {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainMap()),
                    );
                  }
                },
                child: Text(permissionGranted
                    ? 'Continue to app'
                    : 'Enable Location Services'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
