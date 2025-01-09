import 'package:flutter/cupertino.dart';

enum Role { admin, user }

class UserModel {
  final String id;
  final String email;
  final Role role;

  UserModel({required this.id, required this.email, required this.role});
}

class UserProvider with ChangeNotifier {
  UserModel? _currentUser;

  UserModel? get currentUser => _currentUser;

  void setCurrentUser(UserModel? user) {
    _currentUser = user;
    notifyListeners();
  }
}
