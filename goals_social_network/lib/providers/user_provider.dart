import 'package:flutter/cupertino.dart';

import '../models/auth_user.dart';

class UserProvider extends ChangeNotifier {
  late AuthUser _user;

  AuthUser get user => _user;

  void setUser(AuthUser user) {
    _user = user;
    notifyListeners();
  }
}