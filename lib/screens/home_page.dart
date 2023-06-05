import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pinly/screens/phone_verify.dart';

import '../widgets/circle.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

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
                    child: Circle(color: Color(0xFF7941FB), radius: 1200.0)),
              ),
              Positioned(
                top: -40,
                child: AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(milliseconds: 4500),
                    child:
                        const Circle(color: Color(0xFF6F33F8), radius: 600.0)),
              ),
              Positioned(
                top: -120,
                child: AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(milliseconds: 3500),
                    child:
                        const Circle(color: Color(0xFF8551FD), radius: 550.0)),
              ),
              Positioned(
                top: -120,
                child: AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(milliseconds: 2500),
                    child:
                        const Circle(color: Color(0xFF9566FF), radius: 450.0)),
              ), //
              Positioned(
                top: -250,
                child: AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(milliseconds: 1500),
                    child:
                        const Circle(color: Color(0xFFA37BFF), radius: 500.0)),
              ),
              Positioned(
                top: -230,
                child: AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(milliseconds: 500),
                    child:
                        const Circle(color: Color(0xFFAE8BFF), radius: 400.0)),
              ), //
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
                bottom: 100,
                child: Text(
                  "Ready to have a fun time?",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 18),
                ),
              ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 2500),
                curve: Curves.easeInOutCubicEmphasized,
                left: 0,
                right: 0,
                bottom: _offsetAnimation.value.dy * -100,
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyMobilePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          SizedBox(width: 8),
                          Text(
                            'Start! ',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                            size: 16,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
