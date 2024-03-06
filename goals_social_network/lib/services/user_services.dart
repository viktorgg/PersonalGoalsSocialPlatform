

import 'package:shared_preferences/shared_preferences.dart';

import '../models/user.dart';

class UserServices {

  static Future<void> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setInt("userId", user.userId);
    prefs.setString("firstName", user.firstName);
    prefs.setString("lastName", user.lastName);
    prefs.setString("email", user.email);
    prefs.setString("token", user.token);

    print(prefs.getString("token"));
  }

  static Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    int? userId = prefs.getInt("userId");
    String? firstName = prefs.getString("firstName");
    String? lastName = prefs.getString("lastName");
    String? email = prefs.getString("email");
    String? token = prefs.getString("token");

    if (userId == null || firstName == null || lastName == null || email == null || token == null) {
      return User(
        userId: 0,
        firstName: '',
        lastName: '',
        email: '',
        token: '',
      );
    }
    return User(
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        email: email,
        token: token,
    );
  }

  static void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.remove("userId");
    prefs.remove("firstName");
    prefs.remove("lastName");
    prefs.remove("email");
    prefs.remove("token");
  }

  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }
}