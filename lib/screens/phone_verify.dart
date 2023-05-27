import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinly/screens/phone_otp.dart';

class MyMobilePage extends StatefulWidget {
  @override
  _MyMobilePageState createState() => _MyMobilePageState();
}

class _MyMobilePageState extends State<MyMobilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneNumberController = TextEditingController();
  String _verificationId = '';

  Future<void> _verifyPhoneNumber() async {
    verificationCompleted(AuthCredential authCredential) async {
      await _auth.signInWithCredential(authCredential);
    }

    verificationFailed(FirebaseAuthException authException) {
      log('Phone number verification failed. Code: ${authException.code}. Message: ${authException.message}');
    }

    codeSent(String verificationId, [int? forceResendingToken]) async {
      _verificationId = verificationId;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpPage(verificationId: _verificationId),
        ),
      );
    }

    codeAutoRetrievalTimeout(String verificationId) {
      // Auto-resolution timed out
      _verificationId = verificationId;
    }

    await _auth.verifyPhoneNumber(
      phoneNumber: '+976${_phoneNumberController.text}',
      timeout: const Duration(seconds: 30),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
  }

  _onInputChanged(value) {
    setState(() {});
  }

  @override
  void dispose() {
    _phoneNumberController.dispose();
    super.dispose();
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(32, 64, 32, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Hi!',
                  style: TextStyle(
                    color: Colors.deepPurpleAccent,
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Text(
                'Please enter your valid phone number. We will send you a 4-digit code to verify your account.',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32.0),
              TextField(
                maxLength: 8,
                onChanged: (value) => {_onInputChanged(value)},
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number (+976)',
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () => {
                  if (_phoneNumberController.text.length == 8)
                    _verifyPhoneNumber()
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _phoneNumberController.text.length != 8
                      ? Colors.grey
                      : Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    'Continue',
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
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
