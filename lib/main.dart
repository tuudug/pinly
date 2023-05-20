import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'widgets/circle.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            const Positioned(
              top: 0,
              left: -155,
              child: Circle(color: Color(0xFF7941FB), radius: 700.0),
            ),
            const Positioned(
              top: -40,
              left: -105,
              child: Circle(color: Color(0xFF6F33F8), radius: 600.0),
            ),
            const Positioned(
              top: -120,
              left: -85,
              child: Circle(color: Color(0xFF8551FD), radius: 550.0),
            ),
            const Positioned(
              top: -120,
              left: -40,
              child: Circle(color: Color(0xFF9566FF), radius: 450.0),
            ),
            const Positioned(
              top: -250,
              left: -65,
              child: Circle(color: Color(0xFFA37BFF), radius: 500.0),
            ),
            const Positioned(
              top: -230,
              left: -17,
              child: Circle(color: Color(0xFFAE8BFF), radius: 400.0),
            ),
            const Positioned(
              top: -30,
              left: 85,
              child: Circle(
                color: Color(0xFFD3C3FF),
                radius: 200.0,
              ),
            ),
            const Positioned(
                top: -75,
                left: 37,
                child: Image(
                  image: AssetImage('assets/logo.png'),
                  width: 300,
                  height: 300,
                )),
            const Positioned(
                top: 200,
                left: 43,
                child: Text(
                  "Welcome to Pinly",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Sk-Modernist",
                      fontWeight: FontWeight.w800,
                      fontSize: 36),
                )),
            const Positioned(
                top: 350,
                left: 100,
                child: Text(
                  "Have a fun time",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: "Sk-Modernist",
                      fontSize: 24,
                      fontWeight: FontWeight.w800),
                )),
            Positioned(
              top: 500,
              left: -5,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(45.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(60, 32, 60, 32),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF6F33F8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(90, 0, 90, 0),
                          child: Text(
                            'LOGIN',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      const Text(
                        'OR',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          primary: const Color(0xFF6F33F8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.fromLTRB(82, 0, 82, 0),
                          child: Text(
                            'SIGN UP',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
Text(
              'You have pushed the button this many times:',
              style: TextStyle(
                  fontFamily: 'Sk-Modernist', fontWeight: FontWeight.w800),
            ),
*/
