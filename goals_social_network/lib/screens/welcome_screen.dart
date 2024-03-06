import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';

class WelcomeScreen extends StatelessWidget {
  final User user;

  const WelcomeScreen({ super.key, required this.user });

  @override
  Widget build(BuildContext context) {
    Provider.of<UserProvider>(context).setUser(user);

    return const Scaffold(
      body: Center(
        child: Text("WELCOME PAGE"),
      ),
    );
  }
}