import 'package:flutter/material.dart';

class AddFriendBottomSheet extends StatefulWidget {
  const AddFriendBottomSheet({super.key});

  @override
  State<AddFriendBottomSheet> createState() => _AddFriendBottomSheetState();
}

class _AddFriendBottomSheetState extends State<AddFriendBottomSheet> {
  final TextEditingController _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: 250,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter your friend's phone number",
                style: TextStyle(
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "You will become friends when they accept your request.",
                style: TextStyle(
                  fontSize: 14.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                height: 32,
              ),
              TextField(
                autofocus: true,
                maxLength: 8,
                onChanged: (value) => {},
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number (+976)',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
