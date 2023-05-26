import 'package:flutter/material.dart';

class OtpPage extends StatefulWidget {
  @override
  _OtpPageState createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  String enteredCode = '';

  void _addCode(String digit) {
    setState(() {
      if (enteredCode.length < 6) {
        enteredCode += digit;
      }
    });
  }

  void _removeCode() {
    setState(() {
      if (enteredCode.isNotEmpty) {
        enteredCode = enteredCode.substring(0, enteredCode.length - 1);
      }
    });
  }

  void _submitCode() {
    // Perform validation or verification with the entered code
    // Add your logic here
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
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(36.0),
              child: Text(
                'Type in the verification code we’ve just sent to you',
                style: TextStyle(fontSize: 18.0),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < 6; i++)
                  AnimatedOpacity(
                    duration: Duration(milliseconds: 150),
                    opacity: enteredCode.length > i ? 1.0 : 0.5,
                    child: Container(
                      width: 57.0,
                      height: 60.0,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Color(0xFFBDBDBD)),
                        borderRadius: BorderRadius.circular(16.0),
                        color: enteredCode.length > i ? Color(0xFF9B51E0) : Colors.transparent,
                      ),
                      child: Center(
                        child: Text(
                          enteredCode.length > i ? enteredCode[i] : '',
                          style: TextStyle(fontSize: 32.0, color: Colors.white, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.0),
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
            SizedBox(height: 16.0),
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
            SizedBox(height: 16.0),
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
            SizedBox(height: 16.0),
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
            SizedBox(height: 32.0),
            Center(
              child: TextButton(
                child: Text(
                  'Send again',
                  style: TextStyle(fontSize: 16.0, color: Color(0xFF8B5CF6), fontWeight: FontWeight.w800),
                ),
                onPressed: _submitCode,
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
      icon: icon != Icons.circle ? Icon(icon) : Text(digit, style: TextStyle(fontSize: 24),),
      onPressed: onPressed,
    );
  }
}
