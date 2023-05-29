class UserAccount {
  String id;
  String username;
  String phoneNumber;
  List<String> friends;
  List<String> friendRequests;

  UserAccount({
    required this.id,
    required this.username,
    required this.phoneNumber,
    required this.friends,
    required this.friendRequests,
  });
}
