import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pinly/screens/home_page.dart';
import 'package:pinly/screens/phone_verify.dart';
import 'package:pinly/try_to_login.dart';

import 'firebase_options.dart';
import 'widgets/circle.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: "Sk-Modernist",
        primarySwatch: Colors.deepPurple,
      ),
      home: const TryToLoginPage(),
    );
  }
}
