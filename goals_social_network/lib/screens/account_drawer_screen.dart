import 'package:flutter/material.dart';
import 'package:goals_social_network/services/globals.dart';

import '../models/auth_user.dart';
import '../services/auth_user_services.dart';

class AccountDrawerScreen extends StatefulWidget {
  const AccountDrawerScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AccountDrawerScreenState();
  }
}

class _AccountDrawerScreenState extends State<AccountDrawerScreen> {
  AuthUser? currentUser;

  getCurrentUser() async {
    currentUser = await AuthUserServices.getUser();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return currentUser == null
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text("Account menu"),
            ),
            body: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.grey,
                    //backgroundImage: new NetworkImage(friendsModel.profileImageUrl),
                  ),
                  title: Text(
                    '${currentUser?.firstName} ${currentUser?.lastName}',
                  ),
                  subtitle: Text(currentUser!.email),
                  trailing: IconButton(
                    icon: const Icon(Icons.manage_accounts),
                    tooltip: 'Configure account settings',
                    onPressed: () {
                      // Open account settings screen
                    },
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(50),
                  onTap: () {
                    Navigator.pushReplacementNamed(context, '/mygoals');
                  },
                  child: const Center(
                      heightFactor: 3,
                      child: Text(
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: baseColor),
                          'View my goals')),
                ),
                IconButton(
                  onPressed: () {
                    AuthUserServices.removeUser().then((value) =>
                        Navigator.pushReplacementNamed(context, '/signin'));
                  },
                  icon: const Icon(Icons.logout),
                ),
              ],
            ));
  }
}
