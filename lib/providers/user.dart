import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinly/models/user.dart';

final loggedInUserProvider = StateProvider<UserAccount>((ref) => UserAccount(id: "", username: "", phoneNumber: "", friends: [], friendRequests: []));
final isLoggedInProvider = StateProvider<bool>((ref) => false);

