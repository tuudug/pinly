import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pinly/screens/phone_verify.dart';

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
        fontFamily: "Sk-Modernist",
        primarySwatch: Colors.deepPurple,
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

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _opacity = 1.0;
      });
    });
    return Scaffold(
      body: Center(
        child: SafeArea(
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 0,
                child: AnimatedOpacity(
                  opacity: _opacity, 
                  duration: const Duration(milliseconds: 2000),
                  child: Circle(color: Color(0xFF7941FB), radius: 900.0)),
              ),
              Positioned(
                top: -40,
                child: AnimatedOpacity(
                  opacity: _opacity, 
                  duration: const Duration(milliseconds: 4500),
                  child: const Circle(color: Color(0xFF6F33F8), radius: 600.0)),
              ),
              Positioned(
                top: -120,
                child: AnimatedOpacity(
                  opacity: _opacity, 
                  duration: const Duration(milliseconds: 3500),
                  child: const Circle(color: Color(0xFF8551FD), radius: 550.0)),
              ),
               Positioned(
                top: -120,
                child: AnimatedOpacity(
                  opacity: _opacity, 
                  duration: const Duration(milliseconds: 2500),
                  child: const Circle(color: Color(0xFF9566FF), radius: 450.0)),
              ),//
               Positioned(
                top: -250,
                child: AnimatedOpacity(
                  opacity: _opacity, 
                  duration: const Duration(milliseconds: 1500),
                  child: const Circle(color: Color(0xFFA37BFF), radius: 500.0)),
              ),
               Positioned(
                top: -230,
                child: AnimatedOpacity(
                  opacity: _opacity, 
                  duration: const Duration(milliseconds: 500),
                  child: const Circle(color: Color(0xFFAE8BFF), radius: 400.0)),
              ),//
              const Positioned(
                top: -30,
                child: Circle(
                  color: Color(0xFFD3C3FF),
                  radius: 200.0,
                ),
              ),
              const Positioned(
                  top: 0,
                  child: Image(
                    image: AssetImage('assets/logo.png'),
                    width: 125,
                    height: 125,
                  )),
              const Positioned(
                top: 250,
                child: Text(
                  "Welcome to Pinly",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 36),
                ),
              ),
              const Positioned(
                bottom: 150,
                child: Text(
                  "Ready to have a fun time?",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 24),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyMobilePage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6F33F8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(90, 0, 90, 0),
                            child: Text(
                              'Start',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 16),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}