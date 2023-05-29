import 'dart:developer';
import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinly/firestore/user.dart';
import 'package:pinly/models/user.dart';
import 'package:pinly/providers/user.dart';
import 'package:pinly/screens/main_map.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OtpPage extends ConsumerStatefulWidget {
  final String verificationId;
  final String phoneNumber;
  const OtpPage(
      {super.key, required this.verificationId, required this.phoneNumber});
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends ConsumerState<OtpPage>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  String enteredCode = '';
  bool loading = false;
  bool inputDisabled = false;
  bool resendBlocked = false;
  String otpStatus = "";
  late String verificationIdState;

  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    verificationIdState = widget.verificationId;
    _controller = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(0.01, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));
    // Add a status listener to reset the animation
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reset();
      }
    });
  }

  void shakeWidget() {
    _controller.reset();
    _controller.forward();
  }

  Future<void> _signInWithPhoneNumber(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationIdState,
      smsCode: smsCode,
    );

    try {
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final Uuid uuid = Uuid();
      final String session_id = uuid.v4();
      final String? userUid = userCredential.user?.uid;
      final String? phone_number = userCredential.user?.phoneNumber;

      await storage.write(key: "user_uid", value: userUid);
      await storage.write(key: "session_id", value: session_id);

      if (userCredential.additionalUserInfo?.isNewUser == true) {
        db.collection("users").doc(userUid).set(<String, dynamic>{
          "session_id": session_id,
          "friends": [],
          "friend_requests": [],
          "phone_number": phone_number,
          "uid": userUid,
          "username": null,
        });
        ref.read(loggedInUserProvider.notifier).state = UserAccount(
            id: userUid!,
            username: null,
            phoneNumber: phone_number!,
            friendRequests: [],
            friends: []);
      } else {
        db.collection("users").doc(userUid).update(<String, String>{
          "session_id": session_id,
        });
        ref.read(loggedInUserProvider.notifier).state =
            await UserDb.getUser(userUid!) ?? UserAccount.empty();
      }
      setState(() {
        _succeedInput();
      });
    } catch (e) {
      setState(() {
        _failInput();
      });
      print('Error occurred while signing in: $e');
    }
  }

  void _addCode(String digit) {
    if (!inputDisabled) {
      setState(() {
        if (enteredCode.length < 6) {
          enteredCode += digit;
        }
      });
      if (enteredCode.length == 6) {
        setState(() {
          inputDisabled = true;
          loading = true;
        });
        _signInWithPhoneNumber(enteredCode);
      }
    }
  }

  void _removeCode() {
    setState(() {
      if (enteredCode.isNotEmpty) {
        enteredCode = enteredCode.substring(0, enteredCode.length - 1);
        setState(() {
          loading = false;
        });
      }
    });
  }

  void _failInput() {
    shakeWidget();
    setState(() {
      otpStatus = "FAILED";
      loading = false;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        inputDisabled = false;
        otpStatus = "";
        enteredCode = "";
      });
    });
  }

  void _succeedInput() {
    shakeWidget();
    setState(() {
      otpStatus = "SUCCESS";
      loading = false;
    });
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        inputDisabled = false;
        otpStatus = "";
        enteredCode = "";
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return MainMap();
        }));
      });
    });
  }

  void _resendCode() async {
    setState(() {
      resendBlocked = true;
    });

    await _auth.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber,
      timeout: const Duration(seconds: 30),
      verificationCompleted: (credential) {},
      verificationFailed: (error) {},
      codeSent: (verificationIdResent, [int? forceResendingToken]) {
        verificationIdState = verificationIdResent;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    Future.delayed(const Duration(seconds: 60), () {
      setState(() {
        resendBlocked = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(36.0),
              child: Text(
                'Type in the verification code we’ve just sent to you',
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16.0),
            SlideTransition(
              position: _animation,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (int i = 0; i < 6; i++)
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 150),
                      opacity: enteredCode.length > i ? 1.0 : 0.5,
                      child: Container(
                        width: 47.0,
                        height: 50.0,
                        decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.0, color: const Color(0xFFBDBDBD)),
                          borderRadius: BorderRadius.circular(16.0),
                          color: otpStatus == ""
                              ? (enteredCode.length > i
                                  ? const Color(0xFF9B51E0)
                                  : Colors.transparent)
                              : otpStatus == "FAILED"
                                  ? Colors.red
                                  : otpStatus == "SUCCESS"
                                      ? Colors.green
                                      : Colors.transparent,
                        ),
                        child: Center(
                            child: loading == false
                                ? otpStatus == ""
                                    ? (Text(
                                        enteredCode.length > i
                                            ? enteredCode[i]
                                            : '',
                                        style: const TextStyle(
                                            fontSize: 32.0,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w800),
                                      ))
                                    : otpStatus == "FAILED"
                                        ? (const Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ))
                                        : (const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                          ))
                                : const Padding(
                                    padding: EdgeInsets.all(12.0),
                                    child: CircularProgressIndicator(
                                      strokeWidth: 3,
                                      color: Colors.white,
                                    ),
                                  )),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DialPadButton(
                  digit: '1',
                  onPressed: () => _addCode('1'),
                ),
                DialPadButton(
                  digit: '2',
                  onPressed: () => _addCode('2'),
                ),
                DialPadButton(
                  digit: '3',
                  onPressed: () => _addCode('3'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DialPadButton(
                  digit: '4',
                  onPressed: () => _addCode('4'),
                ),
                DialPadButton(
                  digit: '5',
                  onPressed: () => _addCode('5'),
                ),
                DialPadButton(
                  digit: '6',
                  onPressed: () => _addCode('6'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DialPadButton(
                  digit: '7',
                  onPressed: () => _addCode('7'),
                ),
                DialPadButton(
                  digit: '8',
                  onPressed: () => _addCode('8'),
                ),
                DialPadButton(
                  digit: '9',
                  onPressed: () => _addCode('9'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DialPadButton(
                  digit: '',
                  onPressed: () => {},
                ),
                DialPadButton(
                  digit: '0',
                  onPressed: () => _addCode('0'),
                ),
                DialPadButton(
                  icon: Icons.backspace_outlined,
                  onPressed: _removeCode,
                  digit: '',
                ),
              ],
            ),
            const SizedBox(height: 32.0),
            Center(
              child: TextButton(
                child: Text(
                  'Send again',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: (!resendBlocked)
                          ? const Color(0xFF8B5CF6)
                          : Colors.grey,
                      fontWeight: FontWeight.w800),
                ),
                onPressed: () {
                  if (!resendBlocked) _resendCode();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DialPadButton extends StatelessWidget {
  final String digit;
  final IconData icon;
  final VoidCallback onPressed;

  const DialPadButton({
    Key? key,
    required this.digit,
    this.icon = Icons.circle,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: 24.0,
      icon: icon != Icons.circle
          ? Icon(icon)
          : Text(
              digit,
              style: const TextStyle(fontSize: 24),
            ),
      onPressed: onPressed,
    );
  }
}
