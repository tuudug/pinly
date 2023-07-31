import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:pinly/firestore/friends.dart';

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
        height: MediaQuery.of(context).size.height * 0.35,
        width: double.infinity,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Center(
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
                  overflow: TextOverflow.ellipsis,
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
                Center(
                  child: TextButton.icon(
                      onPressed: () async {
                        await FriendsDb.addFriendByPhoneNumber(
                                '+976${_phoneNumberController.text}')
                            .then((result) {
                          if (result == false) {
                            CherryToast.error(
                                    title: Text("Error sending request"))
                                .show(context);
                          } else {
                            Navigator.pop(context);
                            CherryToast.success(
                                    title:
                                        Text("Friend invite sent succesfully!"))
                                .show(context);
                          }
                        });
                      },
                      icon: Icon(Icons.send_and_archive_outlined),
                      label: Text("Send Invite")),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
